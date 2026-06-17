import SwiftUI

/// The home screen: a live sobriety counter, the growth metaphor, the urge
/// support entry point, a daily pledge and the next milestone. Reads everything
/// from the single `AppState` profile.
struct DashboardView: View {
    @Environment(AppState.self) private var appState
    @State private var showingUrgeSupport = false

    private var profile: UserProfile? { appState.profile }

    var body: some View {
        ZStack {
            SobrScreenBackground(tint: SobrColor.accent)

            if let profile {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: SobrSpacing.lg) {
                        greeting(name: profile.name)

                        StreakCounterView(soberSince: profile.soberSince)
                            .padding(.top, SobrSpacing.xs)

                        GrowingPlantView(streakDays: streakDays(profile))

                        urgeButton

                        DailyPledgeCard()

                        NextMilestoneCard(streakDays: streakDays(profile))

                        statTiles(profile)

                        Color.clear.frame(height: SobrSpacing.lg)
                    }
                    .padding(.horizontal, SobrSpacing.screenMargin)
                    .padding(.top, SobrSpacing.md)
                }
            }
        }
        .fullScreenCover(isPresented: $showingUrgeSupport) {
            UrgeSupportView(reasons: selectedGoals(profile))
        }
    }

    // MARK: - Pieces

    private func greeting(name: String) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(name.isEmpty ? "Welcome back" : "Hi, \(name)")
                    .font(SobrFont.title(.heavy))
                    .foregroundStyle(SobrColor.textPrimary)
                Text("One day at a time.")
                    .font(SobrFont.callout())
                    .foregroundStyle(SobrColor.textSecondary)
            }
            Spacer()
            SobrLogo(size: 18)
        }
    }

    private var urgeButton: some View {
        Button { showingUrgeSupport = true } label: {
            HStack(spacing: SobrSpacing.sm) {
                Image(systemName: "lifepreserver.fill")
                    .font(.system(size: 20, weight: .bold))
                VStack(alignment: .leading, spacing: 2) {
                    Text("I'm having an urge")
                        .font(SobrFont.body(.bold))
                    Text("Ride it out with a 2-minute reset")
                        .font(SobrFont.footnote())
                        .foregroundStyle(.white.opacity(0.85))
                }
                Spacer()
                Image(systemName: "chevron.right").font(.system(size: 14, weight: .bold))
            }
            .foregroundStyle(.white)
            .padding(SobrSpacing.md)
            .background(SobrGradient.calm, in: RoundedRectangle(cornerRadius: SobrRadius.lg))
            .shadow(color: SobrColor.calm.opacity(0.4), radius: 16, y: 6)
        }
        .buttonStyle(PressableButtonStyle())
    }

    private func statTiles(_ profile: UserProfile) -> some View {
        let days = streakDays(profile)
        let saved = Double(days) * profile.estimatedDailySpend
        return HStack(spacing: SobrSpacing.sm) {
            StatTile(value: "\(days)", label: "Days sober", symbol: "calendar")
            StatTile(value: moneyString(saved), label: "Money saved", symbol: "banknote.fill")
        }
    }

    // MARK: - Helpers

    private func streakDays(_ profile: UserProfile) -> Int {
        SobrietyClock.streakDays(since: profile.soberSince)
    }

    private func selectedGoals(_ profile: UserProfile?) -> [Goal] {
        guard let ids = profile?.selectedGoalIDs else { return [] }
        return GoalContent.all.filter { ids.contains($0.id) }
    }

    private func moneyString(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: amount)) ?? "$\(Int(amount))"
    }
}

/// A compact stat tile used on the dashboard.
struct StatTile: View {
    let value: String
    let label: String
    let symbol: String

    var body: some View {
        VStack(alignment: .leading, spacing: SobrSpacing.xs) {
            Image(systemName: symbol)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(SobrColor.accent)
            Text(value)
                .font(SobrFont.title(.heavy))
                .foregroundStyle(SobrColor.textPrimary)
            Text(label)
                .font(SobrFont.footnote())
                .foregroundStyle(SobrColor.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(SobrSpacing.md)
        .background(SobrColor.surface, in: RoundedRectangle(cornerRadius: SobrRadius.lg))
    }
}
