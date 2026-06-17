import SwiftUI

/// Opening splash: wordmark and a quiet, hopeful tagline. Auto-advances to the
/// welcome screen after a short beat.
struct SplashView: View {
    @Environment(OnboardingViewModel.self) private var vm
    @State private var appeared = false

    var body: some View {
        ZStack {
            SobrScreenBackground(tint: SobrColor.accent)

            VStack(spacing: SobrSpacing.lg) {
                SobrLogo(size: 46)
                    .scaleEffect(appeared ? 1 : 0.9)
                    .opacity(appeared ? 1 : 0)

                Text("The clear-headed you\nis already on the way.")
                    .font(SobrFont.title(.semibold))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(SobrColor.textSecondary)
                    .opacity(appeared ? 1 : 0)
                    .padding(.horizontal, SobrSpacing.xl)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) { appeared = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.9) {
                vm.advance()
            }
        }
    }
}
