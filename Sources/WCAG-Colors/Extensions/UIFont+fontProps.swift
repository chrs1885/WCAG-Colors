//
//  WCAG-Colors
//
//  Copyright (c) 2021 Christoph Wendt
//

#if os(iOS) || os(tvOS) || os(watchOS)

    import UIKit

    extension UIFont {
        var fontProps: FontProps {
            return FontProps(fontSize: pointSize, isBoldFont: isBold)
        }

        var isBold: Bool {
            return (fontDescriptor.symbolicTraits.rawValue & UIFontDescriptor.SymbolicTraits.traitBold.rawValue) != 0
        }
    }

#endif
