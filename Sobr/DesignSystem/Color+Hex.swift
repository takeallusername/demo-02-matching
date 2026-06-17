import SwiftUI

extension Color {
    /// Creates a color from a hex string such as `"#1B2230"` or `"1B2230"`.
    /// Supports 6-digit (RGB) and 8-digit (ARGB) values. Falls back to clear
    /// for malformed input so a typo never crashes the UI.
    init(hex: String) {
        let sanitized = hex
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")

        var value: UInt64 = 0
        guard Scanner(string: sanitized).scanHexInt64(&value) else {
            self = .clear
            return
        }

        let a, r, g, b: Double
        switch sanitized.count {
        case 6:
            a = 1
            r = Double((value & 0xFF0000) >> 16) / 255
            g = Double((value & 0x00FF00) >> 8) / 255
            b = Double(value & 0x0000FF) / 255
        case 8:
            a = Double((value & 0xFF000000) >> 24) / 255
            r = Double((value & 0x00FF0000) >> 16) / 255
            g = Double((value & 0x0000FF00) >> 8) / 255
            b = Double(value & 0x000000FF) / 255
        default:
            a = 1; r = 0; g = 0; b = 0
        }

        self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
    }
}
