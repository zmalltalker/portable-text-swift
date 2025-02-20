import SwiftUI

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
            } else {
                // Placeholder until we implement parsing and rendering
                Text("Portable Text will render here")
                    .onAppear {
                        // We'll implement parsing logic in later steps
                    }
            }
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
