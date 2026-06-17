import SwiftUI

/// Sobr's signature "sobriety card" — the equivalent of the reference app's
/// iridescent membership card. It anchors the plan-reveal screens and the
/// profile, showing the member's active streak and the date they got sober.
struct SobrietyCard: View {
    var memberName: String?
    let streakDays: Int
    let soberSince: Date

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header row: monogram + member badge
            HStack {
                Text("SBR")
                    .font(.system(size: 15, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .overlay(Circle().strokeBorder(.white.opacity(0.85), lineWidth: 2))

                Spacer()

                HStack(spacing: 4) {
                    Image(systemName: "star.fill").font(.system(size: 10))
                    Text("MEMBER").font(SobrFont.caption(.bold)).tracking(1)
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(.white.opacity(0.18), in: Capsule())
            }

            Spacer(minLength: SobrSpacing.xl)

            Text("ACTIVE STREAK")
                .font(SobrFont.caption(.bold))
                .tracking(1.5)
                .foregroundStyle(.white.opacity(0.85))

            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text("\(streakDays)")
                    .font(.system(size: 52, weight: .heavy, design: .rounded))
                Text(streakDays == 1 ? "day" : "days")
                    .font(SobrFont.headline(.semibold))
                    .foregroundStyle(.white.opacity(0.9))
            }
            .foregroundStyle(.white)

            Spacer(minLength: SobrSpacing.lg)

            HStack {
                if let memberName, !memberName.isEmpty {
                    Text(memberName.uppercased())
                        .font(SobrFont.footnote(.bold))
                        .tracking(1)
                        .foregroundStyle(.white.opacity(0.9))
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
                Spacer(minLength: SobrSpacing.sm)
                VStack(alignment: .trailing, spacing: 2) {
                    Text("SOBER SINCE")
                        .font(SobrFont.caption(.bold))
                        .foregroundStyle(.white.opacity(0.7))
                    Text(soberSince, format: .dateTime.day().month().year())
                        .font(SobrFont.callout(.bold))
                        .foregroundStyle(.white)
                }
            }
        }
        .padding(SobrSpacing.lg)
        .frame(height: 260)
        .background(SobrGradient.auroraCard)
        .clipShape(RoundedRectangle(cornerRadius: SobrRadius.xl))
        .overlay(
            RoundedRectangle(cornerRadius: SobrRadius.xl)
                .strokeBorder(.white.opacity(0.12), lineWidth: 1)
        )
        .shadow(color: SobrColor.accent.opacity(0.25), radius: 30, y: 14)
    }
}

#Preview {
    ZStack {
        SobrColor.background.ignoresSafeArea()
        SobrietyCard(memberName: "Kwon", streakDays: 0, soberSince: .now)
            .padding()
    }
}
