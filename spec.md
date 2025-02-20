# SwiftUI Portable Text Renderer
## Developer Implementation Specification

## 1. Overview
A Swift Package for rendering Portable Text from Sanity CMS as native SwiftUI text elements. This library converts Portable Text JSON into native SwiftUI views with attributed text, prioritizing rendering speed and providing a modifier-based styling system.

## 2. Requirements

### 2.1 Functional Requirements
- Parse pre-fetched Portable Text JSON strings
- Render basic text formatting (bold, italic, underline)
- Support headings (h1-h6) with customizable styling
- Render lists (ordered and unordered)
- Support code blocks with monospaced font and indentation
- Render simple tables as grid layouts
- Support one level of nesting for block elements
- Integrate links with SwiftUI's navigation system via deep links
- Generate optional table of contents from headings
- Support custom rendering of images and embedded objects
- Handle text direction manually (LTR/RTL)

### 2.2 Non-Functional Requirements
- Prioritize rendering speed over memory usage
- Fail fast with clear error messages
- Support static content (no real-time updates)
- Minimal external dependencies
- Distribution as a Swift Package
- Platform default accessibility support

## 3. Architecture

### 3.1 Core Components

#### PortableTextRenderer
```swift
struct PortableTextRenderer: View {
    let json: String
    let errorViewBuilder: ((PortableTextError) -> AnyView)?
    
    init(json: String, errorView: ((PortableTextError) -> AnyView)? = nil)
    
    var body: some View {
        // Main rendering logic
    }
}
```

#### PortableTextBlock Protocol
```swift
protocol PortableTextBlock {
    var _type: String { get }
    var _key: String { get }
    var markDefs: [PortableTextMarkDefinition]? { get }
    var children: [PortableTextSpan]? { get }
    
    func render(with style: PortableTextStyle) -> AnyView
}
```

#### PortableTextStyle
```swift
struct PortableTextStyle {
    // Core styling properties
    let font: Font?
    let foregroundColor: Color?
    let backgroundColor: Color?
    let lineSpacing: CGFloat?
    let padding: EdgeInsets?
    let alignment: TextAlignment?
    
    // Initialization with defaults
    init(
        font: Font? = nil,
        foregroundColor: Color? = nil,
        backgroundColor: Color? = nil,
        lineSpacing: CGFloat? = nil,
        padding: EdgeInsets? = nil,
        alignment: TextAlignment? = nil
    )
    
    // Factory methods for standard styles
    static var heading1: PortableTextStyle
    static var heading2: PortableTextStyle
    // etc.
}
```

#### PortableTextError
```swift
enum PortableTextError: Error {
    case invalidJSON(String)
    case unsupportedBlockType(String)
    case unsupportedMarkType(String)
    case missingRequiredField(String)
    case nestedContentTooDeep
    case malformedStructure(String)
    case rendering(String)
}
```

#### HeadingItem (for Table of Contents)
```swift
struct HeadingItem: Identifiable, Equatable {
    let id: String
    let text: String
    let level: Int
}
```

### 3.2 Extension Points

#### Custom Renderers
```swift
typealias CustomBlockRenderer = (PortableTextBlock) -> AnyView?
typealias CustomMarkRenderer = (PortableTextMark, AttributedString) -> AttributedString?
typealias CustomLinkHandler = (URL) -> Void
```

#### Styling Environment Keys
```swift
struct PortableTextStyleKey: EnvironmentKey {
    static var defaultValue: [String: PortableTextStyle] = [:]
}

extension EnvironmentValues {
    var portableTextStyles: [String: PortableTextStyle] {
        get { self[PortableTextStyleKey.self] }
        set { self[PortableTextStyleKey.self] = newValue }
    }
}
```

## 4. Data Model

### 4.1 Portable Text JSON Structure
```swift
// Root structure
struct PortableTextDocument: Codable {
    let blocks: [PortableTextBlockData]
}

// Block data
struct PortableTextBlockData: Codable {
    let _type: String
    let _key: String
    let style: String?
    let markDefs: [PortableTextMarkDefinition]?
    let children: [PortableTextSpan]?
    let level: Int?
    let listItem: String?
}

// Span data
struct PortableTextSpan: Codable {
    let _type: String
    let _key: String?
    let text: String
    let marks: [String]?
}

// Mark definition
struct PortableTextMarkDefinition: Codable {
    let _type: String
    let _key: String
    let href: String?
    // Other mark-specific fields
}
```

### 4.2 Internal Models
Convert the JSON structures to these internal models for rendering:

```swift
// Implementation of the PortableTextBlock protocol
struct Paragraph: PortableTextBlock {
    let _type: String = "block"
    let _key: String
    let style: String
    let markDefs: [PortableTextMarkDefinition]?
    let children: [PortableTextSpan]?
    
    func render(with style: PortableTextStyle) -> AnyView {
        // Rendering implementation
    }
}

struct Heading: PortableTextBlock {
    let _type: String = "block"
    let _key: String
    let style: String // h1, h2, etc.
    let level: Int
    let markDefs: [PortableTextMarkDefinition]?
    let children: [PortableTextSpan]?
    
    func render(with style: PortableTextStyle) -> AnyView {
        // Rendering implementation
    }
}

// Similar implementations for List, CodeBlock, Table, etc.
```

## 5. Implementation Details

### 5.1 JSON Parsing Process
1. Decode JSON string to `PortableTextDocument` using `JSONDecoder`
2. Validate required fields and structure
3. Convert to internal block models
4. Throw appropriate errors for invalid structures

```swift
func parsePortableText(_ json: String) throws -> [PortableTextBlock] {
    guard let jsonData = json.data(using: .utf8) else {
        throw PortableTextError.invalidJSON("Cannot convert string to data")
    }
    
    let decoder = JSONDecoder()
    do {
        let document = try decoder.decode(PortableTextDocument.self, from: jsonData)
        return try convertToBlocks(document.blocks)
    } catch let decodingError as DecodingError {
        throw PortableTextError.invalidJSON("JSON decoding failed: \(decodingError)")
    } catch {
        throw error
    }
}

func convertToBlocks(_ blockData: [PortableTextBlockData]) throws -> [PortableTextBlock] {
    // Implementation
}
```

### 5.2 Rendering Process
1. Parse JSON into structured data
2. Apply styles to each block type
3. Process marks to create attributed strings
4. Handle custom renderers if provided
5. Assemble final SwiftUI view hierarchy

```swift
func renderBlocks(_ blocks: [PortableTextBlock], with styles: [String: PortableTextStyle]) -> some View {
    VStack(alignment: .leading, spacing: 12) {
        ForEach(blocks, id: \._key) { block in
            let style = styles[block._type] ?? PortableTextStyle.defaultForType(block._type)
            block.render(with: style)
        }
    }
}
```

### 5.3 Attributed String Creation
```swift
func createAttributedString(from spans: [PortableTextSpan], markDefs: [PortableTextMarkDefinition]) -> AttributedString {
    var attributedString = AttributedString("")
    
    for span in spans {
        var spanText = AttributedString(span.text)
        
        // Apply marks to the span
        if let marks = span.marks {
            for mark in marks {
                if let markDef = markDefs.first(where: { $0._key == mark }) {
                    spanText = applyMarkDefinition(markDef, to: spanText)
                } else {
                    spanText = applyStandardMark(mark, to: spanText)
                }
            }
        }
        
        attributedString.append(spanText)
    }
    
    return attributedString
}
```

### 5.4 Table of Contents Generation
```swift
func generateTableOfContents(from blocks: [PortableTextBlock]) -> [HeadingItem] {
    return blocks.compactMap { block in
        guard 
            let heading = block as? Heading,
            let firstChild = heading.children?.first,
            !firstChild.text.isEmpty
        else {
            return nil
        }
        
        return HeadingItem(
            id: heading._key,
            text: firstChild.text,
            level: heading.level
        )
    }
}
```

### 5.5 Custom Rendering Hooks
```swift
// Custom block renderer
func renderCustomBlock(_ block: PortableTextBlock, 
                      renderers: [String: CustomBlockRenderer]) -> AnyView? {
    guard let renderer = renderers[block._type] else {
        return nil
    }
    
    return renderer(block)
}

// Custom mark renderer
func renderCustomMark(_ mark: String, 
                     in attributedString: AttributedString,
                     renderers: [String: CustomMarkRenderer]) -> AttributedString? {
    guard let renderer = renderers[mark] else {
        return nil
    }
    
    // Implementation
}
```

## 6. Error Handling Strategy

### 6.1 Error Types
- `invalidJSON`: JSON parsing or structure issues
- `unsupportedBlockType`: Unknown block types
- `unsupportedMarkType`: Unknown mark types
- `missingRequiredField`: Missing critical data
- `nestedContentTooDeep`: Nesting exceeds supported depth
- `malformedStructure`: Invalid content structure
- `rendering`: Runtime rendering issues

### 6.2 Error Handling Flow
1. Try to parse JSON and validate structure
2. If parsing fails, wrap in appropriate `PortableTextError`
3. Surface error to optional error view builder
4. Log detailed error information for debugging

```swift
func handleError(_ error: Error) -> some View {
    let ptError: PortableTextError
    
    if let error = error as? PortableTextError {
        ptError = error
    } else {
        ptError = .rendering("Unexpected error: \(error.localizedDescription)")
    }
    
    if let errorViewBuilder = self.errorViewBuilder {
        return errorViewBuilder(ptError)
    } else {
        return Text("Error rendering content: \(ptError.localizedDescription)")
            .foregroundColor(.red)
            .eraseToAnyView()
    }
}
```

## 7. SwiftUI Modifiers

### 7.1 Style Modifiers
```swift
extension PortableTextRenderer {
    func portableTextStyle(_ type: String, _ style: PortableTextStyle) -> PortableTextRenderer {
        var renderer = self
        renderer.styles[type] = style
        return renderer
    }
    
    func portableTextStyleForHeading(_ level: Int, _ style: PortableTextStyle) -> PortableTextRenderer {
        return portableTextStyle("h\(level)", style)
    }
}
```

### 7.2 Custom Renderer Modifiers
```swift
extension PortableTextRenderer {
    func portableTextCustomRenderer(forType type: String, 
                                   renderer: @escaping CustomBlockRenderer) -> PortableTextRenderer {
        var newRenderer = self
        newRenderer.customBlockRenderers[type] = renderer
        return newRenderer
    }
    
    func portableTextCustomMarkRenderer(forType type: String,
                                       renderer: @escaping CustomMarkRenderer) -> PortableTextRenderer {
        var newRenderer = self
        newRenderer.customMarkRenderers[type] = renderer
        return newRenderer
    }
}
```

### 7.3 Link Handler Modifier
```swift
extension PortableTextRenderer {
    func portableTextLinkHandler(_ handler: @escaping CustomLinkHandler) -> PortableTextRenderer {
        var newRenderer = self
        newRenderer.linkHandler = handler
        return newRenderer
    }
}
```

### 7.4 Error View Modifier
```swift
extension PortableTextRenderer {
    func portableTextErrorView<V: View>(_ builder: @escaping (PortableTextError) -> V) -> PortableTextRenderer {
        var newRenderer = self
        newRenderer.errorViewBuilder = { error in
            AnyView(builder(error))
        }
        return newRenderer
    }
}
```

### 7.5 Table of Contents Modifier
```swift
extension PortableTextRenderer {
    func tableOfContents(_ binding: Binding<[HeadingItem]>) -> PortableTextRenderer {
        var newRenderer = self
        newRenderer.tocBinding = binding
        return newRenderer
    }
}
```

### 7.6 Text Direction Modifier
```swift
extension PortableTextRenderer {
    func textDirection(_ direction: TextDirection) -> PortableTextRenderer {
        var newRenderer = self
        newRenderer.textDirection = direction
        return newRenderer
    }
}
```

## 8. Usage Examples

### 8.1 Basic Usage
```swift
struct ContentView: View {
    let portableTextJSON: String = """
    {
      "blocks": [
        {
          "_type": "block",
          "_key": "a1b2c3",
          "style": "h1",
          "children": [
            {
              "_type": "span",
              "text": "Hello World",
              "marks": []
            }
          ]
        },
        {
          "_type": "block",
          "_key": "d4e5f6",
          "style": "normal",
          "children": [
            {
              "_type": "span",
              "text": "This is a paragraph with ",
              "marks": []
            },
            {
              "_type": "span",
              "text": "bold",
              "marks": ["strong"]
            },
            {
              "_type": "span",
              "text": " and ",
              "marks": []
            },
            {
              "_type": "span",
              "text": "italic",
              "marks": ["em"]
            },
            {
              "_type": "span",
              "text": " text.",
              "marks": []
            }
          ]
        }
      ]
    }
    """
    
    var body: some View {
        ScrollView {
            PortableTextRenderer(json: portableTextJSON)
                .padding()
        }
    }
}
```

### 8.2 Advanced Usage
```swift
struct DocumentView: View {
    let portableTextJSON: String
    @State private var tocItems: [HeadingItem] = []
    @State private var showError = false
    @State private var currentError: PortableTextError?
    
    var body: some View {
        VStack {
            if !tocItems.isEmpty {
                TableOfContentsView(items: tocItems)
                    .frame(maxHeight: 200)
                    .padding()
                    .background(Color.gray.opacity(0.1))
            }
            
            ScrollView {
                PortableTextRenderer(json: portableTextJSON)
                    .portableTextStyle("normal", .init(
                        font: .body,
                        foregroundColor: .primary,
                        lineSpacing: 1.3
                    ))
                    .portableTextStyleForHeading(1, .init(
                        font: .largeTitle.bold(),
                        foregroundColor: .blue,
                        padding: EdgeInsets(top: 24, leading: 0, bottom: 8, trailing: 0)
                    ))
                    .portableTextStyleForHeading(2, .init(
                        font: .title2.bold(),
                        foregroundColor: .blue.opacity(0.8),
                        padding: EdgeInsets(top: 16, leading: 0, bottom: 4, trailing: 0)
                    ))
                    .portableTextStyle("code", .init(
                        font: .system(.body, design: .monospaced),
                        backgroundColor: Color(.systemGray6),
                        padding: EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
                    ))
                    .portableTextCustomRenderer(forType: "image") { block in
                        if let url = block.imageUrl {
                            return AnyView(
                                AsyncImage(url: url) { image in
                                    image.resizable().aspectRatio(contentMode: .fit)
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(maxWidth: .infinity)
                            )
                        }
                        return nil
                    }
                    .portableTextLinkHandler { url in
                        UIApplication.shared.open(url)
                    }
                    .portableTextErrorView { error in
                        VStack(spacing: 12) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.largeTitle)
                                .foregroundColor(.orange)
                            
                            Text("Content could not be displayed")
                                .font(.headline)
                            
                            Button("View Error Details") {
                                currentError = error
                                showError = true
                            }
                            .font(.subheadline)
                        }
                        .frame(maxWidth: .infinity, minHeight: 200)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    }
                    .tableOfContents($tocItems)
                    .textDirection(.leftToRight)
                    .padding()
            }
        }
        .alert(isPresented: $showError, content: {
            Alert(
                title: Text("Error"),
                message: Text(currentError?.localizedDescription ?? "Unknown error"),
                dismissButton: .default(Text("OK"))
            )
        })
    }
}
```

## 9. Testing Plan

### 9.1 Unit Tests

#### JSON Parsing Tests
- Test parsing valid Portable Text JSON
- Test handling malformed JSON
- Test handling missing required fields
- Test handling unsupported block types
- Test handling unsupported mark types

#### Rendering Tests
- Test rendering basic block types
- Test rendering with styling applied
- Test rendering with custom renderers
- Test handling of nested content
- Test table of contents generation

#### Style Tests
- Test style application to different block types
- Test style inheritance and overrides
- Test text direction handling

#### Error Handling Tests
- Test error propagation
- Test custom error view rendering
- Test graceful degradation for unsupported content

### 9.2 Integration Tests
- Test integration with SwiftUI navigation
- Test rendering complex documents
- Test performance with large documents
- Test memory usage patterns

### 9.3 UI Tests
- Test accessibility with VoiceOver
- Test appearance with different color schemes
- Test dynamic type size adaptation

## 10. Performance Considerations

### 10.1 Optimizations
- Lazy rendering of complex blocks
- Efficient attributed string creation
- Minimize view hierarchy depth
- Avoid unnecessary re-renders

### 10.2 Benchmarks
- Measure rendering time for documents of varying complexity:
  - Simple text-only documents
  - Documents with mixed formatting
  - Documents with tables and nested content
- Measure memory usage patterns

## 11. Limitations

- Supports only one level of nesting for block elements
- Limited table styling options
- No support for real-time content updates or animations
- No automatic handling for strikethrough, superscript, or other complex formatting
- No built-in caching mechanism
- Relies on platform defaults for accessibility

## 12. Implementation Timeline

### Phase 1: Core Architecture (Week 1)
- Set up Swift Package structure
- Implement JSON parsing
- Define core protocols and data models
- Basic error handling

### Phase 2: Basic Rendering (Week 2)
- Implement paragraph and heading rendering
- Support for basic formatting (bold, italic)
- Style application system

### Phase 3: Advanced Features (Week 3)
- Lists and code blocks
- Table rendering
- Link handling
- Custom renderer hooks

### Phase 4: Polish and Optimization (Week 4)
- Table of contents generation
- Performance optimization
- Comprehensive error handling
- Documentation and examples

## 13. Documentation Plan

### 13.1 API Documentation
- Full documentation comments for all public APIs
- Usage examples for common scenarios
- Clear explanation of extension points

### 13.2 Integration Guide
- Step-by-step guide for integrating with Sanity
- Common patterns and best practices
- Troubleshooting guide

### 13.3 Style Guide
- Explanation of styling system
- Examples of custom style creation
- Performance considerations when styling

## 14. Maintenance Plan

### 14.1 Version Strategy
- Semantic versioning (MAJOR.MINOR.PATCH)
- Breaking changes only in major versions
- Feature additions in minor versions
- Bug fixes in patch versions

### 14.2 Backward Compatibility
- Maintain compatibility with previous Portable Text schemas
- Deprecation notices before removing features
- Migration guides for major versions
