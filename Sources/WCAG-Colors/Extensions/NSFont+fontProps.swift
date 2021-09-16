//
//  WCAG-Colors
//
//  Copyright (c) 2021 Christoph Wendt
//

#if os(OSX)

    import AppKit

    extension NSFont {
        var fontProps: FontProps {
            return FontProps(fontSize: pointSize, isBoldFont: isBold)
        }

        var isBold: Bool {
            return (fontDescriptor.symbolicTraits.rawValue & NSFontSymbolicTraits(NSFontBoldTrait)) != 0
        }
    }

#endif
