import SwiftUI

/// Reusable gradients that carry Sobr's "clarity" identity.
///
/// The signature gradient is an aurora of teal → aqua → blue, evoking clear
/// water and a clear head. Education beats each get their own accent gradient so
/// the story has visual momentum (harm, calm, recovery) — mirroring how the
/// reference onboarding shifts color per slide.
enum SobrGradient {

    /// Primary brand gradient — used on primary buttons and key accents.
    static let brand = LinearGradient(
        colors: [SobrColor.accent, SobrColor.accentSecondary],
        startPoint: .leading,
        endPoint: .trailing
    )

    /// The iridescent "sobriety card" gradient (Sobr's answer to the
    /// reference app's membership card). A living aurora of cool tones.
    static let auroraCard = LinearGradient(
        colors: [
            Color(hex: "#0E8C7A"),
            Color(hex: "#1FB6C9"),
            Color(hex: "#3C7BE0"),
            Color(hex: "#1A9E83")
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    /// Subtle vertical wash applied behind most screens for depth.
    static func screenWash(_ tint: Color = SobrColor.accent) -> LinearGradient {
        LinearGradient(
            colors: [tint.opacity(0.16), SobrColor.background],
            startPoint: .top,
            endPoint: .center
        )
    }

    // MARK: - Per-beat education accents

    static let harm = LinearGradient(
        colors: [Color(hex: "#F0613E"), Color(hex: "#B5341C")],
        startPoint: .top, endPoint: .bottom
    )

    static let calm = LinearGradient(
        colors: [Color(hex: "#5B8DEF"), Color(hex: "#27408B")],
        startPoint: .top, endPoint: .bottom
    )

    static let recovery = LinearGradient(
        colors: [Color(hex: "#36C98D"), Color(hex: "#138A5A")],
        startPoint: .top, endPoint: .bottom
    )

    /// Maps a semantic accent color to its matching gradient, so screens can be
    /// driven entirely by a single `EducationSlide.accent` value.
    static func forAccent(_ color: Color) -> LinearGradient {
        switch color {
        case SobrColor.harm: return harm
        case SobrColor.calm: return calm
        case SobrColor.recovery: return recovery
        default: return brand
        }
    }
}
