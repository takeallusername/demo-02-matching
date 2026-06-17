import SwiftUI

/// The "we've built you a plan" reveal: a short sequence of statements paired
/// with the sobriety card, building anticipation before the paywall. Taps (or a
/// timer) advance through the lines, then move on.
struct PlanRevealView: View {
    @Environment(OnboardingViewModel.self) private var vm
    @State private var lineIndex = 0

    private var lines: [String] {
        let who = vm.name.isEmpty ? "you" : vm.name
        return [
            "Based on your answers, we've built a plan just for \(who).",
            "It's designed to help you take back control \u{2014} for good.",
            "Now, it's time to invest in yourself."
        ]
    }

    var body: some View {
        ZStack {
            SobrScreenBackground(tint: SobrColor.accent, showStars: false)

            VStack(spacing: SobrSpacing.xl) {
                Spacer()

                Text(lines[lineIndex])
                    .font(SobrFont.title(.bold))
                    .foregroundStyle(SobrColor.textPrimary)
                    .multilineTextAlignment(.center)
                    .id(lineIndex)
                    .transition(.opacity)
                    .padding(.horizontal, SobrSpacing.sm)

                SobrietyCard(memberName: vm.name.isEmpty ? nil : vm.name,
                             streakDays: 0, soberSince: .now)

                Spacer()

                Text("Tap to continue")
                    .font(SobrFont.footnote())
                    .foregroundStyle(SobrColor.textTertiary)
                    .padding(.bottom, SobrSpacing.md)
            }
            .padding(.horizontal, SobrSpacing.screenMargin)
        }
        .contentShape(Rectangle())
        .onTapGesture { advance() }
        .onAppear { scheduleAuto() }
    }

    private func advance() {
        if lineIndex < lines.count - 1 {
            withAnimation(.easeInOut(duration: 0.4)) { lineIndex += 1 }
            scheduleAuto()
        } else {
            vm.advance()
        }
    }

    /// Gently auto-advances so the screen is never a dead end if untouched.
    private func scheduleAuto() {
        let capturedIndex = lineIndex
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.6) {
            if capturedIndex == lineIndex { advance() }
        }
    }
}
