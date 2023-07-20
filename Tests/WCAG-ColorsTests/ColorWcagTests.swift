//
//  WCAG-Colors
//
//  Copyright (c) 2023 Christoph Wendt
//

import SwiftUI

struct SwiftUIColors {
    static let white = Color(.sRGB, white: 1.0, opacity: 1.0)
    static let black = Color(.sRGB, white: 0.0, opacity: 1.0)
    static let colorWithContrastRatio3 = Color(.sRGB, red: 148 / 255.0, green: 148 / 255.0, blue: 148 / 255.0, opacity: 1.0)
    static let colorWithContrastRatio4_5 = Color(.sRGB, red: 118 / 255.0, green: 118 / 255.0, blue: 118 / 255.0, opacity: 1.0)
    static let colorWithContrastRatio7 = Color(.sRGB, red: 89 / 255.0, green: 89 / 255.0, blue: 89 / 255.0, opacity: 1.0)
    static let semiTransparentColor = Color(.sRGB, red: 0.5, green: 0.0, blue: 1.0, opacity: 0.75)
}

@testable import WCAG_Colors
import Nimble
import Quick

@available(iOS 17, tvOS 17, watchOS 10, macOS 14, *)
class ColorWcagTests: QuickSpec {
    override func spec() {
        describe("The Color class") {
            context("when calling rgbaColor") {
                context("when color space is sRGB") {
                    it("normalizes components to be between 0.0 and 255.0") {
                        let color = SwiftUIColors.white.rgbaColor

                        expect(round(color.red)).to(equal(255.0))
                        expect(round(color.green)).to(equal(255.0))
                        expect(round(color.blue)).to(equal(255.0))
                        expect(color.alpha).to(equal(1.0))
                    }
                }

                context("when color space is Grayscale") {
                    it("uses white value for each color component") {
                        let color = SwiftUIColors.white.rgbaColor

                        expect(round(color.red)).to(equal(255.0))
                        expect(round(color.green)).to(equal(255.0))
                        expect(round(color.blue)).to(equal(255.0))
                        expect(color.alpha).to(equal(1.0))
                    }
                }
            }

            context("when calling getContrastRatio") {
                context("by passing in the same color twice") {
                    it("returns the minimum contrast ratio of 1.0") {
                        expect(Color.getContrastRatio(textColor: SwiftUIColors.white, backgroundColor: SwiftUIColors.white)).to(equal(1.0))
                    }
                }

                context("by passing in white and black") {
                    it("returns the maximum contrast ratio of 21.0") {
                        expect(Color.getContrastRatio(textColor: SwiftUIColors.white, backgroundColor: SwiftUIColors.black)).to(equal(21.0))
                    }
                }

                context("by passing in green and orange color") {
                    it("returns a contrast ratio of 2.31") {
                        let actualContrastRatio = Color.getContrastRatio(textColor: SwiftUIColors.colorWithContrastRatio3, backgroundColor: SwiftUIColors.colorWithContrastRatio7)!
                        let rounded = floor(actualContrastRatio * 100) / 100

                        expect(rounded).to(equal(2.3))
                    }
                }

                context("by passing in semi transparent color and white") {
                    it("returns a contrast ratio of 4.51") {
                        let actualContrastRatio = Color.getContrastRatio(textColor: SwiftUIColors.semiTransparentColor, backgroundColor: SwiftUIColors.white)!
                        let rounded = floor(actualContrastRatio * 100) / 100

                        expect(rounded).to(equal(4.51))
                    }
                }
            }

            context("when calling getTextColor") {
                context("by passing in a dark background color") {
                    it("returns white") {
                        let actual = Color.getTextColor(backgroundColor: SwiftUIColors.black)
                        
                        expect(actual).to(equal(Color.white))
                    }
                }
                
                context("by passing in a light background color") {
                    it("returns black") {
                        let actual = Color.getTextColor(backgroundColor: SwiftUIColors.white)
                        
                        expect(actual).to(equal(Color.black))
                    }
                }
                
                context("by passing in a background color with a medium relative luminance") {
                    it("returns black") {
                        let actual = Color.getTextColor(backgroundColor: SwiftUIColors.colorWithContrastRatio4_5)
                        
                        expect(actual).to(equal(Color.black))
                    }
                }
                
                context("by passing a background color and a list of text SwiftUIColors") {
                    var colors: [Color]!
                    
                    beforeEach {
                        colors = [
                            SwiftUIColors.colorWithContrastRatio3,
                            SwiftUIColors.colorWithContrastRatio4_5,
                            SwiftUIColors.colorWithContrastRatio7,
                        ]
                    }
                    
                    context("by not providing any passing color") {
                        it("returns nil") {
                            let actual = Color.getTextColor(colors: [], elementType: .smallFont, backgroundColor: SwiftUIColors.white, conformanceLevel: .AA)
                            
                            expect(actual).to(beNil())
                        }
                    }
                    
                    context("when defining conformance level .AA") {
                        context("when using a small font") {
                            it("returns black") {
                                let actual = Color.getTextColor(colors: colors!, elementType: .smallFont, backgroundColor: SwiftUIColors.white, conformanceLevel: .AA)
                                
                                expect(actual).to(equal(SwiftUIColors.colorWithContrastRatio4_5))
                            }
                        }
                        
                        context("when using a small bold font") {
                            it("returns black") {
                                let actual = Color.getTextColor(colors: colors!, elementType: .largeFont, backgroundColor: SwiftUIColors.white, conformanceLevel: .AA)
                                
                                expect(actual).to(equal(SwiftUIColors.colorWithContrastRatio3))
                            }
                        }
                        
                        context("when using a large font") {
                            it("returns black") {
                                let actual = Color.getTextColor(colors: colors!, elementType: .largeFont, backgroundColor: SwiftUIColors.white, conformanceLevel: .AA)
                                
                                expect(actual).to(equal(SwiftUIColors.colorWithContrastRatio3))
                            }
                        }
                    }
                    
                    context("when defining conformance level .AAA") {
                        context("when using a small font") {
                            it("returns black") {
                                let actual = Color.getTextColor(colors: colors!, elementType: .smallFont, backgroundColor: SwiftUIColors.white, conformanceLevel: .AAA)
                                
                                expect(actual).to(equal(SwiftUIColors.colorWithContrastRatio7))
                            }
                        }
                        
                        context("when using a large font") {
                            it("returns black") {
                                let actual = Color.getTextColor(colors: colors!, elementType: .largeFont, backgroundColor: SwiftUIColors.white, conformanceLevel: .AAA)
                                
                                expect(actual).to(equal(SwiftUIColors.colorWithContrastRatio4_5))
                            }
                        }
                    }
                }
            }

            context("when calling getBackgroundColor") {
                context("by passing in a dark text color") {
                    it("returns white") {
                        let actual = Color.getBackgroundColor(textColor: SwiftUIColors.black)

                        expect(actual).to(equal(Color.white))
                    }
                }

                context("by passing in a light text color") {
                    it("returns black") {
                        let actual = Color.getBackgroundColor(textColor: SwiftUIColors.white)

                        expect(actual).to(equal(Color.black))
                    }
                }

                context("by passing in a text color with a medium relative luminance") {
                    it("returns black") {
                        let actual = Color.getBackgroundColor(textColor: SwiftUIColors.colorWithContrastRatio4_5)

                        expect(actual).to(equal(Color.black))
                    }
                }
            }

            context("when calling getBackgroundColor with a list of colors") {
                var colors: [Color]!

                beforeEach {
                    colors = [
                        SwiftUIColors.colorWithContrastRatio3,
                        SwiftUIColors.colorWithContrastRatio4_5,
                        SwiftUIColors.colorWithContrastRatio7,
                    ]
                }

                context("by not providing any passing color") {
                    it("returns nil") {
                        let actual = Color.getBackgroundColor(colors: [], textColor: SwiftUIColors.white, elementType: .smallFont, conformanceLevel: .AA)

                        expect(actual).to(beNil())
                    }
                }

                context("when defining conformance level .AA") {
                    context("when using a small font") {
                        it("returns a color of conformance level 4.5") {
                            let actual = Color.getBackgroundColor(colors: colors, textColor: SwiftUIColors.white, elementType: .smallFont, conformanceLevel: .AA)

                            expect(actual).to(equal(SwiftUIColors.colorWithContrastRatio4_5))
                        }
                    }

                    context("when using a large font") {
                        it("returns a color of conformance level 3") {
                            let actual = Color.getBackgroundColor(colors: colors, textColor: SwiftUIColors.white, elementType: .largeFont, conformanceLevel: .AA)

                            expect(actual).to(equal(SwiftUIColors.colorWithContrastRatio3))
                        }
                    }
                }

                context("when defining conformance level .AAA") {
                    context("when using a small font") {
                        it("returns a color of conformance level 7") {
                            let actual = Color.getBackgroundColor(colors: colors, textColor: SwiftUIColors.white, elementType: .smallFont, conformanceLevel: .AAA)

                            expect(actual).to(equal(SwiftUIColors.colorWithContrastRatio7))
                        }
                    }

                    context("when using a large font") {
                        it("returns a color of conformance level 4.5") {
                            let actual = Color.getBackgroundColor(colors: colors, textColor: SwiftUIColors.white, elementType: .largeFont, conformanceLevel: .AAA)

                            expect(actual).to(equal(SwiftUIColors.colorWithContrastRatio4_5))
                        }
                    }
                }
            }
        }
    }
}
