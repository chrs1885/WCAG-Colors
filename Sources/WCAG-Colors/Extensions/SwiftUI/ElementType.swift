//
//  WCAG-Colors
//
//  Copyright (c) 2023 Christoph Wendt
//

/// An enum specifying the application of the color pair.
public enum ElementType {
    /// A regular font with a size of less than 18 points.
    case smallFont

    /// A bold font with a size of at least 14 points or a non-bold font with at least 18 points.
    case largeFont

    /// Graphical objects or user interface components.
    case uiComponents
}
