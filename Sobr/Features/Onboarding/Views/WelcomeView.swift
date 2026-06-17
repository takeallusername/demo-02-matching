import SwiftUI

/// "Welcome" — frames the question the quiz will answer, with a star-rating
/// flourish and the primary "Start now" call to action.
struct WelcomeView: View {
    @Environment(OnboardingViewModel.self) private var vm

    var body: some View {
        ZStack {
            SobrScreenBackground(tint: SobrColor.accent)

            VStack(alignment: .leading, spacing: SobrSpacing.lg) {
                SobrLogo(size: 22)
                    .frame(maxWidth: .infinity)
                    .padding(.top, SobrSpacing.sm)

                Spacer()

                Text("Welcome")
                    .font(SobrFont.largeTitle(.heavy))
                    .foregroundStyle(SobrColor.textPrimary)
                    .minimumScaleFactor(0.8)
                    .lineLimit(1)

                Text("Let's start by finding out where alcohol really sits in your life.")
                    .font(SobrFont.headline(.regular))
                    .foregroundStyle(SobrColor.textSecondary)

                StarRow(size: 18)
                    .padding(.top, SobrSpacing.sm)

                Spacer()

                PrimaryButton(title: "Start now") { vm.advance() }

                Text("Already sober-curious? You're in the right place.")
                    .font(SobrFont.footnote())
                    .foregroundStyle(SobrColor.textTertiary)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)

                Text("By continuing you agree to our Terms & Privacy Policy.")
                    .font(SobrFont.caption(.medium))
                    .foregroundStyle(SobrColor.textTertiary)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, SobrSpacing.xs)
            }
            .padding(.horizontal, SobrSpacing.screenMargin)
        }
    }
}
