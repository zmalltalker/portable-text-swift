import Foundation

/// Represents errors that can occur during Portable Text parsing and rendering.
public enum PortableTextError: Error {
    /// JSON parsing or structure validation failed.
    case invalidJSON(String)
    
    /// Encountered a block type that isn't supported.
    case unsupportedBlockType(String)
    
    /// Encountered a mark type that isn't supported.
    case unsupportedMarkType(String)
    
    /// A required field is missing in the Portable Text structure.
    case missingRequiredField(String)
    
    /// Content is nested beyond the supported depth (one level).
    case nestedContentTooDeep
    
    /// The structure of the content is invalid or malformed.
    case malformedStructure(String)
    
    /// An error occurred during the rendering process.
    case rendering(String)
}

extension PortableTextError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidJSON(let details):
            return "Invalid JSON: \(details)"
        case .unsupportedBlockType(let blockType):
            return "Unsupported block type: \(blockType)"
        case .unsupportedMarkType(let markType):
            return "Unsupported mark type: \(markType)"
        case .missingRequiredField(let fieldName):
            return "Missing required field: \(fieldName)"
        case .nestedContentTooDeep:
            return "Content is nested too deeply. Only one level of nesting is supported."
        case .malformedStructure(let details):
            return "Malformed content structure: \(details)"
        case .rendering(let details):
            return "Rendering error: \(details)"
        }
    }
    
    public var failureReason: String? {
        switch self {
        case .invalidJSON:
            return "The provided JSON string could not be parsed or does not conform to the Portable Text schema."
        case .unsupportedBlockType:
            return "The content contains a block type that is not supported by this library."
        case .unsupportedMarkType:
            return "The content contains a mark type that is not supported by this library."
        case .missingRequiredField:
            return "The content is missing a field that is required for rendering."
        case .nestedContentTooDeep:
            return "The content contains nested blocks beyond the supported depth of one level."
        case .malformedStructure:
            return "The structure of the content does not conform to the expected Portable Text schema."
        case .rendering:
            return "An error occurred while rendering the content."
        }
    }
    
    public var recoverySuggestion: String? {
        switch self {
        case .invalidJSON:
            return "Verify that the JSON string is valid and follows the Portable Text schema."
        case .unsupportedBlockType(let blockType):
            return "Consider using a supported block type or implement a custom renderer for '\(blockType)'."
        case .unsupportedMarkType(let markType):
            return "Consider using a supported mark type or implement a custom mark renderer for '\(markType)'."
        case .missingRequiredField:
            return "Ensure all required fields are present in your Portable Text content."
        case .nestedContentTooDeep:
            return "Restructure your content to use only one level of nesting."
        case .malformedStructure:
            return "Check your content structure against the Portable Text specification."
        case .rendering:
            return "Try simplifying the content or check for any custom renderers that might be causing issues."
        }
    }
}:
