//
//  WCAG-Colors
//
//  Copyright (c) 2023 Christoph Wendt
//

import os.log

infix operator >=: ComparisonPrecedence

extension OSLogType {
    static func >= (lhs: OSLogType, rhs: OSLogType) -> Bool {
        switch lhs {
        case .fault:
            return true
        case .error:
            return rhs != .fault
        case .default:
            return rhs == .debug || rhs == .info || rhs == .default
        case info:
            return rhs == .debug || rhs == .info
        case .debug:
            return rhs == .debug
        default:
            return false
        }
    }
}
