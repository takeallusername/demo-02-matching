import SwiftUI

/// A standalone guided breathing exercise built on the shared `BreathingCircle`.
struct BreathingExerciseView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            SobrScreenBackground(tint: SobrColor.calm, showStars: false)

            VStack(spacing: SobrSpacing.xl) {
                VStack(spacing: SobrSpacing.xs) {
                    Text("Box breathing")
                        .font(SobrFont.title(.heavy))
                        .foregroundStyle(SobrColor.textPrimary)
                    Text("Four counts in, hold, out, hold. Repeat until the wave passes.")
                        .font(SobrFont.callout())
                        .foregroundStyle(SobrColor.textSecondary)
                        .multilineTextAlignment(.center)
                }

                Spacer()
                BreathingCircle(caption: "Follow the circle for a minute or two")
                Spacer()

                PrimaryButton(title: "I feel calmer", gradient: SobrGradient.calm) {
                    dismiss()
                }
            }
            .padding(.horizontal, SobrSpacing.screenMargin)
            .padding(.bottom, SobrSpacing.sm)
        }
        .navigationTitle("Breathing")
        .navigationBarTitleDisplayMode(.inline)
    }
}
