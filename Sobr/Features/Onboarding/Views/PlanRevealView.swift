import SwiftUI

/// "Building your plan" — a five-step reveal that makes the personalization feel
/// real: each step types out (with a "두두두" haptic), then completes with a
/// green check and a success tap. After all five, the finished sobriety card
/// drops in and the user continues.
struct PlanRevealView: View {
    @Environment(OnboardingViewModel.self) private var vm

    @State private var currentStep = 0
    @State private var completedSteps = 0
    @State private var showSummary = false

    /// Steps reference the user's real input so it reads as genuine analysis.
    private var steps: [String] {
        let answers = max(vm.answers.count, 1)
        let symptoms = vm.selectedSymptomIDs.count
        let goals = max(vm.selectedGoalIDs.count, 1)
        return [
            "Reviewing your \(answers) answers…",
            symptoms > 0 ? "Noting the \(symptoms) symptoms you picked…"
                         : "Studying your drinking patterns…",
            "Pinpointing the triggers behind your cravings…",
            "Matching you with the right tools…",
            "Finalizing a plan around your \(goals) goal\(goals == 1 ? "" : "s")…"
        ]
    }

    var body: some View {
        ZStack {
            SobrScreenBackground(tint: SobrColor.accent, showStars: false)

            VStack(spacing: SobrSpacing.lg) {
                header

                VStack(alignment: .leading, spacing: SobrSpacing.md) {
                    ForEach(Array(steps.enumerated()), id: \.offset) { index, line in
                        if index <= currentStep {
                            StepRow(
                                text: line,
                                isComplete: index < completedSteps,
                                isActive: index == currentStep && index >= completedSteps,
                                onTyped: { advanceAfterTyping(index: index) }
                            )
                            .transition(.move(edge: .leading).combined(with: .opacity))
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .animation(.spring(response: 0.4), value: currentStep)

                Spacer()

                if showSummary {
                    summary.transition(.scale(scale: 0.94).combined(with: .opacity))
                }

                Spacer()

                PrimaryButton(title: "See my plan", isEnabled: showSummary) {
                    vm.advance()
                }
                .opacity(showSummary ? 1 : 0.35)
            }
            .padding(.horizontal, SobrSpacing.screenMargin)
            .padding(.bottom, SobrSpacing.sm)
        }
        .onAppear { HapticsManager.shared.prepare() }
    }

    private var header: some View {
        VStack(spacing: SobrSpacing.xs) {
            Text(vm.name.isEmpty ? "Building your plan" : "\(vm.name), building your plan")
                .font(SobrFont.title(.heavy))
                .foregroundStyle(SobrColor.textPrimary)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.8)
                .lineLimit(2)
            Text("We checked everything you told us.")
                .font(SobrFont.callout())
                .foregroundStyle(SobrColor.textSecondary)
        }
        .padding(.top, SobrSpacing.md)
    }

    private var summary: some View {
        VStack(spacing: SobrSpacing.md) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 40))
                .foregroundStyle(SobrColor.recovery)
            Text(vm.name.isEmpty ? "Your plan is ready"
                                 : "\(vm.name), your plan is ready")
                .font(SobrFont.headline(.bold))
                .foregroundStyle(SobrColor.textPrimary)
                .multilineTextAlignment(.center)
        }
    }

    /// When a step finishes typing, mark it complete (check + success tap), then
    /// reveal the next one — or the summary after the last.
    private func advanceAfterTyping(index: Int) {
        guard index == currentStep else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            withAnimation(.spring(response: 0.35)) { completedSteps = index + 1 }
            HapticsManager.shared.success()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                if index + 1 < steps.count {
                    withAnimation { currentStep = index + 1 }
                } else {
                    withAnimation(.spring(response: 0.5)) { showSummary = true }
                    HapticsManager.shared.success()
                }
            }
        }
    }
}

/// A single "building" row: a spinner/check on the left, typewriter text on the
/// right.
private struct StepRow: View {
    let text: String
    let isComplete: Bool
    let isActive: Bool
    let onTyped: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: SobrSpacing.sm) {
            ZStack {
                if isComplete {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(SobrColor.recovery)
                        .transition(.scale.combined(with: .opacity))
                } else {
                    Image(systemName: "circle.dotted")
                        .foregroundStyle(SobrColor.accent)
                        .symbolEffect(.pulse, isActive: isActive)
                }
            }
            .font(.system(size: 20))
            .frame(width: 24, height: 24)

            // Active row types out; already-complete rows render statically.
            if isComplete {
                Text(text)
                    .font(SobrFont.body(.medium))
                    .foregroundStyle(SobrColor.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                TypewriterText(
                    text: text,
                    font: SobrFont.body(.semibold),
                    color: SobrColor.textPrimary,
                    alignment: .leading,
                    charInterval: 0.025,
                    onFinished: onTyped
                )
            }
        }
    }
}
