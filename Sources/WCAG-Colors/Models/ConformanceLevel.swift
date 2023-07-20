//
//  WCAG-Colors
//
//  Copyright (c) 2023 Christoph Wendt
//

import CoreGraphics

infix operator >=: ComparisonPrecedence

/// An enum specifying all WCAG conformance levels.
public enum ConformanceLevel: Int {
    /// The minimum level of conformance.
    case A = 1

    /// The medium level of conformance including success criterias of level A.
    case AA = 2

    /// The highest level of conformance including success criterias of level A and AA.
    case AAA = 3

    /// Indicates that no level of conformance has been reached.
    case failed = 0
}

extension ConformanceLevel {
    /**
     Initializes a ConformanceLevel based on a given contrast ratio and the application of the color pair.

     - Parameters:
         - contrastRatio: The contrast ratio of a text and its background.
         - elementType: The application of the color pair.
     */
    public init(contrastRatio: CGFloat, elementType: ElementType) {
        self = ConformanceLevel.failed

        switch elementType {
        case .smallFont:
            guard contrastRatio >= 4.5 else { break }
            self = contrastRatio >= 7.0 ? .AAA : .AA
        case .largeFont:
            guard contrastRatio >= 3.0 else { break }
            self = contrastRatio >= 4.5 ? .AAA : .AA
        case .uiComponents:
            guard contrastRatio >= 3.0 else { break }
            self = .AA
        }
    }

    /// The text representation of the conformance level.
    public var text: String {
        switch self {
        case .A:
            return "A"
        case .AA:
            return "AA"
        case .AAA:
            return "AAA"
        case .failed:
            return "failed"
        }
    }

    static func >= (lhs: ConformanceLevel, rhs: ConformanceLevel) -> Bool {
        return lhs.rawValue >= rhs.rawValue
    }
}
