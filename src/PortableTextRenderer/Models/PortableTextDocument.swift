import Foundation

/// Represents the root structure of Portable Text JSON content.
///
/// A `PortableTextDocument` consists of an array of blocks that make up
/// the content structure. It serves as the entry point for parsing
/// Portable Text JSON.
public struct PortableTextDocument: Codable, Equatable {
    /// The array of blocks that make up the content.
    public let blocks: [PortableTextBlockData]
    
    /// Creates a new Portable Text document with the specified blocks.
    ///
    /// - Parameter blocks: The blocks that make up the content.
    public init(blocks: [PortableTextBlockData]) {
        self.blocks = blocks
    }
    
    // MARK: - Codable
    
    private enum CodingKeys: String, CodingKey {
        case blocks
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Blocks are required in a valid Portable Text document
        do {
            blocks = try container.decode([PortableTextBlockData].self, forKey: .blocks)
        } catch {
            throw DecodingError.dataCorruptedError(
                forKey: .blocks,
                in: container,
                debugDescription: "Portable Text document must contain 'blocks' array"
            )
        }
        
        // Validate that the document has at least one block
        guard !blocks.isEmpty else {
            throw DecodingError.dataCorruptedError(
                forKey: .blocks,
                in: container,
                debugDescription: "Portable Text document must contain at least one block"
            )
        }
    }
}
