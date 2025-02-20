import SwiftUI
import Foundation
import os.log

/// Factory for creating concrete block implementations from Portable Text block data.
public struct BlockFactory {
    // Private logger for debugging
    private static let logger = Logger(subsystem: "com.zmalltalker.portable-text-swift", category: "BlockFactory")
    
    /// Creates a concrete block implementation based on the provided block data.
    ///
    /// - Parameter blockData: The Portable Text block data to convert.
    /// - Returns: An object conforming to `PortableTextBlock` for rendering.
    /// - Throws: `PortableTextError` if the block type is unsupported or required data is missing.
    public static func createBlock(from blockData: PortableTextBlockData) throws -> PortableTextBlock {
        logger.debug("Creating block from data: type=\(blockData._type), key=\(blockData._key)")
        
        switch blockData._type {
        case "block":
            // Handle standard block types based on style
            if let style = blockData.style {
                if style.hasPrefix("h") && style.count > 1 {
                    // Extract heading level and create Heading block
                    if let levelString = style.dropFirst().first,
                       let level = Int(String(levelString)),
                       level >= 1 && level <= 6 {
                        logger.debug("Creating heading block level \(level)")
                        return try createHeading(from: blockData, level: level)
                    } else {
                        logger.warning("Invalid heading level in style: \(style)")
                        throw PortableTextError.malformedStructure("Invalid heading level in style: \(style)")
                    }
                } else if style == "normal" {
                    logger.debug("Creating paragraph block")
                    return try createParagraph(from: blockData)
                } else {
                    logger.warning("Unsupported block style: \(style)")
                    throw PortableTextError.unsupportedBlockType("Unsupported block style: \(style)")
                }
            } else {
                // Default to paragraph if no style is specified
                logger.debug("No style specified, defaulting to paragraph")
                return try createParagraph(from: blockData)
            }
            
        case "code":
            logger.debug("Creating code block")
            return try createCodeBlock(from: blockData)
            
        default:
            logger.warning("Unsupported block type: \(blockData._type)")
            throw PortableTextError.unsupportedBlockType("Block type '\(blockData._type)' is not supported")
        }
    }
    
    /// Creates a paragraph block from block data.
    ///
    /// - Parameter blockData: The block data to convert.
    /// - Returns: A `Paragraph` instance.
    /// - Throws: `PortableTextError` if required data is missing.
    private static func createParagraph(from blockData: PortableTextBlockData) throws -> Paragraph {
        guard let children = blockData.children, !children.isEmpty else {
            logger.warning("Paragraph block missing children: \(blockData._key)")
            throw PortableTextError.missingRequiredField("Paragraph block must have children")
        }
        
        return Paragraph(
            _type: blockData._type,
            _key: blockData._key,
            style: blockData.style ?? "normal",
            markDefs: blockData.markDefs,
            children: children
        )
    }
    
    /// Creates a heading block from block data.
    ///
    /// - Parameters:
    ///   - blockData: The block data to convert.
    ///   - level: The heading level (1-6).
    /// - Returns: A `Heading` instance.
    /// - Throws: `PortableTextError` if required data is missing.
    private static func createHeading(from blockData: PortableTextBlockData, level: Int) throws -> Heading {
        guard let children = blockData.children, !children.isEmpty else {
            logger.warning("Heading block missing children: \(blockData._key)")
            throw PortableTextError.missingRequiredField("Heading block must have children")
        }
        
        guard let style = blockData.style else {
            logger.warning("Heading block missing style: \(blockData._key)")
            throw PortableTextError.missingRequiredField("Heading block must have style")
        }
        
        return Heading(
            _type: blockData._type,
            _key: blockData._key,
            style: style,
            level: level,
            markDefs: blockData.markDefs,
            children: children
        )
    }
    
    /// Creates a code block from block data.
    ///
    /// - Parameter blockData: The block data to convert.
    /// - Returns: A `CodeBlock` instance.
    /// - Throws: `PortableTextError` if required data is missing.
    private static func createCodeBlock(from blockData: PortableTextBlockData) throws -> CodeBlock {
        guard let children = blockData.children, !children.isEmpty else {
            logger.warning("Code block missing children: \(blockData._key)")
            throw PortableTextError.missingRequiredField("Code block must have children")
        }
        
        // Extract language if present
        let language = blockData.additionalField("language", as: String.self)
        
        return CodeBlock(
            _type: blockData._type,
            _key: blockData._key,
            language: language,
            markDefs: blockData.markDefs,
            children: children
        )
    }
    
    /// Converts an array of block data to concrete block implementations.
    ///
    /// - Parameter blockData: Array of block data to convert.
    /// - Returns: Array of concrete block implementations.
    /// - Throws: `PortableTextError` if any conversion fails.
    public static func createBlocks(from blockData: [PortableTextBlockData]) throws -> [PortableTextBlock] {
        var blocks: [PortableTextBlock] = []
        
        for data in blockData {
            do {
                let block = try createBlock(from: data)
                blocks.append(block)
            } catch {
                logger.error("Failed to create block from data: \(error.localizedDescription)")
                throw error
            }
        }
        
        logger.debug("Created \(blocks.count) blocks")
        return blocks
    }
}

// MARK: - Block Type Implementations

/// A paragraph block in Portable Text.
public struct Paragraph: PortableTextBlock {
    public let _type: String
    public let _key: String
    public let style: String
    public let markDefs: [PortableTextMarkDefinition]?
    public let children: [PortableTextSpan]?
    
    public func render(with style: PortableTextStyle?) -> AnyView {
        guard let children = children, !children.isEmpty else {
            return EmptyView().eraseToAnyView()
        }
        
        let attributedText = AttributedStringBuilder.createAttributedString(
            from: children,
            markDefs: markDefs
        )
        
        var textView = Text(attributedText)
            .fixedSize(horizontal: false, vertical: true)
        
        // Apply style if provided
        if let style = style {
            if let font = style.font {
                textView = textView.font(font)
            }
            if let foregroundColor = style.foregroundColor {
                textView = textView.foregroundColor(foregroundColor)
            }
            if let lineSpacing = style.lineSpacing {
                textView = textView.lineSpacing(lineSpacing)
            }
            if let alignment = style.alignment {
                textView = textView.multilineTextAlignment(alignment)
            }
        }
        
        var view: some View = textView
        
        // Apply padding and background if provided in style
        if let style = style {
            if let padding = style.padding {
                view = view.padding(padding)
            }
            if let backgroundColor = style.backgroundColor {
                view = view.background(backgroundColor)
            }
        }
        
        return view.eraseToAnyView()
    }
}

/// A heading block in Portable Text.
public struct Heading: PortableTextBlock {
    public let _type: String
    public let _key: String
    public let style: String  // h1, h2, etc.
    public let level: Int
    public let markDefs: [PortableTextMarkDefinition]?
    public let children: [PortableTextSpan]?
    
    public func render(with style: PortableTextStyle?) -> AnyView {
        guard let children = children, !children.isEmpty else {
            return EmptyView().eraseToAnyView()
        }
        
        let attributedText = AttributedStringBuilder.createAttributedString(
            from: children,
            markDefs: markDefs
        )
        
        var textView = Text(attributedText)
            .font(fontForLevel(level))
            .fontWeight(.bold)
            .fixedSize(horizontal: false, vertical: true)
        
        // Apply style if provided (overrides defaults)
        if let style = style {
            if let font = style.font {
                textView = textView.font(font)
            }
            if let foregroundColor = style.foregroundColor {
                textView = textView.foregroundColor(foregroundColor)
            }
            if let lineSpacing = style.lineSpacing {
                textView = textView.lineSpacing(lineSpacing)
            }
            if let alignment = style.alignment {
                textView = textView.multilineTextAlignment(alignment)
            }
        }
        
        var view: some View = textView
        
        // Apply padding and background if provided in style
        if let style = style {
            if let padding = style.padding {
                view = view.padding(padding)
            } else {
                // Default padding based on heading level
                view = view.padding(.vertical, CGFloat(8 - level))
            }
            
            if let backgroundColor = style.backgroundColor {
                view = view.background(backgroundColor)
            }
        } else {
            // Default padding based on heading level if no style provided
            view = view.padding(.vertical, CGFloat(8 - level))
        }
        
        return view.eraseToAnyView()
    }
    
    /// Returns an appropriate font for the heading level.
    private func fontForLevel(_ level: Int) -> Font {
        switch level {
        case 1: return .largeTitle
        case 2: return .title
        case 3: return .title2
        case 4: return .title3
        case 5: return .headline
        case 6: return .subheadline
        default: return .title  // Fallback
        }
    }
}

/// A code block in Portable Text.
public struct CodeBlock: PortableTextBlock {
    public let _type: String
    public let _key: String
    public let language: String?
    public let markDefs: [PortableTextMarkDefinition]?
    public let children: [PortableTextSpan]?
    
    public func render(with style: PortableTextStyle?) -> AnyView {
        guard let children = children, !children.isEmpty else {
            return EmptyView().eraseToAnyView()
        }
        
        let code = children.map { $0.text }.joined()
        
        var textView = Text(code)
            .font(.system(.body, design: .monospaced))
            .fixedSize(horizontal: false, vertical: true)
        
        // Apply style if provided
        if let style = style {
            if let font = style.font {
                textView = textView.font(font)
            }
            if let foregroundColor = style.foregroundColor {
                textView = textView.foregroundColor(foregroundColor)
            }
            if let alignment = style.alignment {
                textView = textView.multilineTextAlignment(alignment)
            }
        }
        
        var view: some View = textView
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8)
        
        // Apply custom padding and background if provided in style
        if let style = style {
            if let padding = style.padding {
                view = view.padding(padding)
            }
            if let backgroundColor = style.backgroundColor {
                view = view.background(backgroundColor.cornerRadius(8))
            }
        }
        
        // If language is specified, add a label
        if let language = language, !language.isEmpty {
            view = VStack(alignment: .leading, spacing: 4) {
                Text(language)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Color(.tertiarySystemBackground))
                    .cornerRadius(4)
                
                view
            }
            .eraseToAnyView()
        }
        
        return view.eraseToAnyView()
    }
}
