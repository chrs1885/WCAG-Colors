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
    static let p3Color = Color(.displayP3, red: 1.5, green: -1.5, blue: 0.5, opacity: 1.0)
}

@testable import WCAG_Colors
import Nimble
import Quick

@available(macOS 14.0, *)
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

                context("when color space is P3") {
                    it("normalizes components to sRGB") {
                        let color = SwiftUIColors.p3Color.rgbaColor

                        expect(color.red).to(equal(255.0))
                        expect(color.green).to(equal(0.0))
                        expect(floor(color.blue)).to(equal(127.0))
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
                        expect(Color.getContrastRatio(forTextColor: SwiftUIColors.white, onBackgroundColor: SwiftUIColors.white)).to(equal(1.0))
                    }
                }

                context("by passing in white and black") {
                    it("returns the maximum contrast ratio of 21.0") {
                        expect(Color.getContrastRatio(forTextColor: SwiftUIColors.white, onBackgroundColor: SwiftUIColors.black)).to(equal(21.0))
                    }
                }

                context("by passing in green and orange color") {
                    it("returns a contrast ratio of 2.31") {
                        let actualContrastRatio = Color.getContrastRatio(forTextColor: SwiftUIColors.colorWithContrastRatio3, onBackgroundColor: SwiftUIColors.colorWithContrastRatio7)!
                        let rounded = floor(actualContrastRatio * 100) / 100

                        expect(rounded).to(equal(2.3))
                    }
                }

                context("by passing in semi transparent color and white") {
                    it("returns a contrast ratio of 4.51") {
                        let actualContrastRatio = Color.getContrastRatio(forTextColor: SwiftUIColors.semiTransparentColor, onBackgroundColor: SwiftUIColors.white)!
                        let rounded = floor(actualContrastRatio * 100) / 100

                        expect(rounded).to(equal(4.51))
                    }
                }
            }

            context("when calling getTextColor") {
                context("by passing in a dark background color") {
                    it("returns white") {
                        let actual = Color.getTextColor(onBackgroundColor: SwiftUIColors.black)
                        
                        expect(actual).to(equal(Color.white))
                    }
                }
                
                context("by passing in a light background color") {
                    it("returns black") {
                        let actual = Color.getTextColor(onBackgroundColor: SwiftUIColors.white)
                        
                        expect(actual).to(equal(Color.black))
                    }
                }
                
                context("by passing in a background color with a medium relative luminance") {
                    it("returns black") {
                        let actual = Color.getTextColor(onBackgroundColor: SwiftUIColors.colorWithContrastRatio4_5)
                        
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
                            let actual = Color.getTextColor(fromColors: [], withFontSize: .small, onBackgroundColor: SwiftUIColors.white, conformanceLevel: .AA)
                            
                            expect(actual).to(beNil())
                        }
                    }
                    
                    context("when defining conformance level .AA") {
                        context("when using a small font") {
                            it("returns black") {
                                let actual = Color.getTextColor(fromColors: colors!, withFontSize: .small, onBackgroundColor: SwiftUIColors.white, conformanceLevel: .AA)
                                
                                expect(actual).to(equal(SwiftUIColors.colorWithContrastRatio4_5))
                            }
                        }
                        
                        context("when using a small bold font") {
                            it("returns black") {
                                let actual = Color.getTextColor(fromColors: colors!, withFontSize: .boldSmall, onBackgroundColor: SwiftUIColors.white, conformanceLevel: .AA)
                                
                                expect(actual).to(equal(SwiftUIColors.colorWithContrastRatio3))
                            }
                        }
                        
                        context("when using a large font") {
                            it("returns black") {
                                let actual = Color.getTextColor(fromColors: colors!, withFontSize: .large, onBackgroundColor: SwiftUIColors.white, conformanceLevel: .AA)
                                
                                expect(actual).to(equal(SwiftUIColors.colorWithContrastRatio3))
                            }
                        }
                    }
                    
                    context("when defining conformance level .AAA") {
                        context("when using a small font") {
                            it("returns black") {
                                let actual = Color.getTextColor(fromColors: colors!, withFontSize: .small, onBackgroundColor: SwiftUIColors.white, conformanceLevel: .AAA)
                                
                                expect(actual).to(equal(SwiftUIColors.colorWithContrastRatio7))
                            }
                        }
                        
                        context("when using a small bold font") {
                            it("returns black") {
                                let actual = Color.getTextColor(fromColors: colors!, withFontSize: .boldSmall, onBackgroundColor: SwiftUIColors.white, conformanceLevel: .AAA)
                                
                                expect(actual).to(equal(SwiftUIColors.colorWithContrastRatio4_5))
                            }
                        }
                        
                        context("when using a large font") {
                            it("returns black") {
                                let actual = Color.getTextColor(fromColors: colors!, withFontSize: .large, onBackgroundColor: SwiftUIColors.white, conformanceLevel: .AAA)
                                
                                expect(actual).to(equal(SwiftUIColors.colorWithContrastRatio4_5))
                            }
                        }
                    }
                }
            }

            context("when calling getBackgroundColor") {
                context("by passing in a dark text color") {
                    it("returns white") {
                        let actual = Color.getBackgroundColor(forTextColor: SwiftUIColors.black)

                        expect(actual).to(equal(Color.white))
                    }
                }

                context("by passing in a light text color") {
                    it("returns black") {
                        let actual = Color.getBackgroundColor(forTextColor: SwiftUIColors.white)

                        expect(actual).to(equal(Color.black))
                    }
                }

                context("by passing in a text color with a medium relative luminance") {
                    it("returns black") {
                        let actual = Color.getBackgroundColor(forTextColor: SwiftUIColors.colorWithContrastRatio4_5)

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
                        let actual = Color.getBackgroundColor(fromColors: [], forTextColor: SwiftUIColors.white, withFontSize: .small, conformanceLevel: .AA)

                        expect(actual).to(beNil())
                    }
                }

                context("when defining conformance level .AA") {
                    context("when using a small font") {
                        it("returns a color of conformance level 4.5") {
                            let actual = Color.getBackgroundColor(fromColors: colors, forTextColor: SwiftUIColors.white, withFontSize: .small, conformanceLevel: .AA)

                            expect(actual).to(equal(SwiftUIColors.colorWithContrastRatio4_5))
                        }
                    }

                    context("when using a small bold font") {
                        it("returns a color of conformance level 3") {
                            let actual = Color.getBackgroundColor(fromColors: colors, forTextColor: SwiftUIColors.white, withFontSize: .boldSmall, conformanceLevel: .AA)

                            expect(actual).to(equal(SwiftUIColors.colorWithContrastRatio3))
                        }
                    }

                    context("when using a large font") {
                        it("returns a color of conformance level 3") {
                            let actual = Color.getBackgroundColor(fromColors: colors, forTextColor: SwiftUIColors.white, withFontSize: .large, conformanceLevel: .AA)

                            expect(actual).to(equal(SwiftUIColors.colorWithContrastRatio3))
                        }
                    }
                }

                context("when defining conformance level .AAA") {
                    context("when using a small font") {
                        it("returns a color of conformance level 7") {
                            let actual = Color.getBackgroundColor(fromColors: colors, forTextColor: SwiftUIColors.white, withFontSize: .small, conformanceLevel: .AAA)

                            expect(actual).to(equal(SwiftUIColors.colorWithContrastRatio7))
                        }
                    }

                    context("when using a small bold font") {
                        it("returns a color of conformance level 4.5") {
                            let actual = Color.getBackgroundColor(fromColors: colors, forTextColor: SwiftUIColors.white, withFontSize: .boldSmall, conformanceLevel: .AAA)

                            expect(actual).to(equal(SwiftUIColors.colorWithContrastRatio4_5))
                        }
                    }

                    context("when using a large font") {
                        it("returns a color of conformance level 4.5") {
                            let actual = Color.getBackgroundColor(fromColors: colors, forTextColor: SwiftUIColors.white, withFontSize: .large, conformanceLevel: .AAA)

                            expect(actual).to(equal(SwiftUIColors.colorWithContrastRatio4_5))
                        }
                    }
                }
            }
        }
    }
}
