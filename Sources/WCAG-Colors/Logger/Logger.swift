//
//  WCAG-Colors
//
//  Copyright (c) 2023 Christoph Wendt
//

import os.log

struct Logger {
    static var minLogType: OSLogType = .debug
    static var onLog: ((String, OSLogType) -> Void) = defaultOnLog

    private static let defaultLog = OSLog(
        subsystem: "com.chrs1885.wcag-colors",
        category: "WCAG-Colors"
    )

    private static func logIfNeeded(message: String, logType: OSLogType) {
        if logType >= minLogType {
            onLog(message, logType)
        }
    }

    static var defaultOnLog: (String, OSLogType) -> Void = { message, logType in
        os_log("%{public}@", log: Logger.defaultLog, type: logType, message)
    }
}

// MARK: - Logging API

extension Logger {
    static func verbose(_ message: String) {
        logIfNeeded(message: message, logType: .debug)
    }

    static func info(_ message: String) {
        logIfNeeded(message: message, logType: .info)
    }

    static func warning(_ message: String) {
        logIfNeeded(message: message, logType: .default)
    }

    static func error(_ message: String) {
        logIfNeeded(message: message, logType: .error)
    }

    static func systemError(_ message: String) {
        logIfNeeded(message: message, logType: .fault)
    }
}
