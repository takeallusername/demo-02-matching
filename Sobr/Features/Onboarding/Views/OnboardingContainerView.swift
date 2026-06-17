import SwiftUI

/// Hosts the onboarding flow and maps the current `OnboardingStep` to its
/// screen. Each screen is intentionally dumb — it receives what it needs and
/// reports back through the view-model, which owns all flow decisions.
struct OnboardingContainerView: View {
    @Environment(AppState.self) private var appState
    @State private var vm = OnboardingViewModel()

    var body: some View {
        ZStack {
            screen
                .id(vm.step)
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))
        }
        .environment(vm)
    }

    @ViewBuilder
    private var screen: some View {
        switch vm.step {
        case .splash:           SplashView()
        case .welcome:          WelcomeView()
        case .introCard:        IntroCardView()
        case .quiz:             QuizView()
        case .aboutYou:         AboutYouView()
        case .calculating:      CalculatingView()
        case .analysis:         AnalysisView()
        case .symptoms:         SymptomsView()
        case .educationAlcohol: EducationCarouselView(
                                    slides: EducationContent.understandingAlcohol,
                                    title: "Understanding alcohol",
                                    onFinish: { vm.advance() })
        case .educationSobr:    EducationCarouselView(
                                    slides: EducationContent.welcomeToSobr,
                                    title: "Welcome to Sobr",
                                    onFinish: { vm.advance() })
        case .testimonials:     TestimonialsView()
        case .pathToFreedom:    PathToFreedomView()
        case .goals:            GoalsView()
        case .notifications:    NotificationsView()
        case .planReveal:       PlanRevealView()
        case .rating:           RatingView(onContinue: {
                                    appState.beginCheckout(with: vm.buildDraft())
                                })
        }
    }
}
