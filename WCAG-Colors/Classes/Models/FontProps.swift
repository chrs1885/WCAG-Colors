//
//  WCAG-Colors
//
//  Copyright (c) 2021 Christoph Wendt
//

import CoreGraphics

struct FontProps: Equatable {
    var fontSize: CGFloat
    var isBoldFont: Bool

    var isLargeText: Bool {
        return fontSize >= 18.0 || (fontSize >= 14.0 && isBoldFont)
    }
}
