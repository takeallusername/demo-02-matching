import SwiftUI

/// "Give us a rating" — a lightweight social-proof / rating-prompt screen. The
/// real App Store review request would be triggered elsewhere; here we mirror
/// the reference flow's placement and let the user continue either way.
struct RatingView: View {
    @Environment(OnboardingViewModel.self) private var vm

    var body: some View {
        ZStack {
            SobrScreenBackground(tint: SobrColor.accent, showStars: false)

            VStack(spacing: SobrSpacing.lg) {
                BackBar { vm.back() }

                Spacer()

                Text("Give us a rating")
                    .font(SobrFont.hero())
                    .foregroundStyle(SobrColor.textPrimary)
                    .multilineTextAlignment(.center)

                HStack(spacing: 8) {
                    ForEach(0..<5, id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .font(.system(size: 30))
                            .foregroundStyle(SobrColor.caution)
                    }
                }

                Text("Sobr was built to help people take back control from alcohol. Your support helps someone else find it.")
                    .font(SobrFont.body())
                    .foregroundStyle(SobrColor.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, SobrSpacing.sm)

                Spacer()

                PrimaryButton(title: "Next") { vm.advance() }
                TextLinkButton(title: "Maybe later") { vm.advance() }
                    .padding(.bottom, SobrSpacing.sm)
            }
            .padding(.horizontal, SobrSpacing.screenMargin)
        }
    }
}
