import SwiftUI

/// "Give us a rating" — a lightweight social-proof / rating-prompt screen. The
/// real App Store review request would be triggered elsewhere; here we mirror
/// the reference flow's placement and let the user continue either way.
struct RatingView: View {
    @Environment(OnboardingViewModel.self) private var vm
    /// Called when the user moves on from rating — straight into checkout.
    let onContinue: () -> Void

    var body: some View {
        ZStack {
            SobrScreenBackground(tint: SobrColor.accent, showStars: false)

            VStack(spacing: SobrSpacing.lg) {
                BackBar { vm.back() }

                Spacer(minLength: 0)

                Text("Give us a rating")
                    .font(SobrFont.hero())
                    .foregroundStyle(SobrColor.textPrimary)
                    .multilineTextAlignment(.center)

                StarRow(size: 30)

                Text("Sobr was built to help people take back control from alcohol. Your support helps someone else find it.")
                    .font(SobrFont.body())
                    .foregroundStyle(SobrColor.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, SobrSpacing.sm)

                Spacer()

                PrimaryButton(title: "Continue") { onContinue() }
                TextLinkButton(title: "Maybe later") { onContinue() }
                    .padding(.bottom, SobrSpacing.sm)
            }
            .padding(.horizontal, SobrSpacing.screenMargin)
        }
    }
}
