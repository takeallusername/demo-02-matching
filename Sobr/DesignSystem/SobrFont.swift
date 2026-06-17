import SwiftUI

/// Typographic scale for Sobr.
///
/// Sobr uses the system rounded design for a soft, approachable, modern feel
/// (closer to a wellness app than a clinical one). Centralising the scale here
/// keeps every screen visually consistent and makes a future custom-font swap a
/// one-file change.
enum SobrFont {
    static func largeTitle(_ weight: Font.Weight = .bold) -> Font {
        .system(size: 34, weight: weight, design: .rounded)
    }

    /// Hero headline used on welcome / education / paywall screens.
    static func hero(_ weight: Font.Weight = .heavy) -> Font {
        .system(size: 30, weight: weight, design: .rounded)
    }

    static func title(_ weight: Font.Weight = .bold) -> Font {
        .system(size: 24, weight: weight, design: .rounded)
    }

    static func headline(_ weight: Font.Weight = .semibold) -> Font {
        .system(size: 20, weight: weight, design: .rounded)
    }

    static func body(_ weight: Font.Weight = .regular) -> Font {
        .system(size: 17, weight: weight, design: .rounded)
    }

    static func callout(_ weight: Font.Weight = .medium) -> Font {
        .system(size: 15, weight: weight, design: .rounded)
    }

    static func footnote(_ weight: Font.Weight = .medium) -> Font {
        .system(size: 13, weight: weight, design: .rounded)
    }

    static func caption(_ weight: Font.Weight = .semibold) -> Font {
        .system(size: 11, weight: weight, design: .rounded)
    }

    /// Oversized numerals for the streak counter and analysis score.
    static func counter(_ weight: Font.Weight = .heavy) -> Font {
        .system(size: 64, weight: weight, design: .rounded)
    }
}
