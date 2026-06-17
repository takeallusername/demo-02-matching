import SwiftUI

/// A once-a-day commitment card. Daily pledges are a simple, evidence-aligned
/// commitment device. The pledge state is stored locally and resets each day.
struct DailyPledgeCard: View {
    @AppStorage("sobr.lastPledgeDay") private var lastPledgeDay: String = ""

    private var todayKey: String {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: .now)
    }

    private var hasPledgedToday: Bool { lastPledgeDay == todayKey }

    var body: some View {
        VStack(alignment: .leading, spacing: SobrSpacing.sm) {
            HStack(spacing: SobrSpacing.xs) {
                Image(systemName: hasPledgedToday ? "hand.raised.fill" : "hand.raised")
                    .foregroundStyle(SobrColor.accent)
                Text("Today's pledge")
                    .font(SobrFont.body(.bold))
                    .foregroundStyle(SobrColor.textPrimary)
                Spacer()
            }

            Text(hasPledgedToday
                 ? "You've committed to staying alcohol-free today. Keep going."
                 : "\u{201C}Just for today, I will not drink.\u{201D}")
                .font(SobrFont.callout())
                .foregroundStyle(SobrColor.textSecondary)
                .fixedSize(horizontal: false, vertical: true)

            if hasPledgedToday {
                Label("Pledged for today", systemImage: "checkmark.circle.fill")
                    .font(SobrFont.callout(.bold))
                    .foregroundStyle(SobrColor.recovery)
                    .padding(.top, SobrSpacing.xxs)
            } else {
                Button {
                    withAnimation(.spring(response: 0.3)) { lastPledgeDay = todayKey }
                } label: {
                    Text("I pledge")
                        .font(SobrFont.callout(.bold))
                        .foregroundStyle(SobrColor.textOnAccent)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, SobrSpacing.sm)
                        .background(SobrGradient.brand, in: Capsule())
                }
                .buttonStyle(PressableButtonStyle())
            }
        }
        .padding(SobrSpacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(SobrColor.surface, in: RoundedRectangle(cornerRadius: SobrRadius.lg))
    }
}
