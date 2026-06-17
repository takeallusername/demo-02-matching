import SwiftUI
import Observation

/// Drives the onboarding flow: which step is on screen, the answers collected so
/// far, the derived dependence score, and the assembly of the final
/// `UserProfile`. Views stay thin and delegate all decisions here.
@Observable
final class OnboardingViewModel {

    // MARK: - Navigation

    private(set) var step: OnboardingStep = .splash

    /// Forward progress through the whole flow as 0...1 (used by the quiz bar).
    var quizProgress: Double {
        guard !QuizContent.questions.isEmpty else { return 0 }
        return Double(currentQuestionIndex + 1) / Double(QuizContent.questions.count)
    }

    // MARK: - Quiz state

    let questions = QuizContent.questions
    private(set) var currentQuestionIndex = 0

    /// question.id → selected option index.
    private(set) var answers: [String: Int] = [:]

    var currentQuestion: QuizQuestion { questions[currentQuestionIndex] }

    func selectedOptionIndex(for question: QuizQuestion) -> Int? { answers[question.id] }

    // MARK: - "About you" + selections

    var name: String = ""
    var ageRange: AgeRange? = nil
    var selectedSymptomIDs: Set<String> = []
    var selectedGoalIDs: Set<String> = []

    // MARK: - Derived

    /// 0–100 self-assessment score, averaged over the answered scored
    /// questions. Returns a sensible mid value if nothing was answered.
    var dependenceScore: Int {
        let scored = questions.filter(\.isScored)
        let weights: [Double] = scored.compactMap { q in
            guard let idx = answers[q.id], q.options.indices.contains(idx) else { return nil }
            return q.options[idx].weight
        }
        guard !weights.isEmpty else { return 50 }
        let average = weights.reduce(0, +) / Double(weights.count)
        return Int((average * 100).rounded())
    }

    /// Population reference the analysis screen compares against. Static, for
    /// illustrative comparison only.
    let averageScore = 41

    /// Days until the projected milestone shown on the plan/paywall.
    private let projectionDays = 90

    var projectedDate: Date {
        Calendar.current.date(byAdding: .day, value: projectionDays, to: .now) ?? .now
    }

    // MARK: - Quiz actions

    func answerCurrent(optionIndex: Int) {
        answers[currentQuestion.id] = optionIndex
        // Auto-advance after a brief beat for tactile feedback.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.28) { [weak self] in
            self?.advanceQuiz()
        }
    }

    private func advanceQuiz() {
        if currentQuestionIndex < questions.count - 1 {
            withAnimation(.easeInOut(duration: 0.25)) { currentQuestionIndex += 1 }
        } else {
            goTo(.aboutYou)
        }
    }

    func skipQuiz() { goTo(.aboutYou) }

    // MARK: - Step navigation

    func advance() {
        let all = OnboardingStep.allCases
        guard let i = all.firstIndex(of: step), i < all.count - 1 else { return }
        goTo(all[i + 1])
    }

    func back() {
        if step == .quiz && currentQuestionIndex > 0 {
            withAnimation(.easeInOut(duration: 0.25)) { currentQuestionIndex -= 1 }
            return
        }
        let all = OnboardingStep.allCases
        guard let i = all.firstIndex(of: step), i > 0 else { return }
        goTo(all[i - 1])
    }

    func goTo(_ target: OnboardingStep) {
        withAnimation(.easeInOut(duration: 0.4)) { step = target }
    }

    // MARK: - Completion

    /// Assemble the profile draft from everything collected during onboarding.
    /// The user isn't premium yet — that's decided at the paywall.
    func buildDraft() -> UserProfile {
        UserProfile(
            name: name.trimmingCharacters(in: .whitespaces),
            ageRange: ageRange,
            gender: genderFromAnswer(),
            dependenceScore: dependenceScore,
            selectedSymptomIDs: selectedSymptomIDs,
            selectedGoalIDs: selectedGoalIDs,
            soberSince: .now,
            targetDate: projectedDate,
            isPremium: false
        )
    }

    private func genderFromAnswer() -> Gender? {
        guard let idx = answers["gender"],
              let label = questions.first(where: { $0.id == "gender" })?.options[safe: idx]?.label
        else { return nil }
        return Gender(rawValue: label)
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
