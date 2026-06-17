import SwiftUI

/// Spacing, corner-radius and sizing constants on a consistent 4-pt grid.
/// Using named tokens instead of magic numbers keeps layouts rhythmic and
/// makes global tuning trivial.
enum SobrSpacing {
    static let xxs: CGFloat = 4
    static let xs: CGFloat = 8
    static let sm: CGFloat = 12
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48

    /// Standard horizontal screen inset.
    static let screenMargin: CGFloat = 24
}

enum SobrRadius {
    static let sm: CGFloat = 10
    static let md: CGFloat = 16
    static let lg: CGFloat = 22
    static let xl: CGFloat = 28
    /// Fully rounded pill (use with a large value clamped by the frame).
    static let pill: CGFloat = 999
}
