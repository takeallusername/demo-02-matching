import SwiftUI

/// Top-level router: shows onboarding until a profile exists, then the main
/// tab experience. The cross-fade keeps the transition calm and on-brand.
struct RootView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        ZStack {
            if appState.hasCompletedOnboarding {
                MainTabView()
                    .transition(.opacity)
            } else {
                OnboardingContainerView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.45), value: appState.hasCompletedOnboarding)
    }
}
