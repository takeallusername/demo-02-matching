import Foundation

/// Abstraction over local persistence so the rest of the app never touches
/// `UserDefaults` directly. This makes the storage layer swappable (e.g. for a
/// Keychain or file-based store later) and trivially mockable in tests.
protocol ProfileStoring {
    func loadProfile() -> UserProfile?
    func save(_ profile: UserProfile)
    func clear()
}

/// Default implementation backed by `UserDefaults`, encoding the profile as
/// JSON. All data stays on-device — Sobr does not sync recovery data to a
/// server.
final class PersistenceService: ProfileStoring {
    private let defaults: UserDefaults
    private let profileKey = "sobr.userProfile.v1"

    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func loadProfile() -> UserProfile? {
        guard let data = defaults.data(forKey: profileKey) else { return nil }
        return try? decoder.decode(UserProfile.self, from: data)
    }

    func save(_ profile: UserProfile) {
        guard let data = try? encoder.encode(profile) else { return }
        defaults.set(data, forKey: profileKey)
    }

    func clear() {
        defaults.removeObject(forKey: profileKey)
    }
}
