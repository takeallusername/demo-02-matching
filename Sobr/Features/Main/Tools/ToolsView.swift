import SwiftUI

/// The Tools tab: a grid of self-guided, evidence-aligned tools. No AI coach and
/// no community — every tool here works privately and offline.
struct ToolsView: View {
    @Environment(AppState.self) private var appState
    @State private var showingUrge = false

    var body: some View {
        NavigationStack {
            ZStack {
                SobrScreenBackground(tint: SobrColor.accent)

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: SobrSpacing.lg) {
                        Text("Tools")
                            .font(SobrFont.title(.heavy))
                            .foregroundStyle(SobrColor.textPrimary)
                        Text("Calm the moment, understand the habit, remember your why.")
                            .font(SobrFont.callout())
                            .foregroundStyle(SobrColor.textSecondary)

                        let columns = [GridItem(.flexible(), spacing: SobrSpacing.md),
                                       GridItem(.flexible(), spacing: SobrSpacing.md)]
                        LazyVGrid(columns: columns, spacing: SobrSpacing.md) {
                            NavigationLink {
                                BreathingExerciseView()
                            } label: {
                                ToolTile(title: "Breathing", subtitle: "Calm the craving",
                                         symbol: "wind", tint: SobrColor.calm)
                            }

                            Button { showingUrge = true } label: {
                                ToolTile(title: "Ride an urge", subtitle: "2-minute reset",
                                         symbol: "water.waves", tint: SobrColor.accentSecondary)
                            }

                            NavigationLink {
                                LearnView()
                            } label: {
                                ToolTile(title: "Learn", subtitle: "Why alcohol grips",
                                         symbol: "book.fill", tint: SobrColor.caution)
                            }

                            NavigationLink {
                                MyWhyView()
                            } label: {
                                ToolTile(title: "My why", subtitle: "Your reasons",
                                         symbol: "heart.text.square.fill", tint: SobrColor.harm)
                            }
                        }
                        .buttonStyle(.plain)

                        DisclaimerCard()

                        Color.clear.frame(height: SobrSpacing.lg)
                    }
                    .padding(.horizontal, SobrSpacing.screenMargin)
                    .padding(.top, SobrSpacing.md)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
        }
        .fullScreenCover(isPresented: $showingUrge) {
            UrgeSupportView(reasons: selectedGoals)
        }
    }

    private var selectedGoals: [Goal] {
        guard let ids = appState.profile?.selectedGoalIDs else { return [] }
        return GoalContent.all.filter { ids.contains($0.id) }
    }
}

/// A single tool tile in the grid.
private struct ToolTile: View {
    let title: String
    let subtitle: String
    let symbol: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: SobrSpacing.sm) {
            Image(systemName: symbol)
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(tint)
                .frame(width: 48, height: 48)
                .background(tint.opacity(0.16), in: RoundedRectangle(cornerRadius: SobrRadius.md))

            Text(title)
                .font(SobrFont.body(.bold))
                .foregroundStyle(SobrColor.textPrimary)
            Text(subtitle)
                .font(SobrFont.footnote())
                .foregroundStyle(SobrColor.textSecondary)
        }
        .frame(maxWidth: .infinity, minHeight: 140, alignment: .topLeading)
        .padding(SobrSpacing.md)
        .background(SobrColor.surface, in: RoundedRectangle(cornerRadius: SobrRadius.lg))
    }
}

/// A persistent safety note about alcohol withdrawal — important and ethical to
/// surface in a sobriety app.
struct DisclaimerCard: View {
    var body: some View {
        HStack(alignment: .top, spacing: SobrSpacing.sm) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(SobrColor.caution)
            VStack(alignment: .leading, spacing: 4) {
                Text("A note on safety")
                    .font(SobrFont.callout(.bold))
                    .foregroundStyle(SobrColor.textPrimary)
                Text("If you drink heavily every day, stopping suddenly can be dangerous. Please talk to a doctor before quitting. Sobr is a supportive tool, not medical treatment.")
                    .font(SobrFont.footnote())
                    .foregroundStyle(SobrColor.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(SobrSpacing.md)
        .background(SobrColor.caution.opacity(0.12), in: RoundedRectangle(cornerRadius: SobrRadius.md))
        .overlay(RoundedRectangle(cornerRadius: SobrRadius.md)
            .strokeBorder(SobrColor.caution.opacity(0.3), lineWidth: 1))
    }
}
