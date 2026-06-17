import SwiftUI

/// A guided box-breathing animation: an expanding/contracting circle that cycles
/// Inhale → Hold → Exhale → Hold. Used by the urge-support flow and the Tools
/// breathing exercise. Slow diaphragmatic breathing has solid evidence for
/// calming the stress response that often drives cravings.
struct BreathingCircle: View {
    var caption: String = "Breathe"

    @State private var phaseIndex = 0
    @State private var scale: CGFloat = 0.6

    private struct Phase { let label: String; let duration: Double; let target: CGFloat }
    private let phases: [Phase] = [
        Phase(label: "Breathe in", duration: 4, target: 1.0),
        Phase(label: "Hold",       duration: 4, target: 1.0),
        Phase(label: "Breathe out",duration: 4, target: 0.6),
        Phase(label: "Hold",       duration: 4, target: 0.6)
    ]

    var body: some View {
        VStack(spacing: SobrSpacing.lg) {
            ZStack {
                Circle()
                    .fill(SobrColor.calm.opacity(0.18))
                    .frame(width: 220, height: 220)
                    .scaleEffect(scale)
                Circle()
                    .strokeBorder(SobrColor.calm.opacity(0.5), lineWidth: 2)
                    .frame(width: 220, height: 220)
                    .scaleEffect(scale)

                Text(phases[phaseIndex].label)
                    .font(SobrFont.headline(.bold))
                    .foregroundStyle(SobrColor.textPrimary)
            }
            .frame(width: 240, height: 240)

            Text(caption)
                .font(SobrFont.callout())
                .foregroundStyle(SobrColor.textSecondary)
        }
        .onAppear { runPhase() }
    }

    private func runPhase() {
        let phase = phases[phaseIndex]
        withAnimation(.easeInOut(duration: phase.duration)) {
            scale = phase.target
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + phase.duration) {
            phaseIndex = (phaseIndex + 1) % phases.count
            runPhase()
        }
    }
}
