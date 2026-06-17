import SwiftUI

/// "My why" — reflects the user's chosen goals and self-identified symptoms back
/// to them, a simple motivation anchor to revisit in a tough moment.
struct MyWhyView: View {
    @Environment(AppState.self) private var appState

    private var profile: UserProfile? { appState.profile }

    private var goals: [Goal] {
        guard let ids = profile?.selectedGoalIDs else { return [] }
        return GoalContent.all.filter { ids.contains($0.id) }
    }

    private var symptoms: [Symptom] {
        guard let ids = profile?.selectedSymptomIDs else { return [] }
        return SymptomContent.all.filter { ids.contains($0.id) }
    }

    var body: some View {
        ZStack {
            SobrScreenBackground(tint: SobrColor.harm)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: SobrSpacing.xl) {
                    VStack(alignment: .leading, spacing: SobrSpacing.xs) {
                        Text("My why")
                            .font(SobrFont.title(.heavy))
                            .foregroundStyle(SobrColor.textPrimary)
                        Text("The reasons you started. Come back here whenever it's hard.")
                            .font(SobrFont.callout())
                            .foregroundStyle(SobrColor.textSecondary)
                    }

                    if !goals.isEmpty {
                        VStack(alignment: .leading, spacing: SobrSpacing.sm) {
                            SectionHeader(title: "What I'm gaining")
                            FlowLayout(spacing: SobrSpacing.xs) {
                                ForEach(goals) { goal in
                                    TagChip(title: goal.title, icon: goal.symbol, tint: goal.tint)
                                }
                            }
                        }
                    }

                    if !symptoms.isEmpty {
                        VStack(alignment: .leading, spacing: SobrSpacing.sm) {
                            SectionHeader(title: "What I'm leaving behind")
                            ForEach(symptoms) { symptom in
                                HStack(spacing: SobrSpacing.sm) {
                                    Image(systemName: "arrow.down.right")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundStyle(SobrColor.harm)
                                    Text(symptom.title)
                                        .font(SobrFont.callout(.medium))
                                        .foregroundStyle(SobrColor.textSecondary)
                                    Spacer()
                                }
                            }
                        }
                    }

                    if goals.isEmpty && symptoms.isEmpty {
                        Text("You didn't pick any goals during setup. You can always restart onboarding from Profile to add them.")
                            .font(SobrFont.body())
                            .foregroundStyle(SobrColor.textSecondary)
                    }

                    Color.clear.frame(height: SobrSpacing.lg)
                }
                .padding(.horizontal, SobrSpacing.screenMargin)
                .padding(.top, SobrSpacing.md)
            }
        }
        .navigationTitle("My why")
        .navigationBarTitleDisplayMode(.inline)
    }
}
