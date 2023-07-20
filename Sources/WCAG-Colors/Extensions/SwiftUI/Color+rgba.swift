//
//  WCAG-Colors
//
//  Created by Christoph Wendt on 30.06.23.
//

import SwiftUI

@available(macOS 14.0, *)

extension Color {
    var rgbaColor: RGBAColor {
        func normalize(_ component: Float) -> CGFloat {
            let nomralizedValue = CGFloat(component) * 255.0

            if nomralizedValue > 255.0 { return 255.0 }
            if nomralizedValue < 0.0 { return 0.0 }
            return nomralizedValue
        }
        
        let color = self.resolve(in: EnvironmentValues())

        return RGBAColor(
            red: normalize(color.red),
            green: normalize(color.green),
            blue: normalize(color.blue),
            alpha: CGFloat(color.opacity)
        )
    }
}
