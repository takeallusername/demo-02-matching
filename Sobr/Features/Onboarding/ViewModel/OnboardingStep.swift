import Foundation

/// The ordered macro-steps of onboarding, matching the reference app's flow
/// (adapted for alcohol). The quiz and the carousels manage their own internal
/// paging; this enum sequences the top-level screens.
enum OnboardingStep: Int, CaseIterable, Comparable {
    case splash
    case welcome
    case introCard          // "Let's begin" — sobriety card preview
    case quiz               // Q1…Q10 (internal paging)
    case aboutYou           // "Finally" — name + age
    case calculating        // analysing responses
    case analysis           // score vs. average
    case symptoms           // self-identified symptoms
    case educationAlcohol   // "Understanding alcohol" carousel
    case educationSobr      // "Welcome to Sobr" carousel
    case testimonials       // anonymous experiences
    case pathToFreedom      // recovery graph + social proof
    case goals              // choose goals to track
    case rating             // ask for a rating
    case notifications      // enable reminders
    case planReveal         // "we built you a plan" card
    case paywall            // benefits + plan selection

    static func < (lhs: OnboardingStep, rhs: OnboardingStep) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
