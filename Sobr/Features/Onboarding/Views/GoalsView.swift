import SwiftUI

/// "Choose your goals" — a multi-select list of the benefits the user wants to
/// track during their reboot. Selections are saved onto the profile.
struct GoalsView: View {
    @Environment(OnboardingViewModel.self) private var vm

    var body: some View {
        ZStack(alignment: .bottom) {
            SobrScreenBackground(tint: SobrColor.accent, showStars: false)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: SobrSpacing.lg) {
                    BackBar { vm.back() }

                    VStack(spacing: SobrSpacing.xs) {
                        Text("Choose your goals")
                            .font(SobrFont.title(.heavy))
                            .foregroundStyle(SobrColor.textPrimary)
                        Text("What do you want to gain by getting sober?")
                            .font(SobrFont.callout())
                            .foregroundStyle(SobrColor.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)

                    ForEach(GoalContent.all) { goal in
                        SelectableRow(
                            title: goal.title,
                            icon: goal.symbol,
                            iconTint: goal.tint,
                            isSelected: vm.selectedGoalIDs.contains(goal.id)
                        ) {
                            toggle(goal.id)
                        }
                    }

                    Color.clear.frame(height: 96)
                }
                .padding(.horizontal, SobrSpacing.screenMargin)
                .padding(.top, SobrSpacing.xs)
            }

            PrimaryButton(title: "Track these goals",
                          isEnabled: !vm.selectedGoalIDs.isEmpty) { vm.advance() }
                .padding(.horizontal, SobrSpacing.screenMargin)
                .padding(.bottom, SobrSpacing.sm)
                .background(
                    LinearGradient(colors: [.clear, SobrColor.background],
                                   startPoint: .top, endPoint: .bottom)
                        .frame(height: 140).allowsHitTesting(false),
                    alignment: .bottom
                )
        }
    }

    private func toggle(_ id: String) {
        withAnimation(.spring(response: 0.3)) {
            if vm.selectedGoalIDs.contains(id) {
                vm.selectedGoalIDs.remove(id)
            } else {
                vm.selectedGoalIDs.insert(id)
            }
        }
    }
}
