//
//  WCAG-Colors
//
//  Copyright (c) 2023 Christoph Wendt
//

import CoreGraphics
import Nimble
import Quick
@testable import WCAG_Colors

class ImageAverageColorTests: QuickSpec {
    override static func spec() {
        describe("The UIImage/NSImage class") {
            var sut: TypeImage!

            context("when calling averageColor() for a red image") {
                beforeEach {
                    sut = TypeImage.mock(withColor: .red, rect: CGRect(x: 0, y: 0, width: 3, height: 3))
                }

                it("returns .red") {
                    expect(sut.averageColor()?.rgbaColor).to(equal(TypeColor.red.rgbaColor))
                }
            }
        }
    }
}
