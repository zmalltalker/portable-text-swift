# SwiftUI Portable Text Renderer

A Swift Package for rendering [Portable Text](https://github.com/portabletext/portabletext) from Sanity CMS as native SwiftUI text elements.

## Overview

SwiftUI Portable Text Renderer converts Portable Text JSON into native SwiftUI views with attributed text, prioritizing rendering speed and providing a powerful modifier-based styling system. Rather than using generated HTML in web views, this library renders text and images natively for a true native experience.

![Swift 5.5+](https://img.shields.io/badge/Swift-5.5%2B-orange)
![iOS 15.0+](https://img.shields.io/badge/iOS-15.0%2B-blue)
![macOS 12.0+](https://img.shields.io/badge/macOS-12.0%2B-blue)

## Development

This project includes a Makefile to help streamline the code generation process. The Makefile generates prompts that can be used with AI assistants like Claude to create implementation code following the specification.

### Using the Makefile

1. Make sure you have the following files in your repository:
   - `spec.md` - The detailed specification
   - `todo.md` - The implementation checklist
   - `Makefile` - The code generation helper

2. Available Makefile commands:
   ```
   make prompt-foundation   # Generate prompt for project foundation
   make prompt-models       # Generate prompt for data models
   make prompt-parsers      # Generate prompt for JSON parsing
   make prompt-rendering    # Generate prompt for rendering pipeline
   make prompt-blocks       # Generate prompt for block implementations
   make prompt-styling      # Generate prompt for styling system
   make prompt-modifiers    # Generate prompt for SwiftUI modifiers
   make prompt-examples     # Generate prompt for usage examples
   make help                # Display available commands and usage instructions
   ```

3. Detailed development workflow:

   #### Step 1: Generate a prompt
   ```bash
   make prompt-foundation
   ```
   This creates a detailed prompt in `output/current_prompt.md` that extracts relevant sections from your specification and todo list.

   #### Step 2: Copy the prompt to clipboard (Mac)
   ```bash
   cat output/current_prompt.md | pbcopy
   ```
   Now the prompt is in your clipboard, ready to paste into Claude.

   #### Step 3: Get code from Claude
   1. Start a new conversation with Claude
   2. Paste the prompt from your clipboard
   3. Claude will generate the requested implementation files
   
   #### Step 4: Save the generated code
   For each file that Claude generates:
   1. Copy the code block (everything between the triple backticks)
   2. Create the appropriate directory if needed:
      ```bash
      mkdir -p src/PortableTextRenderer/Errors
      ```
   3. Save the code to the appropriate file:
      ```bash
      vim src/PortableTextRenderer/Errors/PortableTextError.swift
      # or use your preferred editor
      ```

   #### Step 5: Proceed to the next component
   Follow the sequence of prompts in order:
   1. `make prompt-foundation`
   2. `make prompt-models`
   3. `make prompt-parsers`
   4. `make prompt-rendering`
   5. `make prompt-blocks`
   6. `make prompt-styling`
   7. `make prompt-modifiers`
   8. `make prompt-examples`

### Tips for using the Makefile

* Each prompt is self-contained but builds on previous components
* If Claude's response is incomplete, you can ask it to continue
* You can modify the generated prompts in `output/current_prompt.md` before sending to Claude
* To view all files that need to be implemented for a component, check the prompt content
* When saving files, maintain the directory structure specified in the prompt

For a complete implementation, follow the prompts in sequence from foundation to examples. Each prompt is designed to create code that integrates with previous components.

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
    .package(url: "https://github.com/zmalltalker/portable-text-swift.git", from: "1.0.0")
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
