import SwiftUI
import Foundation
import os.log

/// A utility for creating `AttributedString` instances from Portable Text spans and marks.
public struct AttributedStringBuilder {
    // Private logger for debugging
    private static let logger = Logger(subsystem: "com.zmalltalker.portable-text-swift", category: "AttributedStringBuilder")
    
    /// Creates an attributed string from an array of spans and optional mark definitions.
    ///
    /// - Parameters:
    ///   - spans: Array of `PortableTextSpan` objects containing text and mark references.
    ///   - markDefs: Optional array of mark definitions that may be referenced by the spans.
    /// - Returns: A formatted `AttributedString` with all marks applied.
    public static func createAttributedString(
        from spans: [PortableTextSpan],
        markDefs: [PortableTextMarkDefinition]? = nil
    ) -> AttributedString {
        guard !spans.isEmpty else {
            logger.debug("No spans provided, returning empty AttributedString")
            return AttributedString("")
        }
        
        var attributedString = AttributedString("")
        
        for span in spans {
            var spanText = AttributedString(span.text)
            
            // Apply marks to the span if present
            if let marks = span.marks, !marks.isEmpty {
                for mark in marks {
                    // First check if this is a reference to a mark definition
                    if let markDefs = markDefs,
                       let markDef = markDefs.first(where: { $0._key == mark }) {
                        spanText = applyMarkDefinition(markDef, to: spanText)
                    } else {
                        // Otherwise, treat as a standard mark
                        spanText = applyStandardMark(mark, to: spanText)
                    }
                }
            }
            
            attributedString.append(spanText)
        }
        
        return attributedString
    }
    
    /// Applies a standard mark to an attributed string.
    ///
    /// Standard marks include common formatting like bold, italic, underline, etc.
    ///
    /// - Parameters:
    ///   - mark: The mark identifier (e.g., "strong", "em", "underline").
    ///   - text: The attributed string to apply the mark to.
    /// - Returns: A new attributed string with the mark applied.
    public static func applyStandardMark(_ mark: String, to text: AttributedString) -> AttributedString {
        var attributedText = text
        
        switch mark {
        case "strong":
            attributedText.fontWeight = .bold
            logger.debug("Applied bold formatting")
        case "em":
            attributedText.italic = true
            logger.debug("Applied italic formatting")
        case "underline":
            attributedText.underlineStyle = .single
            logger.debug("Applied underline formatting")
        case "strike", "strikethrough":
            attributedText.strikethroughStyle = .single
            logger.debug("Applied strikethrough formatting")
        case "code":
            if let currentFont = attributedText.font {
                attributedText.font = currentFont.monospaced()
            } else {
                attributedText.font = .body.monospaced()
            }
            logger.debug("Applied monospace formatting")
        default:
            logger.warning("Unknown standard mark: \(mark), ignoring")
        }
        
        return attributedText
    }
    
    /// Applies a mark definition to an attributed string.
    ///
    /// Mark definitions include complex marks like links, annotations, etc.
    ///
    /// - Parameters:
    ///   - markDef: The mark definition to apply.
    ///   - text: The attributed string to apply the mark to.
    /// - Returns: A new attributed string with the mark definition applied.
    public static func applyMarkDefinition(_ markDef: PortableTextMarkDefinition, to text: AttributedString) -> AttributedString {
        var attributedText = text
        
        switch markDef._type {
        case "link":
            if let href = markDef.href, let url = URL(string: href) {
                attributedText.link = url
                attributedText.foregroundColor = .blue
                attributedText.underlineStyle = .single
                logger.debug("Applied link formatting with URL: \(href)")
            } else {
                logger.warning("Link mark definition missing valid href: \(markDef._key)")
            }
        default:
            logger.warning("Unknown mark definition type: \(markDef._type), ignoring")
        }
        
        return attributedText
    }
    
    /// Combines attributes from multiple sources with priority handling.
    ///
    /// - Parameters:
    ///   - base: The base attributed string.
    ///   - overlay: The attributed string with attributes to overlay on top.
    /// - Returns: A new attributed string with combined attributes.
    public static func combineAttributes(base: AttributedString, overlay: AttributedString) -> AttributedString {
        var result = base
        
        // This is a simplified approach - in a real implementation, 
        // you would iterate through all attribute scopes and ranges
        // For now, we're assuming whole-string attributes for simplicity
        
        // Font weight
        if overlay.runs.count > 0, let weight = overlay.runs[overlay.runs.startIndex].fontWeight {
            result.fontWeight = weight
        }
        
        // Italic
        if overlay.runs.count > 0, let italic = overlay.runs[overlay.runs.startIndex].italic {
            result.italic = italic
        }
        
        // Underline
        if overlay.runs.count > 0, let underline = overlay.runs[overlay.runs.startIndex].underlineStyle {
            result.underlineStyle = underline
        }
        
        // Strikethrough
        if overlay.runs.count > 0, let strikethrough = overlay.runs[overlay.runs.startIndex].strikethroughStyle {
            result.strikethroughStyle = strikethrough
        }
        
        // Font
        if overlay.runs.count > 0, let font = overlay.runs[overlay.runs.startIndex].font {
            result.font = font
        }
        
        // Foreground color
        if overlay.runs.count > 0, let color = overlay.runs[overlay.runs.startIndex].foregroundColor {
            result.foregroundColor = color
        }
        
        // Link
        if overlay.runs.count > 0, let link = overlay.runs[overlay.runs.startIndex].link {
            result.link = link
        }
        
        return result
    }
}
