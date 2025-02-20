# SwiftUI Portable Text Renderer

A Swift Package for rendering [Portable Text](https://github.com/portabletext/portabletext) from Sanity CMS as native SwiftUI text elements.

## Overview

SwiftUI Portable Text Renderer converts Portable Text JSON into native SwiftUI views with attributed text, prioritizing rendering speed and providing a powerful modifier-based styling system. Rather than using generated HTML in web views, this library renders text and images natively for a true native experience.

![Swift 5.5+](https://img.shields.io/badge/Swift-5.5%2B-orange)
![iOS 15.0+](https://img.shields.io/badge/iOS-15.0%2B-blue)
![macOS 12.0+](https://img.shields.io/badge/macOS-12.0%2B-blue)

## Features

- 📝 Render Portable Text as native SwiftUI views
- 🎨 Customizable styling with SwiftUI-style modifiers
- 🔗 Deep link integration with SwiftUI navigation
- 🖼️ Custom rendering hooks for images and other content types
- 📋 Automatic table of contents generation
- ↔️ Support for LTR/RTL text direction
- ⚡ Focus on performance with static content rendering

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/swift-portable-text-renderer.git", from: "1.0.0")
]
```

Or add it directly in Xcode using File → Swift Packages → Add Package Dependency.

## Basic Usage

```swift
import SwiftUIPortableText

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

## Styling

Apply custom styles using the modifier-based API:

```swift
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
```

## Custom Rendering

Provide custom renderers for specific block types:

```swift
PortableTextRenderer(json: portableTextJSON)
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
```

## Table of Contents

Generate a table of contents from headings:

```swift
@State private var tocItems: [HeadingItem] = []

var body: some View {
    VStack {
        if !tocItems.isEmpty {
            TableOfContentsView(items: tocItems)
        }
        
        PortableTextRenderer(json: portableTextJSON)
            .tableOfContents($tocItems)
    }
}
```

## Error Handling

Provide custom error views:

```swift
PortableTextRenderer(json: portableTextJSON)
    .portableTextErrorView { error in
        VStack {
            Image(systemName: "exclamationmark.triangle")
            Text("Could not render content: \(error.localizedDescription)")
            Button("Retry") {
                // Handle retry
            }
        }
    }
```

## Limitations

- Supports only one level of nesting for block elements
- Limited table styling options
- No support for real-time content updates
- No built-in caching mechanism

## License

This project is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
