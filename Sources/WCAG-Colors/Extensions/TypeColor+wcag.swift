//
//  WCAG-Colors
//
//  Copyright (c) 2023 Christoph Wendt
//

#if os(iOS) || os(tvOS) || os(watchOS)

    import UIKit

    /// Typealias used for colors. It maps to UIColor.
    public typealias TypeColor = UIColor

    /// Typealias used for fonts. It maps to UIFont.
    public typealias TypeFont = UIFont

#elseif os(OSX)

    import AppKit

    /// Typealias used for colors. It maps to NSColor.
    public typealias TypeColor = NSColor

    /// Typealias used for fonts. It maps to NSFont.
    public typealias TypeFont = NSFont

#endif

/// Extension that adds functionality for calculating WCAG compliant high contrast colors.
public extension TypeColor {
    /**
     Calculates the color ratio for a text color on a background color.

     - Parameters:
         - foregroundColor: The text color.
         - backgroundColor: The background color.

     - Returns: The contrast ratio for a given pair of colors.

     - Note: Semi-transparent text colors will be blended with the background color. However, for background colors, the alpha component is ignored.

     - Warning: This function will also return `nil` if any input color is not convertable to the sRGB color space.
     */
    class func getContrastRatio(foregroundColor: TypeColor, backgroundColor: TypeColor) -> CGFloat? {
        guard let rgbaForegroundColor = foregroundColor.rgbaColor, let rgbaBackgroundColor = backgroundColor.rgbaColor else {
            return nil
        }

        return RGBAColor.getContrastRatio(foregroundColor: rgbaForegroundColor, backgroundColor: rgbaBackgroundColor)
    }

    /**
     Returns the text color with the highest contrast (black or white) for a given background color.

     - Parameters:
        - backgroundColor: The background color.

     - Returns: A color that has the highest contrast with the given background color.

     - Note: Semi-transparent text colors will be blended with the background color. However, for background colors, the alpha component is ignored.

     - Warning: This function will also return `nil` if any input color is not convertable to the sRGB color space.
     */
    class func getForegroundColor(backgroundColor: TypeColor) -> TypeColor? {
        guard let rgbaBackgroundColor = backgroundColor.rgbaColor else { return nil }
        let foregroundColor = RGBAColor.getForegroundColor(backgroundColor: rgbaBackgroundColor)

        return foregroundColor == RGBAColor.Colors.black ? .black : .white
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

     - Warning: This function will also return `nil` if any input color is not convertable to the sRGB color space.
     */
    class func getForegroundColor(colors: [TypeColor], elementType: ElementType, backgroundColor: TypeColor, conformanceLevel: ConformanceLevel = .AA) -> TypeColor? {
        guard let rgbaBackgroundColor = backgroundColor.rgbaColor else { return nil }

        for foregroundColor in colors {
            guard let rgbaForegroundColor = foregroundColor.rgbaColor else { return nil }

            let isValidForegroundColor = RGBAColor.isValidColorCombination(foregroundColor: rgbaForegroundColor, elementType: elementType, backgroundColor: rgbaBackgroundColor, conformanceLevel: conformanceLevel)
            if isValidForegroundColor {
                return foregroundColor
            }
        }

        return nil
    }

    #if os(iOS) || os(tvOS) || os(OSX)

        /**
         Returns the text color with the highest contrast (black or white) for a specific area of given background image.

         - Parameters:
         - backgroundImage: The background image.
         - imageArea: The area of the image that is used as the text background. Defaults to .full.

         - Returns: A color that has the highest contrast with the given background image.

         - Note: For the background image, the alpha component is ignored.

         - Warning: This function will also return `nil` if the image is corrupted.
         */
        class func getForegroundColor(backgroundImage image: TypeImage, imageArea: ImageArea = .full) -> TypeColor? {
            guard let averageImageColor = image.averageColor(imageArea: imageArea) else { return nil }

            return TypeColor.getForegroundColor(backgroundColor: averageImageColor)
        }

        /**
         Calculates the contrast ratio of a given list of text colors and a specific area of given background image. The first color that conforms to the conformance level defined gets returned. The default conformance level is .AA.

         - Parameters:
         - colors: A list of possible text colors.
         - elementType: The application of the color pair.
         - backgroundImage: The background image that the text should be displayed on.
         - imageArea: The area of the image that is used as the text background. Defaults to .full.
         - conformanceLevel: The conformance level that needs to be passed when calculating the contrast ratio. The default conformance level is .AA.

         - Returns: The first color that conforms to the conformance level defined or `nil` if non of the colors provided passed.

         - Note: Semi-transparent text colors will be blended with the background color. However, for the background image, the alpha component is ignored.

         - Warning: This function will also return `nil` if any input color is not convertable to the sRGB color space.
         */
        class func getForegroundColor(colors: [TypeColor], elementType: ElementType, backgroundImage: TypeImage, imageArea: ImageArea = .full, conformanceLevel: ConformanceLevel = .AA) -> TypeColor? {
            guard let averageImageColor = backgroundImage.averageColor(imageArea: imageArea) else { return nil }

            return TypeColor.getForegroundColor(colors: colors, elementType: elementType, backgroundColor: averageImageColor, conformanceLevel: conformanceLevel)
        }

    #endif

    /**
     Returns the background color with the highest contrast (black or white) for a given text color.

     - Parameters:
        - foregroundColor: The foregroundColor color.

     - Returns: A color that has the highest contrast with the given text color.

     - Note: Semi-transparent text colors will be blended with the background color. However, for background colors, the alpha component is ignored.

     - Warning: This function will also return `nil` if any input color is not convertable to the sRGB color space.
     */
    class func getBackgroundColor(foregroundColor: TypeColor) -> TypeColor? {
        guard let rgbaForegroundColor = foregroundColor.rgbaColor else { return nil }
        let backgroundColor = RGBAColor.getBackgroundColor(foregroundColor: rgbaForegroundColor)

        return backgroundColor == RGBAColor.Colors.black ? .black : .white
    }

    /**
     Calculates the contrast ratio of a given list of background colors and a text color. The first color that conforms to the conformance level defined gets returned. The default conformance level is .AA.

     - Parameters:
         - colors: A list of possible background colors.
         - foregroundColor: The text color that should be used.
         - elementType: The application of the color pair.
         - conformanceLevel: The conformance level that needs to be passed when calculating the contrast ratio. The default conformance level is .AA.

     - Returns: The first color that conforms to the conformance level defined or `nil` if non of the colors provided passed.

     - Note: Semi-transparent text colors will be blended with the background color. However, for background colors, the alpha component is ignored.

     - Warning: This function will also return `nil` if any input color is not convertable to the sRGB color space.
     */
    class func getBackgroundColor(colors: [TypeColor], foregroundColor: TypeColor, elementType: ElementType, conformanceLevel: ConformanceLevel = .AA) -> TypeColor? {
        guard let rgbaForegroundColor = foregroundColor.rgbaColor else { return nil }

        for backgroundColor in colors {
            guard let rgbaBackgroundColor = backgroundColor.rgbaColor else { return nil }

            let isValidBackgroundColor = RGBAColor.isValidColorCombination(foregroundColor: rgbaForegroundColor, elementType: elementType, backgroundColor: rgbaBackgroundColor, conformanceLevel: conformanceLevel)
            if isValidBackgroundColor {
                return backgroundColor
            }
        }

        return nil
    }
}
