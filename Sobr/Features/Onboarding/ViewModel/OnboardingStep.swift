import Foundation

/// The ordered macro-steps of onboarding (adapted for alcohol). The quiz and
/// the carousels manage their own internal paging; this enum sequences the
/// top-level screens.
///
/// The paywall is intentionally **not** a step here — it is a separate
/// top-level route (`AppState.Route.paywall`) so a hard paywall can be
/// re-presented on relaunch until the user converts. `rating` is the final
/// onboarding step, placed immediately before checkout.
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
    case notifications      // enable reminders
    case planReveal         // "we built you a plan" card
    case rating             // ask for a rating — last step before checkout

    static func < (lhs: OnboardingStep, rhs: OnboardingStep) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
