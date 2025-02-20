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
    
    /// Styles to apply to different block types.
    private var styles: [String: PortableTextStyle] = [:]
    
    /// Spacing between blocks.
    private var blockSpacing: CGFloat = 12
    
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
        
        // Set up default styles
        setupDefaultStyles()
    }
    
    /// Sets up default styles for common block types.
    private mutating func setupDefaultStyles() {
        // Paragraph style
        styles["normal"] = PortableTextStyle(
            font: .body,
            foregroundColor: .primary,
            lineSpacing: 1.2
        )
        
        // Heading styles
        styles["h1"] = PortableTextStyle(
            font: .largeTitle.bold(),
            foregroundColor: .primary,
            lineSpacing: 1.0,
            padding: EdgeInsets(top: 24, leading: 0, bottom: 8, trailing: 0)
        )
        
        styles["h2"] = PortableTextStyle(
            font: .title.bold(),
            foregroundColor: .primary,
            lineSpacing: 1.0,
            padding: EdgeInsets(top: 20, leading: 0, bottom: 6, trailing: 0)
        )
        
        styles["h3"] = PortableTextStyle(
            font: .title2.bold(),
            foregroundColor: .primary,
            padding: EdgeInsets(top: 16, leading: 0, bottom: 4, trailing: 0)
        )
        
        styles["h4"] = PortableTextStyle(
            font: .title3.bold(),
            foregroundColor: .primary,
            padding: EdgeInsets(top: 14, leading: 0, bottom: 4, trailing: 0)
        )
        
        styles["h5"] = PortableTextStyle(
            font: .headline,
            foregroundColor: .primary,
            padding: EdgeInsets(top: 12, leading: 0, bottom: 4, trailing: 0)
        )
        
        styles["h6"] = PortableTextStyle(
            font: .subheadline.bold(),
            foregroundColor: .primary,
            padding: EdgeInsets(top: 10, leading: 0, bottom: 4, trailing: 0)
        )
        
        // Code block style
        styles["code"] = PortableTextStyle(
            font: .system(.body, design: .monospaced),
            backgroundColor: Color(.secondarySystemBackground),
            padding: EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
        )
    }
    
    /// The main rendering logic for the Portable Text content.
    public var body: some View {
        ZStack {
            if let error = error {
                handleError(error)
            } else if !blocks.isEmpty {
                renderBlocks(blocks, with: styles)
                    .padding()
            } else {
                Color.clear
                    .onAppear {
                        parseDocument()
                    }
            }
        }
    }
    
    /// Renders an array of blocks with the provided styles.
    ///
    /// - Parameters:
    ///   - blocks: The blocks to render.
    ///   - styles: The styles to apply to each block type.
    /// - Returns: A view containing the rendered blocks.
    private func renderBlocks(_ blocks: [PortableTextBlock], with styles: [String: PortableTextStyle]) -> some View {
        VStack(alignment: .leading, spacing: blockSpacing) {
            ForEach(0..<blocks.count, id: \.self) { index in
                let block = blocks[index]
                let blockStyle: PortableTextStyle?
                
                if let style = block is Heading ? styles["\(block.style)"] : styles[block._type] {
                    blockStyle = style
                } else if let style = styles["normal"] {  // Fallback to normal style
                    blockStyle = style
                } else {
                    blockStyle = nil
                }
                
                block.render(with: blockStyle)
            }
        }
    }
    
    /// Parses the Portable Text JSON document.
    private func parseDocument() {
        do {
            let parsedBlocks = try PortableTextParser.parsePortableText(json)
            blocks = parsedBlocks
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
    
    /// Sets a style for a specific block type.
    ///
    /// - Parameters:
    ///   - type: The block type or style to set a style for.
    ///   - style: The style to apply.
    /// - Returns: A new renderer with the updated style.
    public func portableTextStyle(_ type: String, _ style: PortableTextStyle) -> PortableTextRenderer {
        var renderer = self
        renderer.styles[type] = style
        return renderer
    }
    
    /// Sets the spacing between blocks.
    ///
    /// - Parameter spacing: The amount of spacing to apply between blocks.
    /// - Returns: A new renderer with the updated spacing.
    public func portableTextBlockSpacing(_ spacing: CGFloat) -> PortableTextRenderer {
        var renderer = self
        renderer.blockSpacing = spacing
        return renderer
    }
}
