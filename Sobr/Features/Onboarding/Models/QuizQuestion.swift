import Foundation

/// A single onboarding quiz question. Some questions are diagnostic (their
/// options carry a `weight` used to compute the dependence score); others —
/// like gender or referral source — are contextual and unscored.
struct QuizQuestion: Identifiable, Equatable {
    let id: String
    let prompt: String
    let options: [QuizOption]

    /// A question contributes to the score only if its options carry weights.
    var isScored: Bool { options.contains { $0.weight != nil } }
}

/// One selectable answer. `weight` is a 0...1 severity contribution; `nil`
/// means the option does not affect the score.
struct QuizOption: Identifiable, Equatable {
    let id = UUID()
    let label: String
    var weight: Double? = nil
}
