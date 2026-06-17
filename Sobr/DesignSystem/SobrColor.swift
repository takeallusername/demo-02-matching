import SwiftUI

/// The single source of truth for every color used in Sobr.
///
/// Sobr's identity is calm, clear and fresh — the feeling of a clear morning
/// after choosing not to drink. The palette is a deep midnight base lifted by a
/// teal→aqua "clarity" accent, with semantic accents reserved for the
/// educational story (harm, calm, recovery).
enum SobrColor {

    // MARK: - Surfaces

    /// App background — deep, near-black midnight navy.
    static let background = Color(hex: "#070B12")
    /// Slightly lifted background used behind scrollable content.
    static let backgroundRaised = Color(hex: "#0B1019")
    /// Default card / option surface.
    static let surface = Color(hex: "#141B27")
    /// Elevated surface (selected cards, sheets).
    static let surfaceElevated = Color(hex: "#1B2533")
    /// Hairline separators and inactive tracks.
    static let separator = Color(hex: "#27313F")

    // MARK: - Brand accent (clarity)

    /// Primary brand accent — fresh teal.
    static let accent = Color(hex: "#2FE0C0")
    /// Secondary accent used in gradients — sky/aqua.
    static let accentSecondary = Color(hex: "#39B8F5")
    /// Deep accent for pressed / shadow states.
    static let accentDeep = Color(hex: "#0E8C7A")

    // MARK: - Text

    static let textPrimary = Color(hex: "#F4F8FB")
    static let textSecondary = Color(hex: "#9AA7B8")
    static let textTertiary = Color(hex: "#5E6B7C")
    /// Text that sits on top of the bright accent button.
    static let textOnAccent = Color(hex: "#04201C")

    // MARK: - Semantic (used by the educational story & states)

    /// Harm / warning — used for "why alcohol is dangerous" beats.
    static let harm = Color(hex: "#F0613E")
    /// Calm / depressant — the "alcohol is a depressant" beat.
    static let calm = Color(hex: "#5B8DEF")
    /// Recovery / growth — the "recovery is possible" beat.
    static let recovery = Color(hex: "#36C98D")
    /// Caution amber used in disclaimers and high-risk callouts.
    static let caution = Color(hex: "#F2B544")

    static let success = recovery
    static let danger = harm
}
