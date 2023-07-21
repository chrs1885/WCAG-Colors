//
//  WCAG-Colors
//
//  Created by Christoph Wendt on 30.06.23.
//

import SwiftUI

@available(iOS 17, tvOS 17, watchOS 10, macOS 14, *)
extension Color {
    var rgbaColor: RGBAColor {
        func normalize(_ component: Float) -> CGFloat {
            let nomralizedValue = CGFloat(component) * 255.0

            if nomralizedValue > 255.0 { return 255.0 }
            if nomralizedValue < 0.0 { return 0.0 }
            return ceil(nomralizedValue * 100) / 100.0
        }

        let color = resolve(in: EnvironmentValues())

        return RGBAColor(
            red: normalize(color.red),
            green: normalize(color.green),
            blue: normalize(color.blue),
            alpha: CGFloat(color.opacity)
        )
    }
}
