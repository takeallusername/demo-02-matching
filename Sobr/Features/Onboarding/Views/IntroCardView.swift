import SwiftUI

/// Mirrors the reference app's "Let's Go!" screen: a first look at the sobriety
/// card the user is about to earn, anchoring the streak idea before the quiz.
struct IntroCardView: View {
    @Environment(OnboardingViewModel.self) private var vm

    var body: some View {
        ZStack {
            SobrScreenBackground(tint: SobrColor.accent)

            VStack(spacing: SobrSpacing.lg) {
                BackBar { vm.back() }

                VStack(spacing: SobrSpacing.xs) {
                    Text("Let's go!")
                        .font(SobrFont.largeTitle(.heavy))
                        .foregroundStyle(SobrColor.textPrimary)
                    Text("Welcome to Sobr. Here's your tracker.")
                        .font(SobrFont.body())
                        .foregroundStyle(SobrColor.textSecondary)
                        .multilineTextAlignment(.center)
                }

                Spacer()

                SobrietyCard(memberName: nil, streakDays: 0, soberSince: .now)

                Spacer()

                Text("Now, let's build your plan around you.")
                    .font(SobrFont.callout())
                    .foregroundStyle(SobrColor.textSecondary)

                PrimaryButton(title: "Next") { vm.advance() }
            }
            .padding(.horizontal, SobrSpacing.screenMargin)
            .padding(.bottom, SobrSpacing.sm)
        }
    }
}
