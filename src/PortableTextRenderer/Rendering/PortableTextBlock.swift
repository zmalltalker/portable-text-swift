import SwiftUI

/// Protocol defining the requirements for a Portable Text block renderer.
///
/// Types conforming to this protocol can render a specific block type 
/// from Portable Text content, such as paragraphs, headings, lists, etc.
public protocol PortableTextBlock {
    /// The type of the block (e.g., "block", "image", "code").
    var _type: String { get }
    
    /// A unique identifier for the block.
    var _key: String { get }
    
    /// Optional array of mark definitions (e.g., links) that can be referenced by spans.
    var markDefs: [PortableTextMarkDefinition]? { get }
    
    /// Optional array of text spans contained within this block.
    var children: [PortableTextSpan]? { get }
    
    /// Renders the block as a SwiftUI view, applying the provided style.
    ///
    /// - Parameter style: The style to apply to this block, or nil to use defaults.
    /// - Returns: The rendered view wrapped in AnyView.
    func render(with style: PortableTextStyle?) -> AnyView
}

/// A placeholder for `PortableTextMarkDefinition` until we implement it.
/// This will be properly defined in the Models directory.
public struct PortableTextMarkDefinition {
    // Will be implemented later
}

/// A placeholder for `PortableTextSpan` until we implement it.
/// This will be properly defined in the Models directory.
public struct PortableTextSpan {
    // Will be implemented later
}

/// A placeholder for `PortableTextStyle` until we implement it.
/// This will be properly defined in the Styling directory.
public struct PortableTextStyle {
    // Will be implemented later
}

// Extension to AnyView to simplify wrapping views
extension View {
    /// Wraps the view in an AnyView for type erasure.
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}
