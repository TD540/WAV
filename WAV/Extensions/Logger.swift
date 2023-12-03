//
//  Logger.swift
//  WAV
//
//  Created by thomas on 29/11/2023.
//  https://www.avanderlee.com/debugging/oslog-unified-logging/
//

import OSLog

extension Logger {
    /// Using your bundle identifier is a great way to ensure a unique identifier.
    private static var subsystem = Bundle.main.bundleIdentifier!

    /// Logs the view cycles like a view that appeared.
    static let viewCycle = Logger(subsystem: subsystem, category: "viewcycle")

    /// All logs related to tracking and analytics.
    static let statistics = Logger(subsystem: subsystem, category: "statistics")

    /// All logs related to tracking and analytics.
    static let check = Logger(subsystem: subsystem, category: "check")
}
