import Foundation

/// Represents a block element in Portable Text JSON structure.
///
/// Blocks are the primary structural elements in Portable Text and can
/// represent paragraphs, headings, lists, code blocks, and other content types.
public struct PortableTextBlockData: Codable, Identifiable, Equatable {
    /// The type identifier for the block.
    public let _type: String
    
    /// A unique identifier for the block, used for tracking and referencing.
    public let _key: String
    
    /// The style of the block (e.g., "normal", "h1", "h2").
    public let style: String?
    
    /// Definitions for any marks (like links) used within the block.
    public let markDefs: [PortableTextMarkDefinition]?
    
    /// The text spans contained within this block.
    public let children: [PortableTextSpan]?
    
    /// The nesting level for hierarchical block types (like headings or lists).
    public let level: Int?
    
    /// The list item type for list blocks (e.g., "bullet", "number").
    public let listItem: String?
    
    /// Any additional custom fields specific to certain block types.
    private let additionalFields: [String: AnyCodable]?
    
    /// Creates a new block data instance with the specified properties.
    ///
    /// - Parameters:
    ///   - type: The type identifier for the block.
    ///   - key: A unique identifier for the block.
    ///   - style: The style of the block (optional).
    ///   - markDefs: Definitions for any marks used within the block (optional).
    ///   - children: The text spans contained within this block (optional).
    ///   - level: The nesting level for hierarchical block types (optional).
    ///   - listItem: The list item type for list blocks (optional).
    ///   - additionalFields: Any additional custom fields (optional).
    public init(
        type: String,
        key: String,
        style: String? = nil,
        markDefs: [PortableTextMarkDefinition]? = nil,
        children: [PortableTextSpan]? = nil,
        level: Int? = nil,
        listItem: String? = nil,
        additionalFields: [String: AnyCodable]? = nil
    ) {
        self._type = type
        self._key = key
        self.style = style
        self.markDefs = markDefs
        self.children = children
        self.level = level
        self.listItem = listItem
        self.additionalFields = additionalFields
    }
    
    // MARK: - Identifiable
    
    public var id: String {
        _key
    }
    
    // MARK: - Codable
    
    private enum CodingKeys: String, CodingKey {
        case _type, _key, style, markDefs, children, level, listItem
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Required fields
        do {
            _type = try container.decode(String.self, forKey: ._type)
            _key = try container.decode(String.self, forKey: ._key)
        } catch {
            throw DecodingError.dataCorruptedError(
                forKey: ._type,
                in: container,
                debugDescription: "Block must contain '_type' and '_key' fields"
            )
        }
        
        // Optional fields
        style = try container.decodeIfPresent(String.self, forKey: .style)
        markDefs = try container.decodeIfPresent([PortableTextMarkDefinition].self, forKey: .markDefs)
        children = try container.decodeIfPresent([PortableTextSpan].self, forKey: .children)
        level = try container.decodeIfPresent(Int.self, forKey: .level)
        listItem = try container.decodeIfPresent(String.self, forKey: .listItem)
        
        // Capture any additional fields not explicitly defined
        let additionalContainer = try decoder.container(keyedBy: DynamicCodingKeys.self)
        var additionalFieldsDict: [String: AnyCodable] = [:]
        
        for key in additionalContainer.allKeys {
            if !CodingKeys.allCases.map({ $0.stringValue }).contains(key.stringValue) {
                let value = try additionalContainer.decode(AnyCodable.self, forKey: key)
                additionalFieldsDict[key.stringValue] = value
            }
        }
        
        additionalFields = additionalFieldsDict.isEmpty ? nil : additionalFieldsDict
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(_type, forKey: ._type)
        try container.encode(_key, forKey: ._key)
        
        try container.encodeIfPresent(style, forKey: .style)
        try container.encodeIfPresent(markDefs, forKey: .markDefs)
        try container.encodeIfPresent(children, forKey: .children)
        try container.encodeIfPresent(level, forKey: .level)
        try container.encodeIfPresent(listItem, forKey: .listItem)
        
        // Encode additional fields if present
        if let additionalFields = additionalFields, !additionalFields.isEmpty {
            var additionalContainer = encoder.container(keyedBy: DynamicCodingKeys.self)
            for (key, value) in additionalFields {
                let codingKey = DynamicCodingKeys(stringValue: key)
                try additionalContainer.encode(value, forKey: codingKey)
            }
        }
    }
    
    /// Get a specific additional field value with type conversion
    ///
    /// - Parameters:
    ///   - key: The field key
    ///   - type: The expected type
    /// - Returns: The field value if present and convertible to the specified type
    public func additionalField<T>(_ key: String, as type: T.Type) -> T? {
        guard let field = additionalFields?[key] else {
            return nil
        }
        return field.value as? T
    }
}

// MARK: - Helper for dynamic coding keys

private struct DynamicCodingKeys: CodingKey {
    var stringValue: String
    var intValue: Int?
    
    init(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }
    
    init?(intValue: Int) {
        self.stringValue = String(intValue)
        self.intValue = intValue
    }
}

// MARK: - Helper for encoding/decoding arbitrary values

/// A type-erased Codable wrapper for handling additional fields of any type
public struct AnyCodable: Codable, Equatable {
    public let value: Any
    
    public init<T>(_ value: T) {
        self.value = value
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if container.decodeNil() {
            self.value = NSNull()
        } else if let bool = try? container.decode(Bool.self) {
            self.value = bool
        } else if let int = try? container.decode(Int.self) {
            self.value = int
        } else if let double = try? container.decode(Double.self) {
            self.value = double
        } else if let string = try? container.decode(String.self) {
            self.value = string
        } else if let array = try? container.decode([AnyCodable].self) {
            self.value = array.map { $0.value }
        } else if let dictionary = try? container.decode([String: AnyCodable].self) {
            self.value = dictionary.mapValues { $0.value }
        } else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "AnyCodable cannot decode value"
            )
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self.value {
        case is NSNull, is Void:
            try container.encodeNil()
        case let bool as Bool:
            try container.encode(bool)
        case let int as Int:
            try container.encode(int)
        case let double as Double:
            try container.encode(double)
        case let string as String:
            try container.encode(string)
        case let array as [Any]:
            try container.encode(array.map { AnyCodable($0) })
        case let dictionary as [String: Any]:
            try container.encode(dictionary.mapValues { AnyCodable($0) })
        default:
            let context = EncodingError.Context(
                codingPath: container.codingPath,
                debugDescription: "AnyCodable cannot encode value of type \(type(of: self.value))"
            )
            throw EncodingError.invalidValue(self.value, context)
        }
    }
    
    public static func == (lhs: AnyCodable, rhs: AnyCodable) -> Bool {
        switch (lhs.value, rhs.value) {
        case is (NSNull, NSNull), is (Void, Void):
            return true
        case let (lhsBool as Bool, rhsBool as Bool):
            return lhsBool == rhsBool
        case let (lhsInt as Int, rhsInt as Int):
            return lhsInt == rhsInt
        case let (lhsDouble as Double, rhsDouble as Double):
            return lhsDouble == rhsDouble
        case let (lhsString as String, rhsString as String):
            return lhsString == rhsString
        case let (lhsArray as [Any], rhsArray as [Any]):
            return lhsArray.count == rhsArray.count
        case let (lhsDict as [String: Any], rhsDict as [String: Any]):
            return lhsDict.keys.count == rhsDict.keys.count
        default:
            return false
        }
    }
}

// MARK: - Helper extension for CodingKeys
extension PortableTextBlockData.CodingKeys: CaseIterable {}
