# Development Plan for SwiftUI Portable Text Renderer

I'll create a detailed, step-by-step blueprint for building the SwiftUI Portable Text Renderer library, breaking it down into small, iterative chunks that build on each other.

## Analyzing Project Requirements

The SwiftUI Portable Text Renderer needs to:
1. Parse Portable Text JSON
2. Convert it to native SwiftUI views with attributed text
3. Support styling through modifiers
4. Handle errors gracefully
5. Allow custom rendering for specific elements
6. Generate table of contents from headings

## High-Level Development Blueprint

1. Set up project structure
2. Define core data models and protocols
3. Implement JSON parsing
4. Create basic rendering pipeline
5. Add styling system
6. Implement error handling
7. Add extension points for customization
8. Enhance with additional features (TOC, custom renderers)
9. Optimize performance
10. Add documentation and examples

## Breaking Down Into Smaller Steps

### Phase 1: Foundation
1. Create Swift Package with basic structure
2. Define core protocols and data models
3. Implement basic Portable Text JSON parsing
4. Create simple renderer for plain text

### Phase 2: Basic Rendering
5. Implement paragraph rendering with AttributedString
6. Add support for basic marks (bold, italic)
7. Implement heading rendering
8. Add basic styling system

### Phase 3: Error Handling
9. Define error types and handling strategy
10. Implement parsing error detection
11. Create error view rendering system

### Phase 4: Advanced Features
12. Implement list rendering
13. Add code block support
14. Implement link handling
15. Create table rendering

### Phase 5: Extension Points
16. Implement custom block renderer system
17. Add custom mark renderer support
18. Create link handler extension

### Phase 6: Polish Features
19. Implement table of contents generation
20. Add text direction support
21. Optimize performance
22. Create comprehensive examples

## Detailed Step-by-Step Plan with Prompts

Here are the detailed prompts for implementing each step:

### Step 1: Project Setup

```
Create a new Swift Package for the SwiftUI Portable Text Renderer library. Set up the basic structure with a main PortableTextRenderer view struct that conforms to SwiftUI's View protocol. The initial implementation should accept a JSON string but not do any parsing yet. Include proper package configuration with SwiftUI as a dependency.
```

### Step 2: Core Data Models

```
Building on the Swift Package created in Step 1, define the core data models needed for Portable Text. Create Codable structs for:
1. PortableTextDocument (root container)
2. PortableTextBlockData (for blocks like paragraphs and headings)
3. PortableTextSpan (for text spans)
4. PortableTextMarkDefinition (for mark definitions like links)

Also create a PortableTextBlock protocol that will be implemented by different block types (Paragraph, Heading, etc.). The protocol should include requirements for _type, _key, markDefs, children, and a render method that takes a style parameter.
```

### Step 3: Basic JSON Parsing

```
Implement the JSON parsing functionality for the PortableTextRenderer. Create a parsePortableText function that:
1. Takes a JSON string
2. Converts it to Data
3. Uses JSONDecoder to decode into PortableTextDocument
4. Handles basic parsing errors
5. Returns an array of decoded blocks

For now, just focus on the parsing logic without worrying about converting to view models or rendering. Make sure to handle malformed JSON appropriately.
```

### Step 4: Error Types and Handling

```
Create a comprehensive error handling system for the library. Define a PortableTextError enum that conforms to Error with cases for:
- invalidJSON
- unsupportedBlockType
- unsupportedMarkType
- missingRequiredField
- nestedContentTooDeep
- malformedStructure
- rendering

Each case should include associated values for context. Then update the parsing function from Step 3 to use these specific error types. Add an errorViewBuilder parameter to PortableTextRenderer that allows custom error views.
```

### Step 5: Simple Text Rendering

```
Implement basic text rendering for the PortableTextRenderer. Create a concrete Paragraph struct that implements the PortableTextBlock protocol. The render method should:
1. Extract text from children spans
2. Create a simple Text view with the content
3. Return it wrapped in AnyView

Update the PortableTextRenderer to use these blocks for rendering basic paragraphs. Don't worry about styling or marks yet, just focus on getting plain text to display properly from the parsed JSON.
```

### Step 6: AttributedString Creation

```
Enhance the text rendering capability by implementing AttributedString creation. Create a utility function createAttributedString that:
1. Takes an array of PortableTextSpan and markDefs
2. Iterates through spans, creating AttributedString segments
3. Concatenates them into a single AttributedString
4. Returns the complete AttributedString

Update the Paragraph render method to use this function and display the resulting AttributedString using Text. This will prepare us for adding mark support in the next step.
```

### Step 7: Basic Mark Support

```
Implement support for basic marks (bold, italic, underline) in the AttributedString creation. Extend the createAttributedString function to:
1. Check for standard marks like "strong", "em", and "underline"
2. Apply corresponding attributes to the AttributedString
3. Handle multiple marks on the same span

Create a utility function applyStandardMark that takes a mark name and an AttributedString and returns the modified AttributedString with appropriate attributes applied.
```

### Step 8: Heading Implementation

```
Building on the previous steps, implement support for headings. Create a Heading struct that implements the PortableTextBlock protocol. The render method should:
1. Determine the heading level (h1-h6)
2. Create an AttributedString from children
3. Apply appropriate font size and weight based on heading level
4. Return a Text view with the styled AttributedString

Update the PortableTextRenderer to handle both paragraphs and headings based on the block's style property.
```

### Step 9: Basic Styling System

```
Implement a basic styling system for the library. Create a PortableTextStyle struct with properties for:
- font
- foregroundColor
- backgroundColor  
- lineSpacing
- padding
- alignment

Provide factory methods for standard styles. Then update the PortableTextRenderer to accept and store styles, and pass them to the blocks during rendering. Implement a portableTextStyle modifier that allows setting styles for specific block types.
```

### Step 10: Style Modifier Implementation

```
Enhance the styling system by implementing SwiftUI modifiers. Create extensions for PortableTextRenderer that provide:
1. portableTextStyle(for:style:) - Sets style for a specific block type
2. portableTextStyleForHeading(level:style:) - Convenience for heading styles

Update the renderer to store these styles in a dictionary keyed by block type. Make sure the modifier functions return an updated copy of the renderer (following SwiftUI modifier pattern). Test that styles are correctly applied to different block types.
```

### Step 11: List Rendering

```
Implement support for ordered and unordered lists. Create a List struct implementing PortableTextBlock that:
1. Determines list type (ordered/unordered)
2. Extracts list items and their content
3. Renders appropriate bullet or number prefixes
4. Applies correct indentation
5. Supports simple nesting (one level)

Update the PortableTextRenderer to handle list blocks. Ensure styles can be applied to lists and list items separately.
```

### Step 12: Code Block Support

```
Add support for code blocks. Create a CodeBlock struct implementing PortableTextBlock that:
1. Extracts code content from spans
2. Applies monospaced font
3. Preserves whitespace and indentation
4. Supports optional background color
5. Handles language specification if present

Implement a default code block style with appropriate monospaced font and background. Update the renderer to handle code blocks appropriately.
```

### Step 13: Link Implementation

```
Implement support for links in the portable text. Enhance the createAttributedString function to:
1. Detect link marks in spans
2. Find corresponding mark definitions with href
3. Apply link attributes to the AttributedString

Add a CustomLinkHandler type and linkHandler property to PortableTextRenderer. Create a portableTextLinkHandler modifier that allows custom handling of link taps, with integration to SwiftUI navigation if desired.
```

### Step 14: Custom Block Renderer System

```
Create an extension point for custom block rendering. Implement:
1. A CustomBlockRenderer type alias
2. Storage for custom renderers in PortableTextRenderer
3. A portableTextCustomRenderer modifier
4. Logic to check for custom renderers before standard rendering

Update the rendering pipeline to attempt custom rendering first, falling back to standard rendering if no custom renderer is provided for a block type.
```

### Step 15: Custom Mark Renderer Support

```
Similarly to custom block renderers, implement support for custom mark renderers:
1. Create a CustomMarkRenderer type alias
2. Add storage for custom mark renderers
3. Implement a portableTextCustomMarkRenderer modifier
4. Update the AttributedString creation to check for custom renderers

Ensure that custom mark renderers can be combined with standard marks and with each other.
```

### Step 16: Table of Contents Generation

```
Implement table of contents generation. Create:
1. A HeadingItem struct to represent TOC entries
2. A generateTableOfContents function that extracts headings
3. A tocBinding property in PortableTextRenderer
4. A tableOfContents modifier that accepts a binding

Update the rendering process to populate the TOC binding when headings are rendered.
```

### Step 17: Table Rendering

```
Add support for simple tables. Create a Table struct implementing PortableTextBlock that:
1. Extracts table structure (rows and cells)
2. Creates a grid layout using SwiftUI's LazyVGrid
3. Handles header rows if specified
4. Applies basic cell styling

Implement default table styles and ensure the styling system works with tables.
```

### Step 18: Text Direction Support

```
Implement text direction support. Add:
1. A TextDirection enum (leftToRight, rightToLeft)
2. A textDirection property to PortableTextRenderer
3. A textDirection modifier
4. Logic to apply direction to rendered text

Update the rendering pipeline to respect the specified text direction.
```

### Step 19: Performance Optimization

```
Optimize the rendering performance. Implement:
1. Efficient AttributedString creation
2. Minimizing view hierarchy depth
3. Avoiding unnecessary re-renders
4. Using appropriate data structures for lookups

Profile the rendering pipeline and make targeted improvements to areas that impact performance the most.
```

### Step 20: Comprehensive Examples and Documentation

```
Create comprehensive usage examples and documentation. Implement:
1. Basic usage example with minimal configuration
2. Advanced usage with custom styling and renderers
3. Error handling example
4. Table of contents example
5. Complete documentation comments for all public APIs

Ensure examples demonstrate all major features of the library.
```

## Final Integration Prompt

```
Now that we've implemented all the core components of the SwiftUI Portable Text Renderer, let's integrate everything into a cohesive library. Update the main PortableTextRenderer to properly coordinate all the features:

1. JSON parsing with comprehensive error handling
2. Converting parsed blocks to view models
3. Applying the styling system
4. Supporting all block types (paragraphs, headings, lists, code blocks, tables)
5. Using the AttributedString creation with mark support
6. Handling links with custom handlers
7. Supporting custom renderers for blocks and marks
8. Generating table of contents
9. Respecting text direction

Make sure all the extension points work together correctly and the library presents a clean, consistent API. Add any missing pieces needed for a complete implementation according to the specification.
```

## Code Review Prompt

```
Review the implementation of the SwiftUI Portable Text Renderer library. Check for:

1. Adherence to Swift and SwiftUI best practices
2. Proper error handling throughout
3. Consistency in the API design
4. Performance considerations
5. Memory management
6. Extensibility of the system
7. Compatibility with different SwiftUI environments
8. Comprehensive documentation

Identify any potential issues, edge cases, or improvements that should be addressed before the final release.
```

## Validation Against Requirements Prompt

```
Validate the SwiftUI Portable Text Renderer library against the original requirements. Ensure that it:

1. Parses pre-fetched Portable Text JSON strings correctly
2. Renders all required text formatting (bold, italic, underline)
3. Supports headings (h1-h6) with customizable styling
4. Renders lists (ordered and unordered)
5. Supports code blocks with monospaced font and indentation
6. Renders simple tables as grid layouts
7. Supports one level of nesting for block elements
8. Integrates links with SwiftUI's navigation system
9. Generates table of contents from headings
10. Supports custom rendering of images and embedded objects
11. Handles text direction (LTR/RTL)
12. Prioritizes rendering speed
13. Fails fast with clear error messages
14. Works with static content
15. Has minimal external dependencies
16. Is distributed as a Swift Package
17. Uses platform default accessibility

Create test cases for each requirement to verify correctness.
```

## Step Revisions and Iterative Refinement

After reviewing the steps above, let's refine them to ensure they're appropriately sized and build incrementally without gaps:

### Refined Step 1: Basic Package Structure

```
Create a Swift Package named "PortableTextRenderer" with SwiftUI as a dependency. Set up the following basic structure:
1. A main PortableTextRenderer.swift file with a public struct PortableTextRenderer: View
2. An empty Models directory for data models
3. An empty Rendering directory for rendering logic
4. An empty Styling directory for styling components
5. An empty Errors directory for error handling

The initial PortableTextRenderer should accept a JSON string parameter but not process it yet. Include a simple placeholder Text view in the body that says "Portable Text Renderer".
```

### Refined Step 2: Error Handling Foundation

```
Building on Step 1, implement the error handling foundation. Create PortableTextError.swift in the Errors directory with:

1. A public enum PortableTextError: Error with cases:
   - invalidJSON(String)
   - unsupportedBlockType(String)
   - unsupportedMarkType(String)
   - missingRequiredField(String)
   - nestedContentTooDeep
   - malformedStructure(String)
   - rendering(String)

2. Extension with localizedDescription implementation

3. Update PortableTextRenderer to include:
   - An optional errorViewBuilder parameter of type ((PortableTextError) -> AnyView)?
   - A private method handleError that wraps errors and uses the errorViewBuilder

This establishes the error handling pattern we'll use throughout the library.
```

### Refined Step 3: Basic Data Models

```
Building on the previous steps, create the core data models needed to represent Portable Text. In the Models directory, create:

1. PortableTextDocument.swift with:
   ```swift
   struct PortableTextDocument: Codable {
       let blocks: [PortableTextBlockData]
   }
   ```

2. PortableTextBlockData.swift with:
   ```swift
   struct PortableTextBlockData: Codable {
       let _type: String
       let _key: String
       let style: String?
       let markDefs: [PortableTextMarkDefinition]?
       let children: [PortableTextSpan]?
       let level: Int?
       let listItem: String?
   }
   ```

3. PortableTextSpan.swift with:
   ```swift
   struct PortableTextSpan: Codable {
       let _type: String
       let _key: String?
       let text: String
       let marks: [String]?
   }
   ```

4. PortableTextMarkDefinition.swift with:
   ```swift
   struct PortableTextMarkDefinition: Codable {
       let _type: String
       let _key: String
       let href: String?
       // Other mark-specific fields can be added later
   }
   ```

These models match the JSON structure of Portable Text and will be used for decoding.
```

### Refined Step 4: PortableTextBlock Protocol

```
Building on Step 3, define the core protocol that all block types will implement. In the Rendering directory, create PortableTextBlock.swift with:

```swift
protocol PortableTextBlock {
    var _type: String { get }
    var _key: String { get }
    var markDefs: [PortableTextMarkDefinition]? { get }
    var children: [PortableTextSpan]? { get }
    
    func render(with style: PortableTextStyle?) -> AnyView
}
```

For now, create an empty PortableTextStyle struct in Styling/PortableTextStyle.swift:

```swift
struct PortableTextStyle {
    // We'll populate this in later steps
}
```

This establishes the foundation for our block rendering system.
```

### Refined Step 5: Basic JSON Parsing

```
Building on the previous steps, implement JSON parsing functionality. Create a new file Parsing/PortableTextParser.swift with:

```swift
struct PortableTextParser {
    static func parse(_ json: String) throws -> PortableTextDocument {
        guard let jsonData = json.data(using: .utf8) else {
            throw PortableTextError.invalidJSON("Cannot convert string to data")
        }
        
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(PortableTextDocument.self, from: jsonData)
        } catch let decodingError as DecodingError {
            throw PortableTextError.invalidJSON("JSON decoding failed: \(decodingError)")
        } catch {
            throw error
        }
    }
}
```

Then update the PortableTextRenderer to use this parser in an initial attempt:

```swift
struct PortableTextRenderer: View {
    let json: String
    let errorViewBuilder: ((PortableTextError) -> AnyView)?
    
    @State private var document: PortableTextDocument?
    @State private var error: Error?
    
    init(json: String, errorView: ((PortableTextError) -> AnyView)? = nil) {
        self.json = json
        self.errorViewBuilder = errorView
    }
    
    var body: some View {
        ZStack {
            if let error = error {
                handleError(error)
            } else if document != nil {
                Text("Successfully parsed document")
            } else {
                Text("Parsing...")
                    .onAppear {
                        parseDocument()
                    }
            }
        }
    }
    
    private func parseDocument() {
        do {
            document = try PortableTextParser.parse(json)
        } catch {
            self.error = error
        }
    }
    
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
            return Text("Error rendering content: \(ptError.localizedDescription)")
                .foregroundColor(.red)
        }
    }
}
```

This gives us basic parsing with proper error handling.
```

### Refined Step 6: First Block Implementation (Paragraph)

```
Building on the previous steps, implement the first concrete block type - Paragraph. Create Rendering/Blocks/Paragraph.swift:

```swift
struct Paragraph: PortableTextBlock {
    let _type: String
    let _key: String
    let style: String
    let markDefs: [PortableTextMarkDefinition]?
    let children: [PortableTextSpan]?
    
    func render(with style: PortableTextStyle?) -> AnyView {
        // For now, just extract and display the text without formatting
        let text = children?.compactMap { $0.text }.joined() ?? ""
        return AnyView(
            Text(text)
                .fixedSize(horizontal: false, vertical: true)
        )
    }
}
```

Now create a BlockFactory in Rendering/BlockFactory.swift:

```swift
struct BlockFactory {
    static func createBlock(from blockData: PortableTextBlockData) throws -> PortableTextBlock {
        switch blockData._type {
        case "block":
            if blockData.style == "normal" || blockData.style == nil {
                return Paragraph(
                    _type: blockData._type,
                    _key: blockData._key,
                    style: blockData.style ?? "normal",
                    markDefs: blockData.markDefs,
                    children: blockData.children
                )
            }
            // We'll handle other block styles later
            throw PortableTextError.unsupportedBlockType("Unsupported block style: \(blockData.style ?? "unknown")")
        default:
            throw PortableTextError.unsupportedBlockType("Unsupported block type: \(blockData._type)")
        }
    }
}
```

Update the PortableTextRenderer to use these components:

```swift
// Add to PortableTextRenderer
@State private var blocks: [PortableTextBlock] = []

// Update parseDocument()
private func parseDocument() {
    do {
        let document = try PortableTextParser.parse(json)
        self.document = document
        self.blocks = try document.blocks.map { blockData in
            try BlockFactory.createBlock(from: blockData)
        }
    } catch {
        self.error = error
    }
}

// Update body
var body: some View {
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
            Text("Parsing...")
                .onAppear {
                    parseDocument()
                }
        }
    }
}
```

This gives us the ability to render simple paragraphs from Portable Text.
```

### Refined Step 7: Basic Style System

```
Building on the previous steps, implement a basic styling system. Update Styling/PortableTextStyle.swift:

```swift
struct PortableTextStyle {
    let font: Font?
    let foregroundColor: Color?
    let backgroundColor: Color?
    let lineSpacing: CGFloat?
    let padding: EdgeInsets?
    let alignment: TextAlignment?
    
    init(
        font: Font? = nil,
        foregroundColor: Color? = nil,
        backgroundColor: Color? = nil,
        lineSpacing: CGFloat? = nil,
        padding: EdgeInsets? = nil,
        alignment: TextAlignment? = nil
    ) {
        self.font = font
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.lineSpacing = lineSpacing
        self.padding = padding
        self.alignment = alignment
    }
    
    static func defaultForType(_ type: String) -> PortableTextStyle {
        switch type {
        case "normal":
            return PortableTextStyle(
                font: .body,
                foregroundColor: .primary,
                lineSpacing: 1.2
            )
        default:
            return PortableTextStyle(
                font: .body,
                foregroundColor: .primary
            )
        }
    }
}
```

Next, create Styling/PortableTextStyler.swift:

```swift
struct PortableTextStyler {
    private var styles: [String: PortableTextStyle] = [:]
    
    mutating func setStyle(_ style: PortableTextStyle, forType type: String) {
        styles[type] = style
    }
    
    func getStyle(forType type: String, style: String? = nil) -> PortableTextStyle {
        // Check for specific style first (e.g., "h1")
        if let style = style, let specificStyle = styles[style] {
            return specificStyle
        }
        
        // Fall back to type style (e.g., "block")
        if let typeStyle = styles[type] {
            return typeStyle
        }
        
        // Use default style
        return PortableTextStyle.defaultForType(style ?? type)
    }
}
```

Update the PortableTextRenderer to use this styling system:

```swift
// Add to PortableTextRenderer
private var styler = PortableTextStyler()

// Add style modifier
func portableTextStyle(_ type: String, _ style: PortableTextStyle) -> PortableTextRenderer {
    var renderer = self
    renderer.styler.setStyle(style, forType: type)
    return renderer
}

// Update render in the body
blocks[index].render(with: styler.getStyle(forType: blocks[index]._type))
```

Update Paragraph to use the style:

```swift
func render(with style: PortableTextStyle?) -> AnyView {
    let text = children?.compactMap { $0.text }.joined() ?? ""
    
    var textView = Text(text)
        .fixedSize(horizontal: false, vertical: true)
    
    if let style = style {
        if let font = style.font {
            textView = textView.font(font)
        }
        if let color = style.foregroundColor {
            textView = textView.foregroundColor(color)
        }
        if let lineSpacing = style.lineSpacing {
            textView = textView.lineSpacing(lineSpacing)
        }
    }
    
    var view: some View = textView
    
    if let style = style, let padding = style.padding {
        view = view.padding(padding)
    }
    
    if let style = style, let bgColor = style.backgroundColor {
        view = view.background(bgColor)
    }
    
    return AnyView(view)
}
```

This gives us a basic styling system that we can build upon.
```

### Refined Step 8: AttributedString Implementation

```
Building on the previous steps, implement AttributedString creation for better text rendering. Create a new file Rendering/AttributedStringBuilder.swift:

```swift
struct AttributedStringBuilder {
    static func createAttributedString(
        from spans: [PortableTextSpan],
        markDefs: [PortableTextMarkDefinition]?
    ) -> AttributedString {
        var attributedString = AttributedString("")
        
        for span in spans {
            var spanText = AttributedString(span.text)
            
            // Apply marks to the span
            if let marks = span.marks {
                for mark in marks {
                    if let markDefs = markDefs,
                       let markDef = markDefs.first(where: { $0._key == mark }) {
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
    
    private static func applyStandardMark(_ mark: String, to text: AttributedString) -> AttributedString {
        var attributedText = text
        
        switch mark {
        case "strong":
            attributedText.font = .bold()
        case "em":
            attributedText.font = .italic()
        case "underline":
            attributedText.underlineStyle = .single
        default:
            // Unknown mark, ignore
            break
        }
        
        return attributedText
    }
    
    private static func applyMarkDefinition(_ markDef: PortableTextMarkDefinition, to text: AttributedString) -> AttributedString {
        var attributedText = text
        
        switch markDef._type {
        case "link":
            if let href = markDef.href, let url = URL(string: href) {
                attributedText.link = url
                attributedText.foregroundColor = .blue
                attributedText.underlineStyle = .single
            }
        default:
            // Unknown mark definition, ignore
            break
        }
        
        return attributedText
    }
}
```

Now update the Paragraph implementation to use AttributedString:

```swift
func render(with style: PortableTextStyle?) -> AnyView {
    guard let children = children, !children.isEmpty else {
        return AnyView(EmptyView())
    }
    
    let attributedText = AttributedStringBuilder.createAttributedString(
        from: children,
        markDefs: markDefs
    )
    
    var textView = Text(attributedText)
        .fixedSize(horizontal: false, vertical: true)
    
    if let style = style {
        if let lineSpacing = style.lineSpacing {
            textView = textView.lineSpacing(lineSpacing)
        }
        if let alignment = style.alignment {
            textView = textView.multilineTextAlignment(alignment)
        }
    }
    
    var view: some View = textView
    
    if let style = style, let padding = style.padding {
        view = view.padding(padding)
    }
    
    if let style = style, let bgColor = style.backgroundColor {
        view = view.background(bgColor)
    }
    
    return AnyView(view)
}
```

This gives us proper AttributedString support with basic mark handling.
```

### Refined Step 9: Heading Implementation

```
Building on the previous steps, implement support for headings. Create Rendering/Blocks/Heading.swift:

```swift
struct Heading: PortableTextBlock {
    let _type: String
    let _key: String
    let style: String // h1, h2, etc.
    let markDefs: [PortableTextMarkDefinition]?
    let children: [PortableTextSpan]?
    
    var level: Int {
        guard style.hasPrefix("h"), style.count > 1,
              let levelString = style.dropFirst().first,
              let level = Int(String(levelString)) else {
            return 1 // Default to h1 if invalid
        }
        return min(max(level, 1), 6) // Clamp between 1-6
    }
    
    func render(with style: PortableTextStyle?) -> AnyView {
        guard let children = children, !children.isEmpty else {
            return AnyView(EmptyView())
        }
        
        let attributedText = AttributedStringBuilder.createAttributedString(
            from: children,
            markDefs: markDefs
        )
        
        // Apply heading-specific styling
        var textView = Text(attributedText)
            .font(fontForHeadingLevel(level))
            .fontWeight(.bold)
            .fixedSize(horizontal: false, vertical: true)
        
        // Apply custom style if provided
        if let style = style {
            if let font = style.font {
                textView = textView.font(font)
            }
            if let color = style.foregroundColor {
                textView = textView.foregroundColor(color)
            }
            if let lineSpacing = style.lineSpacing {
                textView = textView.lineSpacing(lineSpacing)
            }
            if let alignment = style.alignment {
                textView = textView.multilineTextAlignment(alignment)
            }
        }
        
        var view: some View = textView
        
        // Apply padding and background
        if let style = style, let padding = style.padding {
            view = view.padding(padding)
        } else {
            // Default padding based on heading level
            view = view.padding(.vertical, CGFloat(8 - level))
        }
        
        if let style = style, let bgColor = style.backgroundColor {
            view = view.background(bgColor)
        }
        
        return AnyView(view)
    }
    
    private func fontForHeadingLevel(_ level: Int) -> Font {
        switch level {
        case 1: return .largeTitle
        case 2: return .title
        case 3: return .title2
        case 4: return .title3
        case 5: return .headline
        case 6: return .subheadline
        default: return .title // Fallback
        }
    }
}
```

Update the BlockFactory to support headings:

```swift
static func createBlock(from blockData: PortableTextBlockData) throws -> PortableTextBlock {
    switch blockData._type {
    case "block":
        if let style = blockData.style, style.hasPrefix("h") {
            // Handle heading
            return Heading(
                _type: blockData._type,
                _key: blockData._key,
