//
//  Image+mock.swift
//  WCAG-ColorsTests
//
//  Created by Wendt, Christoph on 29.09.19.
//

@testable import WCAG_Colors

#if os(iOS) || os(tvOS)

    import UIKit

#endif

import CoreImage

extension TypeImage {
    class func mock(withColor color: TypeColor, rect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)) -> TypeImage {
        #if os(iOS) || os(tvOS)

            UIGraphicsBeginImageContext(rect.size)
            let context = UIGraphicsGetCurrentContext()
            context!.setFillColor(color.cgColor)
            context!.fill(rect)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image!

        #elseif os(OSX)

            let rgbaColor = color.rgbaColor!
            let ciColor = CIColor(red: rgbaColor.red, green: rgbaColor.green, blue: rgbaColor.blue, alpha: rgbaColor.alpha)
            let ciImage = CIImage(color: ciColor)
            let context = CIContext(options: nil)
            guard let cgImage = context.createCGImage(ciImage, from: rect) else {
                fatalError("Error creating the mock image.")
            }

            return TypeImage(cgImage: cgImage, size: rect.size)

        #endif
    }
}
