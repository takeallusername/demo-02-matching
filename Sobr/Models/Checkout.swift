import Foundation

/// Which offer the hard paywall is currently presenting. The stage only ever
/// moves toward a better deal for the user — never back.
enum PaywallStage: String, Codable {
    /// First view: monthly / yearly / standard lifetime.
    case standard
    /// Triggered when the user tries to leave without buying.
    case exitOffer
    /// Triggered a day later if they still haven't converted.
    case finalOffer

    /// The lifetime plan headlined at this stage.
    var lifetimePlan: SubscriptionPlan {
        switch self {
        case .standard:   return .lifetime
        case .exitOffer:  return .exitLifetime
        case .finalOffer: return .finalLifetime
        }
    }
}

/// Persisted state for a user who has finished onboarding but not yet paid.
/// Because Sobr is a hard paywall, this is what brings them straight back to the
/// paywall on relaunch (rather than redoing onboarding) and remembers which
/// downsell they've reached.
struct PendingCheckout: Codable, Equatable {
    /// The profile assembled during onboarding, applied once they convert.
    var draft: UserProfile
    /// When the paywall was first reached — the clock for the next-day offer.
    var reachedAt: Date
    var stage: PaywallStage

    /// Number of seconds after which the final ($11.99) offer unlocks.
    static let finalOfferDelay: TimeInterval = 24 * 60 * 60
}
