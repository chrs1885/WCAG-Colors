//
//  WCAG-Colors
//
//  Copyright (c) 2023 Christoph Wendt
//

#if os(iOS) || os(tvOS) || os(watchOS)

    import UIKit

    struct Colors {
        static let white = UIColor(white: 1.0, alpha: 1.0)
        static let black = UIColor(white: 0.0, alpha: 1.0)
        static let colorWithContrastRatio3 = UIColor(red: 148 / 255.0, green: 148 / 255.0, blue: 148 / 255.0, alpha: 1.0)
        static let colorWithContrastRatio4_5 = UIColor(red: 118 / 255.0, green: 118 / 255.0, blue: 118 / 255.0, alpha: 1.0)
        static let colorWithContrastRatio7 = UIColor(red: 89 / 255.0, green: 89 / 255.0, blue: 89 / 255.0, alpha: 1.0)
        static let semiTransparentColor = UIColor(red: 0.5, green: 0.0, blue: 1.0, alpha: 0.75)
    }

#elseif os(OSX)

    import AppKit

    struct Colors {
        static let white = NSColor(white: 1.0, alpha: 1.0)
        static let black = NSColor(white: 0.0, alpha: 1.0)
        static let colorWithContrastRatio3 = NSColor(deviceRed: 148 / 255.0, green: 148 / 255.0, blue: 148 / 255.0, alpha: 1.0)
        static let colorWithContrastRatio4_5 = NSColor(deviceRed: 118 / 255.0, green: 118 / 255.0, blue: 118 / 255.0, alpha: 1.0)
        static let colorWithContrastRatio7 = NSColor(deviceRed: 89 / 255.0, green: 89 / 255.0, blue: 89 / 255.0, alpha: 1.0)
        static let semiTransparentColor = NSColor(deviceRed: 0.5, green: 0.0, blue: 1.0, alpha: 0.75)
        static let cmykColor = NSColor(deviceCyan: 1.0, magenta: 0.0, yellow: 0.0, black: 0.0, alpha: 1.0)
    }

#endif

import Nimble
import Quick
@testable import WCAG_Colors

class TypeColorWcagTests: QuickSpec {
    override static func spec() {
        describe("The UIColor/NSColor class") {
            context("when calling rgbaColor") {
                context("when color space is sRGB") {
                    it("normalizes components to be between 0.0 and 255.0") {
                        let color = Colors.white.rgbaColor!

                        expect(color.red).to(equal(255.0))
                        expect(color.green).to(equal(255.0))
                        expect(color.blue).to(equal(255.0))
                        expect(color.alpha).to(equal(1.0))
                    }
                }

                context("when color space is Grayscale") {
                    it("uses white value for each color component") {
                        let color = Colors.white.rgbaColor!

                        #if os(iOS) || os(tvOS) || os(watchOS)

                            var whiteComponent: CGFloat = 0, alphaComponent: CGFloat = 0
                            Colors.white.getWhite(&whiteComponent, alpha: &alphaComponent)

                        #elseif os(OSX)

                            let whiteComponent = Colors.white.whiteComponent
                            let alphaComponent = Colors.white.alphaComponent

                        #endif

                        expect(color.red).to(equal(whiteComponent * 255.0))
                        expect(color.green).to(equal(whiteComponent * 255.0))
                        expect(color.blue).to(equal(whiteComponent * 255.0))
                        expect(color.alpha).to(equal(alphaComponent))
                    }
                }

                #if os(OSX)

                    context("when color space is CMYK compatible") {
                        it("converts the color to sRGB") {
                            expect(Colors.cmykColor.rgbaColor).toNot(throwError())
                        }
                    }

                #endif
            }

            context("when calling getContrastRatio") {
                context("by passing in the same color twice") {
                    it("returns the minimum contrast ratio of 1.0") {
                        expect(TypeColor.getContrastRatio(foregroundColor: Colors.white, backgroundColor: Colors.white)).to(equal(1.0))
                    }
                }

                context("by passing in white and black") {
                    it("returns the maximum contrast ratio of 21.0") {
                        expect(TypeColor.getContrastRatio(foregroundColor: Colors.white, backgroundColor: Colors.black)).to(equal(21.0))
                    }
                }

                context("by passing in green and orange color") {
                    it("returns a contrast ratio of 2.31") {
                        expect(TypeColor.getContrastRatio(foregroundColor: Colors.colorWithContrastRatio3, backgroundColor: Colors.colorWithContrastRatio7)).to(equal(2.31))
                    }
                }

                context("by passing in semi transparent color and white") {
                    it("returns a contrast ratio of 4.51") {
                        expect(TypeColor.getContrastRatio(foregroundColor: Colors.semiTransparentColor, backgroundColor: Colors.white)).to(equal(4.52))
                    }
                }
            }

            context("when calling getForegroundColor") {
                context("by passing in a dark background color") {
                    it("returns white") {
                        let actual = TypeColor.getForegroundColor(backgroundColor: Colors.black)

                        expect(actual).to(equal(TypeColor.white))
                    }
                }

                context("by passing in a light background color") {
                    it("returns black") {
                        let actual = TypeColor.getForegroundColor(backgroundColor: Colors.white)

                        expect(actual).to(equal(TypeColor.black))
                    }
                }

                context("by passing in a background color with a medium relative luminance") {
                    it("returns black") {
                        let actual = TypeColor.getForegroundColor(backgroundColor: Colors.colorWithContrastRatio4_5)

                        expect(actual).to(equal(TypeColor.black))
                    }
                }

                context("by passing a background color and a list of text colors") {
                    var colors: [TypeColor]?

                    beforeEach {
                        colors = [
                            Colors.colorWithContrastRatio3,
                            Colors.colorWithContrastRatio4_5,
                            Colors.colorWithContrastRatio7,
                        ]
                    }

                    context("by not providing any passing color") {
                        it("returns nil") {
                            let actual = TypeColor.getForegroundColor(colors: [], elementType: .smallFont, backgroundColor: Colors.white, conformanceLevel: .AA)

                            expect(actual).to(beNil())
                        }
                    }

                    context("when defining conformance level .AA") {
                        context("when using a small font") {
                            it("returns black") {
                                let actual = TypeColor.getForegroundColor(colors: colors!, elementType: .smallFont, backgroundColor: Colors.white, conformanceLevel: .AA)

                                expect(actual).to(equal(Colors.colorWithContrastRatio4_5))
                            }
                        }

                        context("when using a large font") {
                            it("returns black") {
                                let actual = TypeColor.getForegroundColor(colors: colors!, elementType: .largeFont, backgroundColor: Colors.white, conformanceLevel: .AA)

                                expect(actual).to(equal(Colors.colorWithContrastRatio3))
                            }
                        }

                        context("when using an UI component") {
                            it("returns black") {
                                let actual = TypeColor.getForegroundColor(colors: colors!, elementType: .uiComponents, backgroundColor: Colors.white, conformanceLevel: .AA)

                                expect(actual).to(equal(Colors.colorWithContrastRatio3))
                            }
                        }
                    }

                    context("when defining conformance level .AAA") {
                        context("when using a small font") {
                            it("returns black") {
                                let actual = TypeColor.getForegroundColor(colors: colors!, elementType: .smallFont, backgroundColor: Colors.white, conformanceLevel: .AAA)

                                expect(actual).to(equal(Colors.colorWithContrastRatio7))
                            }
                        }

                        context("when using a large font") {
                            it("returns black") {
                                let actual = TypeColor.getForegroundColor(colors: colors!, elementType: .largeFont, backgroundColor: Colors.white, conformanceLevel: .AAA)

                                expect(actual).to(equal(Colors.colorWithContrastRatio4_5))
                            }
                        }
                    }
                }

                #if os(iOS) || os(tvOS) || os(OSX)

                    context("by passing in a dark background image") {
                        it("returns white") {
                            let backgroundImage = TypeImage.mock(withColor: Colors.black)
                            let actual = TypeColor.getForegroundColor(backgroundImage: backgroundImage)

                            expect(actual).to(equal(TypeColor.white))
                        }
                    }

                    context("by passing in a light background image") {
                        it("returns black") {
                            let backgroundImage = TypeImage.mock(withColor: Colors.white)
                            let actual = TypeColor.getForegroundColor(backgroundImage: backgroundImage)

                            expect(actual).to(equal(TypeColor.black))
                        }
                    }

                    context("by passing in a background image with a medium relative luminance") {
                        it("returns black") {
                            let backgroundImage = TypeImage.mock(withColor: Colors.colorWithContrastRatio4_5)
                            let actual = TypeColor.getForegroundColor(backgroundImage: backgroundImage)

                            expect(actual).to(equal(TypeColor.black))
                        }
                    }

                    context("by passing a background image and a list of text colors") {
                        var colors: [TypeColor]!
                        var backgroundImage: TypeImage!

                        beforeEach {
                            backgroundImage = TypeImage.mock(withColor: Colors.white)
                            colors = [
                                Colors.colorWithContrastRatio3,
                                Colors.colorWithContrastRatio4_5,
                                Colors.colorWithContrastRatio7,
                            ]
                        }

                        context("by not providing any passing color") {
                            it("returns nil") {
                                let actual = TypeColor.getForegroundColor(colors: [], elementType: .smallFont, backgroundImage: backgroundImage, conformanceLevel: .AA)

                                expect(actual).to(beNil())
                            }
                        }

                        context("when defining conformance level .AA") {
                            context("when using a small font") {
                                it("returns a color of conformance level 4.5") {
                                    let actual = TypeColor.getForegroundColor(colors: colors, elementType: .smallFont, backgroundImage: backgroundImage, conformanceLevel: .AA)

                                    expect(actual).to(equal(Colors.colorWithContrastRatio4_5))
                                }
                            }

                            context("when using a large font") {
                                it("returns a color of conformance level 3") {
                                    let actual = TypeColor.getForegroundColor(colors: colors, elementType: .largeFont, backgroundImage: backgroundImage, conformanceLevel: .AA)

                                    expect(actual).to(equal(Colors.colorWithContrastRatio3))
                                }
                            }

                            context("when using an UI component") {
                                it("returns a color of conformance level 3") {
                                    let actual = TypeColor.getForegroundColor(colors: colors, elementType: .uiComponents, backgroundImage: backgroundImage, conformanceLevel: .AA)

                                    expect(actual).to(equal(Colors.colorWithContrastRatio3))
                                }
                            }
                        }

                        context("when defining conformance level .AAA") {
                            context("when using a small font") {
                                it("returns a color of conformance level 7") {
                                    let actual = TypeColor.getForegroundColor(colors: colors, elementType: .smallFont, backgroundImage: backgroundImage, conformanceLevel: .AAA)

                                    expect(actual).to(equal(Colors.colorWithContrastRatio7))
                                }
                            }

                            context("when using a large font") {
                                it("returns a color of conformance level 4.5") {
                                    let actual = TypeColor.getForegroundColor(colors: colors, elementType: .largeFont, backgroundImage: backgroundImage, conformanceLevel: .AAA)

                                    expect(actual).to(equal(Colors.colorWithContrastRatio4_5))
                                }
                            }
                        }
                    }

                #endif
            }

            context("when calling getBackgroundColor") {
                context("by passing in a dark text color") {
                    it("returns white") {
                        let actual = TypeColor.getBackgroundColor(foregroundColor: Colors.black)

                        expect(actual).to(equal(TypeColor.white))
                    }
                }

                context("by passing in a light text color") {
                    it("returns black") {
                        let actual = TypeColor.getBackgroundColor(foregroundColor: Colors.white)

                        expect(actual).to(equal(TypeColor.black))
                    }
                }

                context("by passing in a text color with a medium relative luminance") {
                    it("returns black") {
                        let actual = TypeColor.getBackgroundColor(foregroundColor: Colors.colorWithContrastRatio4_5)

                        expect(actual).to(equal(TypeColor.black))
                    }
                }
            }

            context("when calling getBackgroundColor with a list of colors") {
                var colors: [TypeColor]?

                beforeEach {
                    colors = [
                        Colors.colorWithContrastRatio3,
                        Colors.colorWithContrastRatio4_5,
                        Colors.colorWithContrastRatio7,
                    ]
                }

                context("by not providing any passing color") {
                    it("returns nil") {
                        let actual = TypeColor.getBackgroundColor(colors: [], foregroundColor: Colors.white, elementType: .smallFont, conformanceLevel: .AA)

                        expect(actual).to(beNil())
                    }
                }

                context("when defining conformance level .AA") {
                    context("when using a small font") {
                        it("returns a color of conformance level 4.5") {
                            let actual = TypeColor.getBackgroundColor(colors: colors!, foregroundColor: Colors.white, elementType: .smallFont, conformanceLevel: .AA)

                            expect(actual).to(equal(Colors.colorWithContrastRatio4_5))
                        }
                    }

                    context("when using a large font") {
                        it("returns a color of conformance level 3") {
                            let actual = TypeColor.getBackgroundColor(colors: colors!, foregroundColor: Colors.white, elementType: .largeFont, conformanceLevel: .AA)

                            expect(actual).to(equal(Colors.colorWithContrastRatio3))
                        }
                    }

                    context("when using an UI component") {
                        it("returns a color of conformance level 3") {
                            let actual = TypeColor.getBackgroundColor(colors: colors!, foregroundColor: Colors.white, elementType: .uiComponents, conformanceLevel: .AA)

                            expect(actual).to(equal(Colors.colorWithContrastRatio3))
                        }
                    }
                }

                context("when defining conformance level .AAA") {
                    context("when using a small font") {
                        it("returns a color of conformance level 7") {
                            let actual = TypeColor.getBackgroundColor(colors: colors!, foregroundColor: Colors.white, elementType: .smallFont, conformanceLevel: .AAA)

                            expect(actual).to(equal(Colors.colorWithContrastRatio7))
                        }
                    }

                    context("when using a large font") {
                        it("returns a color of conformance level 4.5") {
                            let actual = TypeColor.getBackgroundColor(colors: colors!, foregroundColor: Colors.white, elementType: .largeFont, conformanceLevel: .AAA)

                            expect(actual).to(equal(Colors.colorWithContrastRatio4_5))
                        }
                    }
                }
            }
        }
    }
}
