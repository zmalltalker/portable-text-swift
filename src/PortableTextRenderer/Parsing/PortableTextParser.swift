import Foundation
import SwiftUI
import os.log

/// A utility for parsing Portable Text JSON and converting it to internal block models.
public struct PortableTextParser {
    // Private logger for debugging
    private static let logger = Logger(subsystem: "com.zmalltalker.portable-text-swift", category: "PortableTextParser")
    
    /// Parses a Portable Text JSON string into an array of renderable blocks.
    ///
    /// This method handles the complete parsing process:
    /// 1. Converting the JSON string to data
    /// 2. Decoding the JSON into `PortableTextDocument`
    /// 3. Validating the document structure
    /// 4. Converting document blocks to renderable block models
    ///
    /// - Parameter json: A string containing valid Portable Text JSON.
    /// - Returns: An array of objects conforming to `PortableTextBlock` ready for rendering.
    /// - Throws: `PortableTextError` describing any parsing or validation failures.
    public static func parsePortableText(_ json: String) throws -> [PortableTextBlock] {
        // Step 1: Convert string to data
        guard let jsonData = json.data(using: .utf8) else {
            logger.error("Failed to convert JSON string to data")
            throw PortableTextError.invalidJSON("Cannot convert JSON string to data")
        }
        
        // Step 2: Decode JSON into document model
        let decoder = JSONDecoder()
        do {
            let document = try decoder.decode(PortableTextDocument.self, from: jsonData)
            logger.debug("Successfully decoded JSON into PortableTextDocument with \(document.blocks.count) blocks")
            
            // Step 3 & 4: Convert document blocks to renderable blocks
            return try convertToBlocks(document.blocks)
        } catch let decodingError as DecodingError {
            // Handle specific decoding errors with more context
            let errorDescription = describeDecodingError(decodingError)
            logger.error("JSON decoding failed: \(errorDescription)")
            throw PortableTextError.invalidJSON("JSON decoding failed: \(errorDescription)")
        } catch let portableTextError as PortableTextError {
            // Re-throw portable text errors
            logger.error("Portable Text error during parsing: \(portableTextError.localizedDescription)")
            throw portableTextError
        } catch {
            // Handle unexpected errors
            logger.error("Unexpected error during parsing: \(error.localizedDescription)")
            throw PortableTextError.invalidJSON("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    /// Converts decoded block data into renderable block models.
    ///
    /// - Parameter blockData: Array of decoded `PortableTextBlockData` objects.
    /// - Returns: Array of objects conforming to `PortableTextBlock` protocol.
    /// - Throws: `PortableTextError` if conversion fails for any block.
    public static func convertToBlocks(_ blockData: [PortableTextBlockData]) throws -> [PortableTextBlock] {
        var blocks: [PortableTextBlock] = []
        
        for block in blockData {
            do {
                let renderableBlock = try createBlock(from: block)
                blocks.append(renderableBlock)
            } catch {
                logger.warning("Failed to convert block with key '\(block._key)': \(error.localizedDescription)")
                throw error
            }
        }
        
        logger.debug("Successfully converted \(blocks.count) blocks")
        return blocks
    }
    
    /// Creates a specific block implementation from block data.
    ///
    /// This is a placeholder implementation that will be replaced by the BlockFactory.
    /// In the future, this will delegate to the BlockFactory to create appropriate block types.
    ///
    /// - Parameter blockData: The decoded block data.
    /// - Returns: An object conforming to `PortableTextBlock`.
    /// - Throws: `PortableTextError` if the block type is unsupported or if required data is missing.
    private static func createBlock(from blockData: PortableTextBlockData) throws -> PortableTextBlock {
        // Placeholder logic - will be replaced by BlockFactory
        // This ensures the parser can be tested independently before BlockFactory is implemented
        switch blockData._type {
        case "block":
            return PlaceholderBlock(blockData: blockData)
        default:
            logger.error("Unsupported block type: \(blockData._type)")
            throw PortableTextError.unsupportedBlockType("Block type '\(blockData._type)' is not supported")
        }
    }
    
    /// Provides a detailed description of a decoding error.
    ///
    /// - Parameter error: The decoding error to describe.
    /// - Returns: A human-readable description of the error.
    private static func describeDecodingError(_ error: DecodingError) -> String {
        switch error {
        case .keyNotFound(let key, let context):
            return "Required key '\(key.stringValue)' not found: \(context.debugDescription)"
        case .valueNotFound(let type, let context):
            return "Required value of type \(type) not found: \(context.debugDescription)"
        case .typeMismatch(let type, let context):
            return "Type mismatch for type \(type): \(context.debugDescription)"
        case .dataCorrupted(let context):
            return "Data corrupted: \(context.debugDescription)"
        @unknown default:
            return "Unknown decoding error: \(error.localizedDescription)"
        }
    }
    
    /// Validates that a Portable Text document meets basic structural requirements.
    ///
    /// - Parameter document: The document to validate.
    /// - Throws: `PortableTextError` if validation fails.
    public static func validateDocument(_ document: PortableTextDocument) throws {
        // This method can be expanded with additional validation rules
        guard !document.blocks.isEmpty else {
            throw PortableTextError.malformedStructure("Document contains no blocks")
        }
        
        // Validate individual blocks
        for block in document.blocks {
            try validateBlock(block)
        }
    }
    
    /// Validates that a block meets basic structural requirements.
    ///
    /// - Parameter block: The block to validate.
    /// - Throws: `PortableTextError` if validation fails.
    public static func validateBlock(_ block: PortableTextBlockData) throws {
        // Validate block has required fields (already handled by Codable)
        
        // Validate children if present
        if let children = block.children {
            guard !children.isEmpty else {
                throw PortableTextError.malformedStructure("Block '\(block._key)' has empty children array")
            }
            
            for child in children {
                if child.text.isEmpty {
                    logger.warning("Block '\(block._key)' contains span with empty text")
                }
            }
        }
        
        // For blocks that should have children (like paragraphs), verify they exist
        if block._type == "block" && block.style != nil {
            if block.children == nil || block.children!.isEmpty {
                throw PortableTextError.missingRequiredField("Block '\(block._key)' of style '\(block.style!)' must have children")
            }
        }
    }
}

/// Temporary placeholder block for testing parsing before full implementation
private struct PlaceholderBlock: PortableTextBlock {
    let _type: String
    let _key: String
    let markDefs: [PortableTextMarkDefinition]?
    let children: [PortableTextSpan]?
    
    init(blockData: PortableTextBlockData) {
        self._type = blockData._type
        self._key = blockData._key
        self.markDefs = blockData.markDefs
        self.children = blockData.children
    }
    
    func render(with style: PortableTextStyle?) -> AnyView {
        // Simple placeholder rendering
        let text = children?.compactMap { $0.text }.joined(separator: "") ?? "Empty block"
        return Text(text).eraseToAnyView()
    }
}
