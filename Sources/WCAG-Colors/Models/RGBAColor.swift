//
//  WCAG-Colors
//
//  Copyright (c) 2023 Christoph Wendt
//

import CoreGraphics

struct RGBAColor: Equatable {
    enum Colors {
        static let white = RGBAColor(red: 255.0, green: 255.0, blue: 255.0, alpha: 1.0)
        static let black = RGBAColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    }

    var red, green, blue, alpha: CGFloat

    // https://www.w3.org/TR/WCAG20-TECHS/G17.html
    var relativeLuminance: CGFloat {
        func getAdjustedColorComponent(_ colorComponent: CGFloat) -> CGFloat {
            if colorComponent <= 0.03928 {
                return colorComponent / 12.92
            } else {
                return pow((colorComponent + 0.055) / 1.055, 2.4)
            }
        }

        let adjustedRed = getAdjustedColorComponent(red / 255.0)
        let adjustedGreen = getAdjustedColorComponent(green / 255.0)
        let adjustedBlue = getAdjustedColorComponent(blue / 255.0)

        return (0.2126 * adjustedRed) + (0.7152 * adjustedGreen) + (0.0722 * adjustedBlue)
    }
}

// MARK: - Calculating color properties

extension RGBAColor {
    static func getContrastRatio(textColor: RGBAColor, backgroundColor: RGBAColor) -> CGFloat {
        let blendedColor = textColor.alpha < 1.0 ? textColor.blended(withFraction: textColor.alpha, ofColor: backgroundColor) : textColor

        let textColorLuminance = blendedColor.relativeLuminance
        let backgroundColorLuminance = backgroundColor.relativeLuminance

        return (max(textColorLuminance, backgroundColorLuminance) + 0.05) / (min(textColorLuminance, backgroundColorLuminance) + 0.05)
    }

    static func isValidColorCombination(textColor: RGBAColor, elementType: ElementType, backgroundColor: RGBAColor, conformanceLevel: ConformanceLevel) -> Bool {
        let contrastRatio = RGBAColor.getContrastRatio(textColor: textColor, backgroundColor: backgroundColor)
        let currentConformanceLevel = ConformanceLevel(contrastRatio: contrastRatio, elementType: elementType)

        return currentConformanceLevel >= conformanceLevel
    }
}

// MARK: - Text colors

extension RGBAColor {
    static func getTextColor(backgroundColor: RGBAColor) -> RGBAColor {
        let luminance = backgroundColor.relativeLuminance

        return luminance > 0.179 ? Colors.black : Colors.white
    }
}

// MARK: - Background colors

extension RGBAColor {
    static func getBackgroundColor(textColor: RGBAColor) -> RGBAColor {
        if textColor.alpha < 1.0 {
            let whiteContrastRatio = getContrastRatio(textColor: textColor, backgroundColor: Colors.white)
            let blackContrastRatio = getContrastRatio(textColor: textColor, backgroundColor: Colors.black)

            return whiteContrastRatio > blackContrastRatio ? Colors.white : Colors.black
        } else {
            return textColor.relativeLuminance > 0.179 ? Colors.black : Colors.white
        }
    }
}

// MARK: - Color operations

extension RGBAColor {
    func blended(withFraction fraction: CGFloat, ofColor color: RGBAColor) -> RGBAColor {
        func getBlendedColorComponent(aColorComponent: CGFloat, fraction: CGFloat, otherColorComponent: CGFloat) -> CGFloat {
            let blendedComponent = fraction * aColorComponent + (1 - fraction) * otherColorComponent
            return blendedComponent
        }

        let red = getBlendedColorComponent(aColorComponent: self.red, fraction: alpha, otherColorComponent: color.red)
        let green = getBlendedColorComponent(aColorComponent: self.green, fraction: alpha, otherColorComponent: color.green)
        let blue = getBlendedColorComponent(aColorComponent: self.blue, fraction: alpha, otherColorComponent: color.blue)

        return RGBAColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
