import SwiftUI

/// Sobr's answer to the "panic button" — a calm, supportive urge-support flow
/// grounded in *urge surfing* and slow breathing, both evidence-based craving
/// tools. Deliberately compassionate rather than shaming: cravings are framed
/// as waves that rise and pass, not as personal failures.
struct UrgeSupportView: View {
    @Environment(\.dismiss) private var dismiss
    let reasons: [Goal]

    @State private var step: Step = .breathe

    enum Step { case breathe, ride, reasons, done }

    var body: some View {
        ZStack {
            SobrScreenBackground(tint: SobrColor.calm, showStars: false)

            VStack(spacing: SobrSpacing.xl) {
                header

                Spacer()

                switch step {
                case .breathe: BreathingCircle(caption: "Breathe with the circle")
                case .ride:    rideTheWave
                case .reasons: reasonsReminder
                case .done:    doneState
                }

                Spacer()

                PrimaryButton(title: primaryTitle,
                              gradient: SobrGradient.calm) { advance() }
                    .padding(.bottom, SobrSpacing.sm)
            }
            .padding(.horizontal, SobrSpacing.screenMargin)
        }
    }

    private var header: some View {
        HStack {
            Text("Riding the urge")
                .font(SobrFont.headline(.bold))
                .foregroundStyle(SobrColor.textPrimary)
            Spacer()
            Button { dismiss() } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(SobrColor.textSecondary)
                    .frame(width: 36, height: 36)
                    .background(SobrColor.surface, in: Circle())
            }
        }
        .padding(.top, SobrSpacing.md)
    }

    private var rideTheWave: some View {
        VStack(spacing: SobrSpacing.md) {
            Image(systemName: "water.waves")
                .font(.system(size: 64))
                .foregroundStyle(SobrColor.calm)
            Text("This urge is a wave")
                .font(SobrFont.hero())
                .foregroundStyle(SobrColor.textPrimary)
            Text("It rises, peaks, and passes \u{2014} usually within minutes. You don't have to fight it. Just notice it and let it roll by.")
                .font(SobrFont.body())
                .foregroundStyle(SobrColor.textSecondary)
                .multilineTextAlignment(.center)
        }
    }

    private var reasonsReminder: some View {
        VStack(spacing: SobrSpacing.md) {
            Text("Remember why")
                .font(SobrFont.hero())
                .foregroundStyle(SobrColor.textPrimary)
            if reasons.isEmpty {
                Text("You started this for a reason. That reason still matters.")
                    .font(SobrFont.body())
                    .foregroundStyle(SobrColor.textSecondary)
                    .multilineTextAlignment(.center)
            } else {
                FlowLayout(spacing: SobrSpacing.xs) {
                    ForEach(reasons) { goal in
                        TagChip(title: goal.title, icon: goal.symbol, tint: goal.tint)
                    }
                }
            }
        }
    }

    private var doneState: some View {
        VStack(spacing: SobrSpacing.md) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(SobrColor.recovery)
            Text("You rode it out")
                .font(SobrFont.hero())
                .foregroundStyle(SobrColor.textPrimary)
            Text("That's exactly how the brain unlearns a habit \u{2014} one urge survived at a time. Be proud of this.")
                .font(SobrFont.body())
                .foregroundStyle(SobrColor.textSecondary)
                .multilineTextAlignment(.center)
        }
    }

    private var primaryTitle: String {
        switch step {
        case .breathe: return "I've steadied my breathing"
        case .ride:    return "I can let it pass"
        case .reasons: return "I'm staying on track"
        case .done:    return "Done"
        }
    }

    private func advance() {
        switch step {
        case .breathe: withAnimation { step = .ride }
        case .ride:    withAnimation { step = .reasons }
        case .reasons: withAnimation { step = .done }
        case .done:    dismiss()
        }
    }
}
