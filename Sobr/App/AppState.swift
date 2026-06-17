import Foundation
import Observation

/// App-wide state and the single owner of the persisted `UserProfile` and the
/// in-progress checkout.
///
/// Routing is a hard gate: a user only reaches the main app once they convert on
/// the paywall. Before that they are either onboarding or sitting on the paywall
/// (which re-presents itself on relaunch, escalating its offer over time).
@Observable
final class AppState {

    enum Route { case onboarding, paywall, main }

    /// Set only after a successful purchase.
    private(set) var profile: UserProfile?

    /// Set when onboarding finishes but the user hasn't paid yet.
    private(set) var pendingCheckout: PendingCheckout?

    @ObservationIgnored private let store: ProfileStoring

    init(store: ProfileStoring = PersistenceService()) {
        self.store = store
        self.profile = store.loadProfile()
        self.pendingCheckout = store.loadPendingCheckout()
        escalateOfferIfDue()
    }

    /// The screen the root view should show.
    var route: Route {
        if profile != nil { return .main }
        if pendingCheckout != nil { return .paywall }
        return .onboarding
    }

    // MARK: - Checkout (hard paywall)

    /// Called when onboarding reaches the paywall. Persists the draft so the
    /// paywall survives relaunches until the user converts.
    func beginCheckout(with draft: UserProfile) {
        let checkout = PendingCheckout(draft: draft, reachedAt: .now, stage: .standard)
        pendingCheckout = checkout
        store.save(checkout)
    }

    /// The user tried to leave the paywall — drop to the better exit offer.
    func registerExitIntent() {
        guard var checkout = pendingCheckout, checkout.stage == .standard else { return }
        checkout.stage = .exitOffer
        pendingCheckout = checkout
        store.save(checkout)
    }

    /// A successful (simulated) purchase: promote the draft to the live profile.
    func completePurchase(plan: SubscriptionPlan) {
        guard var draft = pendingCheckout?.draft else { return }
        draft.isPremium = true
        profile = draft
        store.save(draft)
        pendingCheckout = nil
        store.clearPendingCheckout()
    }

    /// If a day has passed since the paywall was first reached and the user
    /// still hasn't paid, unlock the final ($11.99) offer.
    private func escalateOfferIfDue() {
        guard var checkout = pendingCheckout, checkout.stage != .finalOffer else { return }
        if Date.now.timeIntervalSince(checkout.reachedAt) >= PendingCheckout.finalOfferDelay {
            checkout.stage = .finalOffer
            pendingCheckout = checkout
            store.save(checkout)
        }
    }

    // MARK: - Profile editing

    func updateProfile(_ mutate: (inout UserProfile) -> Void) {
        guard var profile else { return }
        mutate(&profile)
        self.profile = profile
        store.save(profile)
    }

    /// Wipe everything and return to onboarding (used from Settings).
    func resetEverything() {
        store.clear()
        store.clearPendingCheckout()
        profile = nil
        pendingCheckout = nil
    }
}
