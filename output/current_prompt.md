# Code Generation Prompt: Project Foundation

Based on the following specification excerpt and todo items, please generate the foundation code for a SwiftUI Portable Text Renderer library. Focus on setting up the project structure, basic Swift Package configuration, and core protocols.

## Specification Reference
```
## 1. Overview
A Swift Package for rendering Portable Text from Sanity CMS as native SwiftUI text elements. This library converts Portable Text JSON into native SwiftUI views with attributed text, prioritizing rendering speed and providing a modifier-based styling system.

## 2. Requirements
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
```

## Todo Items
```
## Phase 1: Project Setup & Foundation
- [ ] Create Swift Package with SwiftUI dependency
- [ ] Set up directory structure (Models, Rendering, Styling, Errors)
- [ ] Create basic PortableTextRenderer view struct
- [ ] Implement PortableTextError enum with all required cases
- [ ] Implement initial error handling infrastructure
- [ ] Create core data models for Portable Text:
  - [ ] PortableTextDocument
  - [ ] PortableTextBlockData
  - [ ] PortableTextSpan
  - [ ] PortableTextMarkDefinition
- [ ] Define PortableTextBlock protocol
- [ ] Create empty PortableTextStyle struct placeholder

## Phase 2: Parsing & Basic Rendering
```

Please generate the following files:
1. Package.swift - Swift Package configuration
2. Sources/PortableTextRenderer/PortableTextRenderer.swift - Main view struct
3. Sources/PortableTextRenderer/Errors/PortableTextError.swift - Error handling
4. Sources/PortableTextRenderer/Rendering/PortableTextBlock.swift - Core protocol

Generate clean, well-documented Swift code following best practices. Include proper access modifiers (public, internal) and comprehensive documentation comments.
