import SwiftUI
import UserNotifications

/// "Stay on track with reminders" — requests notification permission so Sobr can
/// send gentle daily check-in nudges. Either choice continues the flow.
struct NotificationsView: View {
    @Environment(OnboardingViewModel.self) private var vm

    var body: some View {
        ZStack {
            SobrScreenBackground(tint: SobrColor.accent)

            VStack(spacing: SobrSpacing.lg) {
                Spacer()

                Image(systemName: "bell.badge.fill")
                    .font(.system(size: 56))
                    .foregroundStyle(SobrColor.accent)
                    .shadow(color: SobrColor.accent.opacity(0.5), radius: 24)

                Text("Stay on track with reminders")
                    .font(SobrFont.title(.heavy))
                    .foregroundStyle(SobrColor.textPrimary)
                    .multilineTextAlignment(.center)

                Text("Get gentle daily nudges and milestone celebrations, so you never lose sight of your goal.")
                    .font(SobrFont.body())
                    .foregroundStyle(SobrColor.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, SobrSpacing.sm)

                Spacer()

                PrimaryButton(title: "Enable notifications") { requestAndContinue() }
                TextLinkButton(title: "Not now") { vm.advance() }
                    .padding(.bottom, SobrSpacing.sm)
            }
            .padding(.horizontal, SobrSpacing.screenMargin)
        }
    }

    private func requestAndContinue() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in
                DispatchQueue.main.async { vm.advance() }
            }
    }
}
