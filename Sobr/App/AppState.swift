import Foundation
import Observation

/// App-wide state and the single owner of the persisted `UserProfile`.
///
/// Responsibilities are deliberately narrow: decide whether to show onboarding
/// or the main app, expose the active profile, and persist changes. Feature
/// logic lives in feature view-models, not here.
@Observable
final class AppState {
    /// The active on-device profile, or `nil` until onboarding completes.
    private(set) var profile: UserProfile?

    var hasCompletedOnboarding: Bool { profile != nil }

    @ObservationIgnored private let store: ProfileStoring

    init(store: ProfileStoring = PersistenceService()) {
        self.store = store
        self.profile = store.loadProfile()
    }

    /// Persist the profile assembled during onboarding and switch to the app.
    func completeOnboarding(with profile: UserProfile) {
        self.profile = profile
        store.save(profile)
    }

    /// Apply an in-place edit to the profile and persist it.
    func updateProfile(_ mutate: (inout UserProfile) -> Void) {
        guard var profile else { return }
        mutate(&profile)
        self.profile = profile
        store.save(profile)
    }

    /// Wipe local data and return to onboarding (used from Settings).
    func resetEverything() {
        store.clear()
        profile = nil
    }
}
