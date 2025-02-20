import SwiftUI
import os.log

/// A SwiftUI view that renders Portable Text JSON as native SwiftUI views.
///
/// `PortableTextRenderer` takes a Portable Text JSON string and renders it as native
/// SwiftUI views, prioritizing rendering speed and providing a modifier-based styling system.
public struct PortableTextRenderer: View {
    /// The Portable Text JSON string to render.
    private let json: String
    
    /// Optional closure for customizing error views.
    private let errorViewBuilder: ((PortableTextError) -> AnyView)?
    
    /// Internal state to track parsing and rendering errors.
    @State private var error: Error?
    
    /// Parsed blocks ready for rendering.
    @State private var blocks: [PortableTextBlock] = []
    
    /// Private logger for debugging
    private let logger = Logger(subsystem: "com.zmalltalker.portable-text-swift", category: "PortableTextRenderer")
    
    /// Creates a new Portable Text renderer with the specified JSON string.
    ///
    /// - Parameters:
    ///   - json: A string containing valid Portable Text JSON.
    ///   - errorView: An optional closure that returns a custom view for rendering errors.
    public init(json: String, errorView: ((PortableTextError) -> AnyView)? = nil) {
        self.json = json
        self.errorViewBuilder = errorView
    }
    
    /// The main rendering logic for the Portable Text content.
    public var body: some View {
        ZStack {
            if let error = error {
                handleError(error)
            } else if !blocks.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(0..<blocks.count, id: \.self) { index in
                        blocks[index].render(with: nil)
                    }
                }
                .padding()
            } else {
                Color.clear
                    .onAppear {
                        parseDocument()
                    }
            }
        }
    }
    
    /// Parses the Portable Text JSON document.
    private func parseDocument() {
        do {
            blocks = try PortableTextParser.parsePortableText(json)
            logger.debug("Successfully parsed document with \(blocks.count) blocks")
        } catch {
            logger.error("Error parsing document: \(error.localizedDescription)")
            self.error = error
        }
    }
    
    /// Handles errors by converting them to appropriate error views.
    ///
    /// - Parameter error: The error that occurred during parsing or rendering.
    /// - Returns: A view representing the error.
    private func handleError(_ error: Error) -> some View {
        let ptError: PortableTextError
        
        if let error = error as? PortableTextError {
            ptError = error
        } else {
            ptError = .rendering("Unexpected error: \(error.localizedDescription)")
        }
        
        if let errorViewBuilder = self.errorViewBuilder {
            return errorViewBuilder(ptError)
        } else {
            return defaultErrorView(for: ptError)
        }
    }
    
    /// Provides a default error view when no custom error view is specified.
    ///
    /// - Parameter error: The portable text error to display.
    /// - Returns: A default error view.
    private func defaultErrorView(for error: PortableTextError) -> some View {
        VStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.orange)
            
            Text("Error rendering content")
                .font(.headline)
            
            Text(error.localizedDescription)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(radius: 2)
    }
}
