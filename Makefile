# Makefile for SwiftUI Portable Text Renderer
.PHONY: all clean prompt-foundation prompt-models prompt-parsers prompt-rendering prompt-blocks prompt-styling prompt-modifiers prompt-examples help implementation

SPEC_FILE = spec.md
TODO_FILE = todo.md
SRC_DIR = src
OUTPUT_DIR = output
PROMPT_FILE = $(OUTPUT_DIR)/current_prompt.md

all: help

help:
	@echo "SwiftUI Portable Text Renderer Code Generation"
	@echo ""
	@echo "Available targets:"
	@echo "  prompt-foundation   - Generate prompt for project foundation"
	@echo "  prompt-models       - Generate prompt for data models"
	@echo "  prompt-parsers      - Generate prompt for JSON parsing"
	@echo "  prompt-rendering    - Generate prompt for rendering pipeline"
	@echo "  prompt-blocks       - Generate prompt for block implementations"
	@echo "  prompt-styling      - Generate prompt for styling system"
	@echo "  prompt-modifiers    - Generate prompt for SwiftUI modifiers"
	@echo "  prompt-examples     - Generate prompt for usage examples"
	@echo "  implementation      - Run all prompts in sequence"
	@echo "  clean               - Remove generated files"
	@echo ""
	@echo "Usage:"
	@echo "  1. Run 'make prompt-[component]'"
	@echo "  2. Copy the content from $(PROMPT_FILE)"
	@echo "  3. Paste into Claude or other AI assistant"
	@echo "  4. Save generated code to appropriate files in $(SRC_DIR)"

$(OUTPUT_DIR):
	mkdir -p $(OUTPUT_DIR)

$(SRC_DIR):
	mkdir -p $(SRC_DIR)
	mkdir -p $(SRC_DIR)/Models
	mkdir -p $(SRC_DIR)/Rendering
	mkdir -p $(SRC_DIR)/Rendering/Blocks
	mkdir -p $(SRC_DIR)/Styling
	mkdir -p $(SRC_DIR)/Errors
	mkdir -p $(SRC_DIR)/Modifiers
	mkdir -p $(SRC_DIR)/Examples

implementation: prompt-foundation prompt-models prompt-parsers prompt-rendering prompt-blocks prompt-styling prompt-modifiers prompt-examples
	@echo "All prompts have been generated. Follow the process to implement each component."

prompt-foundation: $(OUTPUT_DIR) $(SRC_DIR)
	@echo "Generating prompt for project foundation..."
	@echo "# Code Generation Prompt: Project Foundation" > $(PROMPT_FILE)
	@echo "" >> $(PROMPT_FILE)
	@echo "Based on the following specification excerpt and todo items, please generate the foundation code for a SwiftUI Portable Text Renderer library. Focus on setting up the project structure, basic Swift Package configuration, and core protocols." >> $(PROMPT_FILE)
	@echo "" >> $(PROMPT_FILE)
	@echo "## Specification Reference" >> $(PROMPT_FILE)
	@echo '```' >> $(PROMPT_FILE)
	@sed -n '/## 1. Overview/,/## 2. Requirements/p' $(SPEC_FILE) >> $(PROMPT_FILE)
	@sed -n '/### 3.1 Core Components/,/#### PortableTextError/p' $(SPEC_FILE) >> $(PROMPT_FILE)
	@echo '```' >> $(PROMPT_FILE)
	@echo "" >> $(PROMPT_FILE)
	@echo "## Todo Items" >> $(PROMPT_FILE)
	@echo '```' >> $(PROMPT_FILE)
	@sed -n '/## Phase 1: Project Setup & Foundation/,/## Phase 2:/p' $(TODO_FILE) >> $(PROMPT_FILE)
	@echo '```' >> $(PROMPT_FILE)
	@echo "" >> $(PROMPT_FILE)
	@echo "Please generate the following files:" >> $(PROMPT_FILE)
	@echo "1. Package.swift - Swift Package configuration" >> $(PROMPT_FILE)
	@echo "2. Sources/PortableTextRenderer/PortableTextRenderer.swift - Main view struct" >> $(PROMPT_FILE)
	@echo "3. Sources/PortableTextRenderer/Errors/PortableTextError.swift - Error handling" >> $(PROMPT_FILE)
	@echo "4. Sources/PortableTextRenderer/Rendering/PortableTextBlock.swift - Core protocol" >> $(PROMPT_FILE)
	@echo "" >> $(PROMPT_FILE)
	@echo "Generate clean, well-documented Swift code following best practices. Include proper access modifiers (public, internal) and comprehensive documentation comments." >> $(PROMPT_FILE)
	@echo "Prompt saved to $(PROMPT_FILE). Copy this content and paste it into Claude or another AI assistant."

prompt-models: $(OUTPUT_DIR) $(SRC_DIR)
	@echo "Generating prompt for data models..."
	@echo "# Code Generation Prompt: Data Models" > $(PROMPT_FILE)
	@echo "" >> $(PROMPT_FILE)
	@echo "Based on the following specification excerpt and todo items, please generate the data models needed for the SwiftUI Portable Text Renderer library. These models should represent the Portable Text schema and be Codable for JSON parsing." >> $(PROMPT_FILE)
	@echo "" >> $(PROMPT_FILE)
	@echo "## Specification Reference" >> $(PROMPT_FILE)
	@echo '```' >> $(PROMPT_FILE)
	@sed -n '/## 4. Data Model/,/## 5. Implementation Details/p' $(SPEC_FILE) >> $(PROMPT_FILE)
	@echo '```' >> $(PROMPT_FILE)
	@echo "" >> $(PROMPT_FILE)
	@echo "## Todo Items" >> $(PROMPT_FILE)
	@echo '```' >> $(PROMPT_FILE)
	@sed -n '/- \[ \] Create core data models for Portable Text:/,/- \[ \] Define PortableTextBlock protocol/p' $(TODO_FILE) >> $(PROMPT_FILE)
	@echo '```' >> $(PROMPT_FILE)
	@echo "" >> $(PROMPT_FILE)
	@echo "Please generate the following files:" >> $(PROMPT_FILE)
	@echo "1. Sources/PortableTextRenderer/Models/PortableTextDocument.swift" >> $(PROMPT_FILE)
	@echo "2. Sources/PortableTextRenderer/Models/PortableTextBlockData.swift" >> $(PROMPT_FILE)
	@echo "3. Sources/PortableTextRenderer/Models/PortableTextSpan.swift" >> $(PROMPT_FILE)
	@echo "4. Sources/PortableTextRenderer/Models/PortableTextMarkDefinition.swift" >> $(PROMPT_FILE)
	@echo "" >> $(PROMPT_FILE)
	@echo "Ensure all models conform to Codable and include appropriate documentation. Use proper access modifiers to expose only what's necessary for library users." >> $(PROMPT_FILE)
	@echo "Prompt saved to $(PROMPT_FILE). Copy this content and paste it into Claude or another AI assistant."

prompt-parsers: $(OUTPUT_DIR) $(SRC_DIR)
	@echo "Generating prompt for JSON parsers..."
	@echo "# Code Generation Prompt: JSON Parsing" > $(PROMPT_FILE)
	@echo "" >> $(PROMPT_FILE)
	@echo "Based on the following specification excerpt and todo items, please generate the JSON parsing functionality for the SwiftUI Portable Text Renderer library. This includes parsing Portable Text JSON into our data models and handling parsing errors." >> $(PROMPT_FILE)
	@echo "" >> $(PROMPT_FILE)
	@echo "## Specification Reference" >> $(PROMPT_FILE)
	@echo '```' >> $(PROMPT_FILE)
	@sed -n '/### 5.1 JSON Parsing Process/,/### 5.2 Rendering Process/p' $(SPEC_FILE) >> $(PROMPT_FILE)
	@sed -n '/## 6. Error Handling Strategy/,/## 7. SwiftUI Modifiers/p' $(SPEC_FILE) >> $(PROMPT_FILE)
	@echo '```' >> $(PROMPT_FILE)
	@echo "" >> $(PROMPT_FILE)
	@echo "## Todo Items" >> $(PROMPT_FILE)
	@echo '```' >> $(PROMPT_FILE)
	@sed -n '/- \[ \] Implement JSON parsing logic in PortableTextParser/,/- \[ \] Connect parser to PortableTextRenderer/p' $(TODO_FILE) >> $(PROMPT_FILE)
	@echo '```' >> $(PROMPT_FILE)
	@echo "" >> $(PROMPT_FILE)
	@echo "Please generate the following files:" >> $(PROMPT_FILE)
	@echo "1. Sources/PortableTextRenderer/Parsing/PortableTextParser.swift - Main parsing functionality" >> $(PROMPT_FILE)
	@echo "2. Update Sources/PortableTextRenderer/PortableTextRenderer.swift to use the parser" >> $(PROMPT_FILE)
	@echo "" >> $(PROMPT_FILE)
	@echo "Ensure comprehensive error handling with appropriate PortableTextError types. The parser should be robust against malformed JSON and missing required fields." >> $(PROMPT_FILE)
	@echo "Prompt saved to $(PROMPT_FILE). Copy this content and paste it into Claude or another AI assistant."

prompt-rendering: $(OUTPUT_DIR) $(SRC_DIR)
	@echo "Generating prompt for rendering pipeline..."
	@echo "# Code Generation Prompt: Rendering Pipeline" > $(PROMPT_FILE)
	@echo "" >> $(PROMPT_FILE)
	@echo "Based on the following specification excerpt and todo items, please generate the core rendering pipeline for the SwiftUI Portable Text Renderer library. This includes the AttributedString builder and block factory." >> $(PROMPT_FILE)
	@echo "" >> $(PROMPT_FILE)
	@echo "## Specification Reference" >> $(PROMPT_FILE)
	@echo '```' >> $(PROMPT_FILE)
	@sed -n '/### 5.2 Rendering Process/,/### 5.3 Attributed String Creation/p' $(SPEC_FILE) >> $(PROMPT_FILE)
	@sed -n '/### 5.3 Attributed String Creation/,/### 5.4 Table of Contents Generation/p' $(SPEC_FILE) >> $(PROMPT_FILE)
	@echo '```' >> $(PROMPT_FILE)
	@echo "" >> $(PROMPT_FILE)
	@echo "## Todo Items" >> $(PROMPT_FILE)
	@echo '```' >> $(PROMPT_FILE)
	@sed -n '/- \[ \] Implement BlockFactory for creating blocks from data/,/- \[ \] Implement AttributedString builder:/p' $(TODO_FILE) >> $(PROMPT_FILE)
	@sed -n '/  - \[ \] Create utility for building attributed strings/,/  - \[ \] Update Paragraph to use AttributedString/p' $(TODO_FILE) >> $(PROMPT_FILE)
	@echo '```' >> $(PROMPT_FILE)
	@echo "" >> $(PROMPT_FILE)
	@echo "Please generate the following files:" >> $(PROMPT_FILE)
	@echo "1. Sources/PortableTextRenderer/Rendering/BlockFactory.swift - Creates block instances from data" >> $(PROMPT_FILE)
	@echo "2. Sources/PortableTextRenderer/Rendering/AttributedStringBuilder.swift - Creates attributed strings" >> $(PROMPT_FILE)
	@echo "3. Update Sources/PortableTextRenderer/PortableTextRenderer.swift to use these components" >> $(PROMPT_FILE)
	@echo "" >> $(PROMPT_FILE)
	@echo "Ensure the rendering pipeline properly handles marks, includes error handling, and follows the specified rendering process. The AttributedString builder should support basic marks (bold, italic, underline)." >> $(PROMPT_FILE)
	@echo "Prompt saved to $(PROMPT_FILE). Copy this content and paste it into Claude or another AI assistant."

prompt-blocks: $(OUTPUT_DIR) $(SRC_DIR)
	@echo "Generating prompt for block implementations..."
	@echo "# Code Generation Prompt: Block Implementations" > $(PROMPT_FILE)
	@echo "" >> $(PROMPT_FILE)
	@echo "Based on the following specification excerpt and todo items, please generate the concrete block implementations for the SwiftUI Portable Text Renderer library. This includes Paragraph, Heading, List, CodeBlock, and Table." >> $(PROMPT_FILE)
	@echo "" >> $(PROMPT_FILE)
	@echo "## Specification Reference" >> $(PROMPT_FILE)
	@echo '```' >> $(PROMPT_FILE)
	@sed -n '/### 4.2 Internal Models/,/## 5. Implementation Details/p' $(SPEC_FILE) >> $(PROMPT_FILE)
	@echo '```' >> $(PROMPT_FILE)
	@echo "" >> $(PROMPT_FILE)
	@echo "## Todo Items" >> $(PROMPT_FILE)
	@echo '```' >> $(PROMPT_FILE)
	@sed -n '/## Phase 3: Block Types Implementation/,/## Phase 4: Advanced Features/p' $(TODO_FILE) >> $(PROMPT_FILE)
	@echo '```' >> $(PROMPT_FILE)
	@echo "" >> $(PROMPT_FILE)
	@echo "Please generate the following files:" >> $(PROMPT_FILE)
	@echo "1. Sources/PortableTextRenderer/Rendering/Blocks/Paragraph.swift" >> $(PROMPT_FILE)
	@echo "2. Sources/PortableTextRenderer/Rendering/Blocks/Heading.swift" >> $(PROMPT_FILE)
	@echo "3. Sources/PortableTextRenderer/Rendering/Blocks/List.swift" >> $(PROMPT_FILE)
	@echo "4. Sources/PortableTextRenderer/Rendering/Blocks/CodeBlock.swift" >> $(PROMPT_FILE)
	@echo "5. Sources/PortableTextRenderer/Rendering/Blocks/Table.swift" >> $(PROMPT_FILE)
	@echo "6. Update Sources/PortableTextRenderer/Rendering/BlockFactory.swift to support these blocks" >> $(PROMPT_FILE)
	@echo "" >> $(PROMPT_FILE)
	@echo "Each block should implement the PortableTextBlock protocol, handle styling appropriately, and use AttributedStringBuilder where needed. Ensure proper error handling and follow SwiftUI best practices." >> $(PROMPT_FILE)
	@echo "Prompt saved to $(PROMPT_FILE). Copy this content and paste it into Claude or another AI assistant."

prompt-styling: $(OUTPUT_DIR) $(SRC_DIR)
	@echo "Generating prompt for styling system..."
	@echo "# Code Generation Prompt: Styling System" > $(PROMPT_FILE)
	@echo "" >> $(PROMPT_FILE)
	@echo "Based on the following specification excerpt and todo items, please generate the styling system for the SwiftUI Portable Text Renderer library. This includes the PortableTextStyle struct and styling management." >> $(PROMPT_FILE)
	@echo "" >> $(PROMPT_FILE)
	@echo "## Specification Reference" >> $(PROMPT_FILE)
	@echo '```' >> $(PROMPT_FILE)
	@sed -n '/#### PortableTextStyle/,/#### PortableTextError/p' $(SPEC_FILE) >> $(PROMPT_FILE)
	@sed -n '/#### Styling Environment Keys/,/## 4. Data Model/p' $(SPEC_FILE) >> $(PROMPT_FILE)
	@echo '```' >> $(PROMPT_FILE)
	@echo "" >> $(PROMPT_FILE)
	@echo "## Todo Items" >> $(PROMPT_FILE)
	@echo '```' >> $(PROMPT_FILE)
	@sed -n '/- \[ \] Implement basic styling system:/,/- \[ \] Implement AttributedString builder:/p' $(TODO_FILE) >> $(PROMPT_FILE)
	@echo '```' >> $(PROMPT_FILE)
	@echo "" >> $(PROMPT_FILE)
	@echo "Please generate the following files:" >> $(PROMPT_FILE)
	@echo "1. Sources/PortableTextRenderer/Styling/PortableTextStyle.swift - Style definition" >> $(PROMPT_FILE)
	@echo "2. Sources/PortableTextRenderer/Styling/PortableTextStyler.swift - Style management" >> $(PROMPT_FILE)
	@echo "3. Update Sources/PortableTextRenderer/PortableTextRenderer.swift to use the styling system" >> $(PROMPT_FILE)
	@echo "" >> $(PROMPT_FILE)
	@echo "Ensure the styling system provides default styles for different block types, supports custom styles, and follows SwiftUI's modifier pattern. Include factory methods for standard styles." >> $(PROMPT_FILE)
	@echo "Prompt saved to $(PROMPT_FILE). Copy this content and paste it into Claude or another AI assistant."

prompt-modifiers: $(OUTPUT_DIR) $(SRC_DIR)
	@echo "Generating prompt for SwiftUI modifiers..."
	@echo "# Code Generation Prompt: SwiftUI Modifiers" > $(PROMPT_FILE)
	@echo "" >> $(PROMPT_FILE)
	@echo "Based on the following specification excerpt and todo items, please generate the SwiftUI modifiers for the Portable Text Renderer library. This includes modifiers for styling, custom renderers, link handling, error views, table of contents, and text direction." >> $(PROMPT_FILE)
	@echo "" >> $(PROMPT_FILE)
	@echo "## Specification Reference" >> $(PROMPT_FILE)
	@echo '```' >> $(PROMPT_FILE)
	@sed -n '/## 7. SwiftUI Modifiers/,/## 8. Usage Examples/p' $(SPEC_FILE) >> $(PROMPT_FILE)
	@echo '```' >> $(PROMPT_FILE)
	@echo "" >> $(PROMPT_FILE)
	@echo "## Todo Items" >> $(PROMPT_FILE)
	@echo '```' >> $(PROMPT_FILE)
	@sed -n '/- \[ \] Add portableTextStyle modifier to renderer/,/- \[ \] Add convenience modifier for heading styles/p' $(TODO_FILE) >> $(PROMPT_FILE)
	@sed -n '/- \[ \] Create CustomBlockRenderer type/,/- \[ \] Create portableTextCustomRenderer modifier/p' $(TODO_FILE) >> $(PROMPT_FILE)
	@sed -n '/- \[ \] Create CustomMarkRenderer type/,/- \[ \] Create portableTextCustomMarkRenderer modifier/p' $(TODO_FILE) >> $(PROMPT_FILE)
	@sed -n '/- \[ \] Add tocBinding property to renderer/,/- \[ \] Create tableOfContents modifier/p' $(TODO_FILE) >> $(PROMPT_FILE)
	@sed -n '/- \[ \] Add TextDirection enum/,/- \[ \] Create textDirection modifier/p' $(TODO_FILE) >> $(PROMPT_FILE)
	@echo '```' >> $(PROMPT_FILE)
	@echo "" >> $(PROMPT_FILE)
	@echo "Please generate the following files:" >> $(PROMPT_FILE)
	@echo "1. Sources/PortableTextRenderer/Modifiers/StyleModifiers.swift - Style-related modifiers" >> $(PROMPT_FILE)
	@echo "2. Sources/PortableTextRenderer/Modifiers/RendererModifiers.swift - Custom renderer modifiers" >> $(PROMPT_FILE)
	@echo "3. Sources/PortableTextRenderer/Modifiers/LinkModifiers.swift - Link handling modifiers" >> $(PROMPT_FILE)
	@echo "4. Sources/PortableTextRenderer/Modifiers/ErrorViewModifiers.swift - Error view modifiers" >> $(PROMPT_FILE)
	@echo "5. Sources/PortableTextRenderer/Modifiers/TableOfContentsModifiers.swift - TOC modifiers" >> $(PROMPT_FILE)
	@echo "6. Sources/PortableTextRenderer/Modifiers/TextDirectionModifiers.swift - Direction modifiers" >> $(PROMPT_FILE)
	@echo "7. Update Sources/PortableTextRenderer/PortableTextRenderer.swift to support these modifiers" >> $(PROMPT_FILE)
	@echo "" >> $(PROMPT_FILE)
	@echo "Ensure all modifiers follow SwiftUI's modifier pattern (returning an updated copy), include proper documentation, and maintain proper access modifiers." >> $(PROMPT_FILE)
	@echo "Prompt saved to $(PROMPT_FILE). Copy this content and paste it into Claude or another AI assistant."

prompt-examples: $(OUTPUT_DIR) $(SRC_DIR)
	@echo "Generating prompt for usage examples..."
	@echo "# Code Generation Prompt: Usage Examples" > $(PROMPT_FILE)
	@echo "" >> $(PROMPT_FILE)
	@echo "Based on the following specification excerpt, please generate comprehensive usage examples for the SwiftUI Portable Text Renderer library. This should include basic and advanced usage examples." >> $(PROMPT_FILE)
	@echo "" >> $(PROMPT_FILE)
	@echo "## Specification Reference" >> $(PROMPT_FILE)
	@echo '```' >> $(PROMPT_FILE)
	@sed -n '/## 8. Usage Examples/,/## 9. Testing Plan/p' $(SPEC_FILE) >> $(PROMPT_FILE)
	@echo '```' >> $(PROMPT_FILE)
	@echo "" >> $(PROMPT_FILE)
	@echo "## Todo Items" >> $(PROMPT_FILE)
	@echo '```' >> $(PROMPT_FILE)
	@sed -n '/## Phase 6: Documentation & Examples/,/## Final Integration & Testing/p' $(TODO_FILE) >> $(PROMPT_FILE)
	@echo '```' >> $(PROMPT_FILE)
	@echo "" >> $(PROMPT_FILE)
	@echo "Please generate the following files:" >> $(PROMPT_FILE)
	@echo "1. Sources/PortableTextRenderer/Examples/BasicUsageExample.swift - Simple implementation" >> $(PROMPT_FILE)
	@echo "2. Sources/PortableTextRenderer/Examples/AdvancedUsageExample.swift - With all features" >> $(PROMPT_FILE)
	@echo "3. Sources/PortableTextRenderer/Examples/StylingExample.swift - Custom styling" >> $(PROMPT_FILE)
	@echo "4. Sources/PortableTextRenderer/Examples/CustomRenderingExample.swift - Custom renderers" >> $(PROMPT_FILE)
	@echo "5. Sources/PortableTextRenderer/Examples/ErrorHandlingExample.swift - Error handling" >> $(PROMPT_FILE)
	@echo "6. Sources/PortableTextRenderer/Examples/TableOfContentsExample.swift - TOC generation" >> $(PROMPT_FILE)
	@echo "" >> $(PROMPT_FILE)
	@echo "Each example should be comprehensive, well-documented, and demonstrate specific features of the library. Include sample Portable Text JSON and complete SwiftUI views." >> $(PROMPT_FILE)
	@echo "Prompt saved to $(PROMPT_FILE). Copy this content and paste it into Claude or another AI assistant."

clean:
	rm -rf $(OUTPUT_DIR)
	rm -rf $(SRC_DIR)
