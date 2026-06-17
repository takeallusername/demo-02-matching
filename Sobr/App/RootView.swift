import SwiftUI

/// Top-level router. Onboarding → (hard) paywall → main app. The cross-fade
/// keeps transitions calm and on-brand.
struct RootView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        ZStack {
            switch appState.route {
            case .main:
                MainTabView()
                    .transition(.opacity)
            case .paywall:
                PaywallView()
                    .transition(.opacity)
            case .onboarding:
                OnboardingContainerView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.45), value: appState.route)
    }
}
