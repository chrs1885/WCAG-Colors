//
//  WCAG-Colors
//
//  Copyright (c) 2023 Christoph Wendt
//

import Nimble
import Quick
@testable import WCAG_Colors

class ConformanceLevelTests: QuickSpec {
    override static func spec() {
        describe("The ConformanceLevel class") {
            var sut: ConformanceLevel?

            context("when initialized") {
                context("with a contrast ratio of 2.9") {
                    context("and large text size") {
                        beforeEach {
                            sut = ConformanceLevel(contrastRatio: 2.9, elementType: .largeFont)
                        }

                        it("returns .failed") {
                            expect(sut!).to(equal(.failed))
                        }
                    }
                }

                context("with a contrast ratio of 3.0") {
                    context("and large text size") {
                        beforeEach {
                            sut = ConformanceLevel(contrastRatio: 3.0, elementType: .largeFont)
                        }

                        it("returns .AA") {
                            expect(sut!).to(equal(.AA))
                        }
                    }
                }

                context("with a contrast ratio of 4.4") {
                    context("and small text size") {
                        beforeEach {
                            sut = ConformanceLevel(contrastRatio: 4.4, elementType: .smallFont)
                        }

                        it("returns .failed") {
                            expect(sut!).to(equal(.failed))
                        }
                    }

                    context("and large text size") {
                        beforeEach {
                            sut = ConformanceLevel(contrastRatio: 4.4, elementType: .largeFont)
                        }

                        it("returns .AA") {
                            expect(sut!).to(equal(.AA))
                        }
                    }
                }

                context("with a contrast ratio of 4.5") {
                    context("and small text size") {
                        beforeEach {
                            sut = ConformanceLevel(contrastRatio: 4.5, elementType: .smallFont)
                        }

                        it("returns .AA") {
                            expect(sut!).to(equal(.AA))
                        }
                    }

                    context("and large text size") {
                        beforeEach {
                            sut = ConformanceLevel(contrastRatio: 4.5, elementType: .largeFont)
                        }

                        it("returns .AAA") {
                            expect(sut!).to(equal(.AAA))
                        }
                    }
                }

                context("with a contrast ratio of 6.9") {
                    context("and small text size") {
                        beforeEach {
                            sut = ConformanceLevel(contrastRatio: 6.9, elementType: .smallFont)
                        }

                        it("returns .AA") {
                            expect(sut!).to(equal(.AA))
                        }
                    }
                }

                context("with a contrast ratio of 7.0") {
                    context("and small text size") {
                        beforeEach {
                            sut = ConformanceLevel(contrastRatio: 7.0, elementType: .smallFont)
                        }

                        it("returns .AAA") {
                            expect(sut!).to(equal(.AAA))
                        }
                    }
                }
            }

            context("when retrieving the text property value") {
                context("for conformance level .A") {
                    it("returns 'A'") {
                        expect(ConformanceLevel.A.text).to(equal("A"))
                    }
                }

                context("for conformance level .AA") {
                    it("returns 'AA'") {
                        expect(ConformanceLevel.AA.text).to(equal("AA"))
                    }
                }

                context("for conformance level .AAA") {
                    it("returns 'AAA'") {
                        expect(ConformanceLevel.AAA.text).to(equal("AAA"))
                    }
                }

                context("for conformance level .failed") {
                    it("returns 'failed'") {
                        expect(ConformanceLevel.failed.text).to(equal("failed"))
                    }
                }
            }

            context("when comparing ConformanceLevel types by using >= operator") {
                it("returns the correct result") {
                    expect(ConformanceLevel.AAA >= ConformanceLevel.AAA).to(beTrue())
                    expect(ConformanceLevel.AAA >= ConformanceLevel.AA).to(beTrue())
                    expect(ConformanceLevel.AAA >= ConformanceLevel.A).to(beTrue())
                    expect(ConformanceLevel.AAA >= ConformanceLevel.failed).to(beTrue())

                    expect(ConformanceLevel.AA >= ConformanceLevel.AAA).to(beFalse())
                    expect(ConformanceLevel.AA >= ConformanceLevel.AA).to(beTrue())
                    expect(ConformanceLevel.AA >= ConformanceLevel.A).to(beTrue())
                    expect(ConformanceLevel.AA >= ConformanceLevel.failed).to(beTrue())

                    expect(ConformanceLevel.A >= ConformanceLevel.AAA).to(beFalse())
                    expect(ConformanceLevel.A >= ConformanceLevel.AA).to(beFalse())
                    expect(ConformanceLevel.A >= ConformanceLevel.A).to(beTrue())
                    expect(ConformanceLevel.A >= ConformanceLevel.failed).to(beTrue())

                    expect(ConformanceLevel.failed >= ConformanceLevel.AAA).to(beFalse())
                    expect(ConformanceLevel.failed >= ConformanceLevel.AA).to(beFalse())
                    expect(ConformanceLevel.failed >= ConformanceLevel.A).to(beFalse())
                    expect(ConformanceLevel.failed >= ConformanceLevel.failed).to(beTrue())
                }
            }
        }
    }
}
