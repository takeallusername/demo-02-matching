import SwiftUI

/// The quiz screen. Shows one question at a time with a top progress bar, a
/// numbered list of options, and a "Skip test" escape hatch — exactly mirroring
/// the reference flow. All state and scoring live in the view-model.
struct QuizView: View {
    @Environment(OnboardingViewModel.self) private var vm

    var body: some View {
        ZStack {
            SobrScreenBackground(tint: SobrColor.accent)

            VStack(spacing: SobrSpacing.lg) {
                OnboardingProgressBar(progress: vm.quizProgress) { vm.back() }
                    .padding(.top, SobrSpacing.xs)

                let question = vm.currentQuestion

                VStack(spacing: SobrSpacing.sm) {
                    Text("Question #\(vm.currentQuestionIndex + 1)")
                        .font(SobrFont.title(.bold))
                        .foregroundStyle(SobrColor.textPrimary)

                    Text(question.prompt)
                        .font(SobrFont.headline(.regular))
                        .foregroundStyle(SobrColor.textPrimary)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.top, SobrSpacing.sm)

                VStack(spacing: SobrSpacing.sm) {
                    ForEach(Array(question.options.enumerated()), id: \.element.id) { idx, option in
                        OptionCard(
                            index: idx + 1,
                            title: option.label,
                            isSelected: vm.selectedOptionIndex(for: question) == idx
                        ) {
                            vm.answerCurrent(optionIndex: idx)
                        }
                    }
                }
                .padding(.top, SobrSpacing.sm)
                // Re-animate the option list as questions change.
                .id(vm.currentQuestionIndex)
                .transition(.opacity.combined(with: .move(edge: .trailing)))

                Spacer()

                TextLinkButton(title: "Skip test") { vm.skipQuiz() }
                    .padding(.bottom, SobrSpacing.sm)
            }
            .padding(.horizontal, SobrSpacing.screenMargin)
        }
    }
}
