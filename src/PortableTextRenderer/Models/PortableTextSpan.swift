import Foundation

/// Represents an inline text span within a Portable Text block.
///
/// Text spans are the atomic units of content in Portable Text and can
/// contain text with optional marks (styling). Multiple spans combine to
/// form the content of a block.
public struct PortableTextSpan: Codable, Identifiable, Equatable {
    /// The type identifier for the span (usually "span").
    public let _type: String
    
    /// An optional unique identifier for the span.
    public let _key: String?
    
    /// The actual text content of the span.
    public let text: String
    
    /// Optional array of mark references that apply to this span.
    ///
    /// These can be standard marks like "strong" or "em", or references
    /// to mark definitions like links defined in the block's markDefs.
    public let marks: [String]?
    
    /// Creates a new text span with the specified properties.
    ///
    /// - Parameters:
    ///   - type: The type identifier for the span (defaults to "span").
    ///   - key: An optional unique identifier for the span.
    ///   - text: The actual text content of the span.
    ///   - marks: Optional array of mark references.
    public init(
        type: String = "span",
        key: String? = nil,
        text: String,
        marks: [String]? = nil
    ) {
        self._type = type
        self._key = key
        self.text = text
        self.marks = marks
    }
    
    // MARK: - Identifiable
    
    public var id: String {
        _key ?? UUID().uuidString
    }
    
    // MARK: - Codable
    
    private enum CodingKeys: String, CodingKey {
        case _type, _key, text, marks
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Required fields
        do {
            _type = try container.decode(String.self, forKey: ._type)
            text = try container.decode(String.self, forKey: .text)
        } catch {
            throw DecodingError.dataCorruptedError(
                forKey: ._type,
                in: container,
                debugDescription: "Span must contain '_type' and 'text' fields"
            )
        }
        
        // Optional fields
        _key = try container.decodeIfPresent(String.self, forKey: ._key)
        marks = try container.decodeIfPresent([String].self, forKey: .marks)
    }
    
    /// Determines if this span has a specific mark.
    ///
    /// - Parameter mark: The mark identifier to check for.
    /// - Returns: `true` if the span has the specified mark; otherwise, `false`.
    public func hasMark(_ mark: String) -> Bool {
        guard let marks = marks else { return false }
        return marks.contains(mark)
    }
    
    /// Determines if this span has any marks.
    public var hasMarks: Bool {
        guard let marks = marks else { return false }
        return !marks.isEmpty
    }
    
    /// Creates a new span by appending text to this span.
    ///
    /// - Parameter additionalText: The text to append.
    /// - Returns: A new span with the combined text.
    public func appendingText(_ additionalText: String) -> PortableTextSpan {
        PortableTextSpan(
            type: _type,
            key: _key,
            text: text + additionalText,
            marks: marks
        )
    }
}
