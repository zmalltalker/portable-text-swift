import Foundation

/// Represents a mark definition in Portable Text.
///
/// Mark definitions provide additional data for certain kinds of marks,
/// such as links, annotations, or custom styling. They are referenced
/// by spans through their `_key` value.
public struct PortableTextMarkDefinition: Codable, Identifiable, Equatable {
    /// The type identifier for the mark definition (e.g., "link").
    public let _type: String
    
    /// A unique identifier for this mark definition, referenced by spans.
    public let _key: String
    
    /// The URL for link-type marks.
    public let href: String?
    
    /// Any additional custom fields specific to certain mark types.
    private let additionalFields: [String: AnyCodable]?
    
    /// Creates a new mark definition with the specified properties.
    ///
    /// - Parameters:
    ///   - type: The type identifier for the mark definition.
    ///   - key: A unique identifier for this mark definition.
    ///   - href: The URL for link-type marks (optional).
    ///   - additionalFields: Any additional custom fields (optional).
    public init(
        type: String,
        key: String,
        href: String? = nil,
        additionalFields: [String: AnyCodable]? = nil
    ) {
        self._type = type
        self._key = key
        self.href = href
        self.additionalFields = additionalFields
    }
    
    // MARK: - Identifiable
    
    public var id: String {
        _key
    }
    
    // MARK: - Codable
    
    private enum CodingKeys: String, CodingKey {
        case _type, _key, href
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
                debugDescription: "Mark definition must contain '_type' and '_key' fields"
            )
        }
        
        // Optional fields
        href = try container.decodeIfPresent(String.self, forKey: .href)
        
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
        try container.encodeIfPresent(href, forKey: .href)
        
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
    
    /// Creates a link mark definition.
    ///
    /// - Parameters:
    ///   - key: A unique identifier for this mark definition.
    ///   - href: The URL for the link.
    /// - Returns: A new mark definition configured as a link.
    public static func link(key: String, href: String) -> PortableTextMarkDefinition {
        PortableTextMarkDefinition(type: "link", key: key, href: href)
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

// MARK: - Helper extension for CodingKeys
extension PortableTextMarkDefinition.CodingKeys: CaseIterable {}
