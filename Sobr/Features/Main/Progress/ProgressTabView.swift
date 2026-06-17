import SwiftUI

/// The Progress tab: earned milestones, the science-based recovery timeline, and
/// the user's self-assessment baseline. All derived from `soberSince`.
struct ProgressTabView: View {
    @Environment(AppState.self) private var appState

    private var profile: UserProfile? { appState.profile }

    var body: some View {
        ZStack {
            SobrScreenBackground(tint: SobrColor.recovery)

            if let profile {
                let days = SobrietyClock.streakDays(since: profile.soberSince)
                let hours = Double(days) * 24

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: SobrSpacing.xl) {
                        Text("Your progress")
                            .font(SobrFont.title(.heavy))
                            .foregroundStyle(SobrColor.textPrimary)

                        milestonesSection(days: days)
                        timelineSection(soberHours: hours)
                        baselineSection(profile: profile)

                        Color.clear.frame(height: SobrSpacing.lg)
                    }
                    .padding(.horizontal, SobrSpacing.screenMargin)
                    .padding(.top, SobrSpacing.md)
                }
            }
        }
    }

    // MARK: - Sections

    private func milestonesSection(days: Int) -> some View {
        VStack(alignment: .leading, spacing: SobrSpacing.md) {
            SectionHeader(title: "Milestones", subtitle: "Badges you earn as the days add up")

            let columns = [GridItem(.adaptive(minimum: 80), spacing: SobrSpacing.md)]
            LazyVGrid(columns: columns, spacing: SobrSpacing.md) {
                ForEach(MilestoneContent.all) { milestone in
                    MilestoneBadge(milestone: milestone,
                                   isUnlocked: milestone.isUnlocked(streakDays: days))
                }
            }
        }
    }

    private func timelineSection(soberHours: Double) -> some View {
        VStack(alignment: .leading, spacing: SobrSpacing.md) {
            SectionHeader(title: "What's happening in your body",
                          subtitle: "A general recovery timeline after stopping")

            VStack(spacing: 0) {
                ForEach(Array(RecoveryTimeline.benefits.enumerated()), id: \.element.id) { i, benefit in
                    TimelineRow(
                        benefit: benefit,
                        isReached: RecoveryTimeline.isReached(benefit, soberHours: soberHours),
                        isLast: i == RecoveryTimeline.benefits.count - 1
                    )
                }
            }
            .padding(SobrSpacing.md)
            .background(SobrColor.surface, in: RoundedRectangle(cornerRadius: SobrRadius.lg))

            Text("General guidance only, not medical advice. Recovery varies from person to person.")
                .font(SobrFont.caption(.medium))
                .foregroundStyle(SobrColor.textTertiary)
        }
    }

    private func baselineSection(profile: UserProfile) -> some View {
        VStack(alignment: .leading, spacing: SobrSpacing.md) {
            SectionHeader(title: "Your starting point",
                          subtitle: "Your self-assessment score at sign-up")
            HStack {
                Text("\(profile.dependenceScore)")
                    .font(SobrFont.counter(.heavy))
                    .foregroundStyle(SobrColor.textPrimary)
                Text("/ 100")
                    .font(SobrFont.headline())
                    .foregroundStyle(SobrColor.textSecondary)
                Spacer()
                Image(systemName: "arrow.down.right.circle.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(SobrColor.recovery)
            }
            .padding(SobrSpacing.md)
            .background(SobrColor.surface, in: RoundedRectangle(cornerRadius: SobrRadius.lg))
        }
    }
}

private struct MilestoneBadge: View {
    let milestone: Milestone
    let isUnlocked: Bool

    var body: some View {
        VStack(spacing: SobrSpacing.xs) {
            Image(systemName: isUnlocked ? milestone.symbol : "lock.fill")
                .font(.system(size: 26))
                .foregroundStyle(isUnlocked ? SobrColor.caution : SobrColor.textTertiary)
                .frame(width: 64, height: 64)
                .background(isUnlocked ? SobrColor.caution.opacity(0.15) : SobrColor.surface, in: Circle())
            Text(milestone.title)
                .font(SobrFont.caption(.semibold))
                .foregroundStyle(isUnlocked ? SobrColor.textPrimary : SobrColor.textTertiary)
                .multilineTextAlignment(.center)
        }
    }
}

private struct TimelineRow: View {
    let benefit: RecoveryBenefit
    let isReached: Bool
    let isLast: Bool

    var body: some View {
        HStack(alignment: .top, spacing: SobrSpacing.md) {
            VStack(spacing: 0) {
                Image(systemName: isReached ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 20))
                    .foregroundStyle(isReached ? SobrColor.recovery : SobrColor.separator)
                if !isLast {
                    Rectangle()
                        .fill(isReached ? SobrColor.recovery.opacity(0.5) : SobrColor.separator)
                        .frame(width: 2)
                        .frame(maxHeight: .infinity)
                }
            }

            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(benefit.title)
                        .font(SobrFont.callout(.bold))
                        .foregroundStyle(SobrColor.textPrimary)
                    Spacer()
                    Text(benefit.timeLabel)
                        .font(SobrFont.caption(.bold))
                        .foregroundStyle(isReached ? SobrColor.recovery : SobrColor.textTertiary)
                }
                Text(benefit.detail)
                    .font(SobrFont.footnote())
                    .foregroundStyle(SobrColor.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom, isLast ? 0 : SobrSpacing.md)
            }
        }
    }
}
