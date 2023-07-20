//
//  WCAG-Colors
//
//  Copyright (c) 2023 Christoph Wendt
//

/// An enum specifying different font sizes and weights.
public enum FontSize {
    
    /// A regular font with a size of less than 18 points.
    case small
    
    /// A bold font with a size of at least 14 points.
    case boldSmall
    
    /// A bold font with a size of at least 18 points.
    case large
}

extension FontSize {
    var fontProps: FontProps {
        let fontSizeSize = self == .large ? 18.0 : 14.0
        let isBold = self == .boldSmall
        return FontProps(fontSize: fontSizeSize, isBoldFont: isBold)
    }
}
