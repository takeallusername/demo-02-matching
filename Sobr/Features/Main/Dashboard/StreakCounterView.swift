import SwiftUI

/// The live sobriety counter. Uses `TimelineView` to tick every second, showing
/// the headline day count plus a calm H/M/S breakdown — entirely derived from
/// the user's `soberSince` date via `SobrietyClock`.
struct StreakCounterView: View {
    let soberSince: Date

    var body: some View {
        TimelineView(.periodic(from: .now, by: 1)) { context in
            let elapsed = SobrietyClock.elapsed(since: soberSince, now: context.date)

            VStack(spacing: SobrSpacing.xs) {
                Text("YOU'VE BEEN ALCOHOL-FREE FOR")
                    .font(SobrFont.caption(.bold)).tracking(1.5)
                    .foregroundStyle(SobrColor.textSecondary)

                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text("\(elapsed.days)")
                        .font(SobrFont.counter(.heavy))
                        .foregroundStyle(SobrColor.textPrimary)
                        .contentTransition(.numericText())
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    Text(elapsed.days == 1 ? "day" : "days")
                        .font(SobrFont.title(.semibold))
                        .foregroundStyle(SobrColor.textSecondary)
                }

                HStack(spacing: SobrSpacing.md) {
                    timeUnit(elapsed.hours, "hrs")
                    timeUnit(elapsed.minutes, "min")
                    timeUnit(elapsed.seconds, "sec")
                }
            }
        }
    }

    private func timeUnit(_ value: Int, _ label: String) -> some View {
        VStack(spacing: 2) {
            Text(String(format: "%02d", value))
                .font(SobrFont.headline(.bold))
                .foregroundStyle(SobrColor.textPrimary)
                .monospacedDigit()
            Text(label)
                .font(SobrFont.caption(.medium))
                .foregroundStyle(SobrColor.textTertiary)
        }
        .frame(minWidth: 44)
        .padding(.vertical, SobrSpacing.xs)
        .padding(.horizontal, SobrSpacing.sm)
        .background(SobrColor.surface, in: RoundedRectangle(cornerRadius: SobrRadius.sm))
    }
}
