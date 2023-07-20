//
//  WCAG-Colors
//
//  Copyright (c) 2023 Christoph Wendt
//

import SwiftUI

/// Extension that adds functionality for calculating WCAG compliant high contrast colors.
@available(iOS 17, tvOS 17, watchOS 10, macOS 14, *)
public extension Color {
    /**
     Calculates the color ratio for a text color on a background color.

     - Parameters:
         - textColor: The text color.
         - backgroundColor: The background color.

     - Returns: The contrast ratio for a given pair of colors.

     - Note: Semi-transparent text colors will be blended with the background color. However, for background colors, the alpha component is ignored.

     - Warning: This function will also return `nil` if any input color is not convertable to the sRGB color space.
     */
    static func getContrastRatio(textColor: Color, backgroundColor: Color) -> CGFloat? {
        return RGBAColor.getContrastRatio(textColor: textColor.rgbaColor, backgroundColor: backgroundColor.rgbaColor)
    }

    /**
     Returns the text color with the highest contrast (black or white) for a given background color.

     - Parameters:
        - backgroundColor: The background color.

     - Returns: A color that has the highest contrast with the given background color.

     - Note: Semi-transparent text colors will be blended with the background color. However, for background colors, the alpha component is ignored.

     - Warning: This function will also return `nil` if any input color is not convertable to the sRGB color space.
     */
    static func getTextColor(backgroundColor: Color) -> Color {
        let textColor = RGBAColor.getTextColor(backgroundColor: backgroundColor.rgbaColor)

        return textColor == RGBAColor.Colors.black ? .black : .white
    }

    /**
     Calculates the contrast ratio of a given list of text colors and a background color. The first color that conforms to the conformance level defined gets returned. The default conformance level is .AA.

     - Parameters:
         - colors: A list of possible text colors.
         - elementType: The application of the color pair.
         - backgroundColor: The background color that the text should be displayed on.
         - conformanceLevel: The conformance level that needs to be passed when calculating the contrast ratio. The default conformance level is .AA.

     - Returns: The first color that conforms to the conformance level defined or `nil` if non of the colors provided passed.

     - Note: Semi-transparent text colors will be blended with the background color. However, for background colors, the alpha component is ignored.
     */
    static func getTextColor(colors: [Color], elementType: ElementType, backgroundColor: Color, conformanceLevel: ConformanceLevel = .AA) -> Color? {

        for textColor in colors {
            let isValidTextColor = RGBAColor.isValidColorCombination(textColor: textColor.rgbaColor, elementType: elementType, backgroundColor: backgroundColor.rgbaColor, conformanceLevel: conformanceLevel)
            
            if isValidTextColor {
                return textColor
            }
        }

        return nil
    }

    /**
     Returns the background color with the highest contrast (black or white) for a given text color.

     - Parameters:
        - textColor: The textColor color.

     - Returns: A color that has the highest contrast with the given text color.

     - Note: Semi-transparent text colors will be blended with the background color. However, for background colors, the alpha component is ignored.
     */
    static func getBackgroundColor(textColor: Color) -> Color {
        let backgroundColor = RGBAColor.getBackgroundColor(textColor: textColor.rgbaColor)

        return backgroundColor == RGBAColor.Colors.black ? .black : .white
    }

    /**
     Calculates the contrast ratio of a given list of background colors and a text color. The first color that conforms to the conformance level defined gets returned. The default conformance level is .AA.

     - Parameters:
         - colors: A list of possible background colors.
         - textColor: The text color that should be used.
         - elementType: The application of the color pair.
         - conformanceLevel: The conformance level that needs to be passed when calculating the contrast ratio. The default conformance level is .AA.

     - Returns: The first color that conforms to the conformance level defined or `nil` if non of the colors provided passed.

     - Note: Semi-transparent text colors will be blended with the background color. However, for background colors, the alpha component is ignored.

     - Warning: This function will also return `nil` if any input color is not convertable to the sRGB color space.
     */
    static func getBackgroundColor(colors: [Color], textColor: Color, elementType: ElementType, conformanceLevel: ConformanceLevel = .AA) -> Color? {

        for backgroundColor in colors {
            let isValidBackgroundColor = RGBAColor.isValidColorCombination(textColor: textColor.rgbaColor, elementType: elementType, backgroundColor: backgroundColor.rgbaColor, conformanceLevel: conformanceLevel)
            
            if isValidBackgroundColor {
                return backgroundColor
            }
        }

        return nil
    }
}
