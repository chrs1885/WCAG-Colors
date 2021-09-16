//
//  WCAG-Colors
//
//  Copyright (c) 2021 Christoph Wendt
//

@testable import WCAG_Colors
import Nimble
import Quick

class RGBAColorTests: QuickSpec {
    override func spec() {
        struct Colors {
            static let white = RGBAColor(red: 255.0, green: 255.0, blue: 255.0, alpha: 1.0)
            static let semiTransparentColor = RGBAColor(red: 0.5 * 255.0, green: 0.0, blue: 255.0, alpha: 0.75)
            static let blendedColor = RGBAColor(red: 0.625 * 255.0, green: 0.25 * 255.0, blue: 255.0, alpha: 1.0)
        }

        describe("The RGBAColor class") {
            context("when calling getBlendedColor") {
                context("by passing in a semi transparent color and a opaque color") {
                    it("returns a color blended with its background color") {
                        let actual = Colors.semiTransparentColor.blended(withFraction: Colors.semiTransparentColor.alpha, ofColor: Colors.white)

                        expect(actual).to(equal(Colors.blendedColor))
                    }
                }
            }
        }
    }
}
