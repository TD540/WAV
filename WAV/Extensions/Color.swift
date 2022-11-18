//
//  Color.swift
//  WeAreVarious
//
//  https://stackoverflow.com/a/64103125/147163
//

import SwiftUI

extension Color {
    // swiftlint:disable:next large_tuple
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, opacity: CGFloat) {
        #if canImport(UIKit)
        typealias NativeColor = UIColor
        #elseif canImport(AppKit)
        typealias NativeColor = NSColor
        #endif

        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var opacity: CGFloat = 0

        guard NativeColor(self).getRed(&red, green: &green, blue: &blue, alpha: &opacity) else {
            return (0, 0, 0, 0)
        }
        return (red, green, blue, opacity)
    }

    func lighter(by percentage: CGFloat = 30.0) -> Color {
        return self.adjust(by: abs(percentage) )
    }

    func darker(by percentage: CGFloat = 30.0) -> Color {
        return self.adjust(by: -1 * abs(percentage) )
    }

    func adjust(by percentage: CGFloat = 30.0) -> Color {
        return Color(red: min(Double(self.components.red + percentage/100), 1.0),
                     green: min(Double(self.components.green + percentage/100), 1.0),
                     blue: min(Double(self.components.blue + percentage/100), 1.0),
                     opacity: Double(self.components.opacity))
    }
}
