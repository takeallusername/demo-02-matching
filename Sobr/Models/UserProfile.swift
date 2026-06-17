import Foundation

/// The persisted profile produced by onboarding and used throughout the app.
///
/// Privacy by design: this is stored only on-device (see `PersistenceService`).
/// Unlike apps that have leaked sensitive recovery data from misconfigured
/// cloud databases, Sobr keeps a user's answers local.
struct UserProfile: Codable, Equatable {
    var name: String
    var ageRange: AgeRange?
    var gender: Gender?

    /// 0–100 self-assessment dependence score derived from the quiz.
    var dependenceScore: Int

    /// Symptoms the user self-identified with, by stable id.
    var selectedSymptomIDs: Set<String>

    /// Recovery goals the user chose to track, by stable id.
    var selectedGoalIDs: Set<String>

    /// The moment the user committed to sobriety — the anchor for every streak.
    var soberSince: Date

    /// Projected "freedom" date surfaced on the plan/paywall screens.
    var targetDate: Date

    /// Whether the user unlocked premium (simulated; no real billing here).
    var isPremium: Bool

    /// A user-editable estimate of money previously spent on alcohol per day,
    /// used to compute the "money saved" figure. Defaults to a modest amount.
    var estimatedDailySpend: Double = 12

    static func makeEmpty() -> UserProfile {
        UserProfile(
            name: "",
            ageRange: nil,
            gender: nil,
            dependenceScore: 0,
            selectedSymptomIDs: [],
            selectedGoalIDs: [],
            soberSince: .now,
            targetDate: .now,
            isPremium: false
        )
    }
}

enum Gender: String, Codable, CaseIterable, Identifiable {
    case male = "Male"
    case female = "Female"
    case other = "Prefer not to say"
    var id: String { rawValue }
}

enum AgeRange: String, Codable, CaseIterable, Identifiable {
    case under18 = "Under 18"
    case eighteenToTwentyFour = "18–24"
    case twentyFiveToThirtyFour = "25–34"
    case thirtyFiveToFortyFour = "35–44"
    case fortyFivePlus = "45+"
    var id: String { rawValue }
}
