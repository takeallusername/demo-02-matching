import SwiftUI

/// Shows the next milestone the user is working toward, with a progress bar
/// spanning from the previous milestone to the next.
struct NextMilestoneCard: View {
    let streakDays: Int

    private var next: Milestone? { MilestoneContent.next(after: streakDays) }

    /// Progress from the previously-earned threshold to the next one (0...1).
    private var progress: Double {
        guard let next else { return 1 }
        let previous = MilestoneContent.all
            .last { $0.dayThreshold <= streakDays }?.dayThreshold ?? 0
        let span = Double(next.dayThreshold - previous)
        guard span > 0 else { return 1 }
        return min(1, max(0, Double(streakDays - previous) / span))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: SobrSpacing.sm) {
            if let next {
                HStack {
                    Image(systemName: next.symbol).foregroundStyle(SobrColor.caution)
                    Text("Next: \(next.title)")
                        .font(SobrFont.body(.bold))
                        .foregroundStyle(SobrColor.textPrimary)
                    Spacer()
                    Text("\(max(0, next.dayThreshold - streakDays)) days to go")
                        .font(SobrFont.footnote(.semibold))
                        .foregroundStyle(SobrColor.textSecondary)
                }

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule().fill(SobrColor.separator)
                        Capsule().fill(SobrGradient.brand)
                            .frame(width: max(6, geo.size.width * progress))
                    }
                }
                .frame(height: 8)
            } else {
                HStack {
                    Image(systemName: "trophy.fill").foregroundStyle(SobrColor.caution)
                    Text("Every milestone unlocked. Incredible.")
                        .font(SobrFont.body(.bold))
                        .foregroundStyle(SobrColor.textPrimary)
                }
            }
        }
        .padding(SobrSpacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(SobrColor.surface, in: RoundedRectangle(cornerRadius: SobrRadius.lg))
    }
}
