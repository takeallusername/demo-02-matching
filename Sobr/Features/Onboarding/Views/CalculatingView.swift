import SwiftUI

/// The "Calculating" interstitial: a ring fills as a percentage genuinely counts
/// up from 0→100, accompanied by a "두두두" haptic burst that spins up with it,
/// while reassuring captions rotate. Auto-advances to the result on completion.
struct CalculatingView: View {
    @Environment(OnboardingViewModel.self) private var vm

    @State private var percent: Int = 0
    @State private var captionIndex = 0
    @State private var driver: Task<Void, Never>?
    @State private var hapticTask: Task<Void, Never>?

    private let totalDuration: Double = 3.0
    private let captions = [
        "Understanding your responses",
        "Comparing with screening data",
        "Mapping your triggers",
        "Building your plan"
    ]

    private var progress: Double { Double(percent) / 100 }

    var body: some View {
        ZStack {
            SobrScreenBackground(tint: SobrColor.accent, showStars: false)

            VStack(spacing: SobrSpacing.xl) {
                Spacer()

                ZStack {
                    Circle()
                        .stroke(SobrColor.separator, lineWidth: 10)
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(SobrGradient.brand,
                                style: StrokeStyle(lineWidth: 10, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .animation(.linear(duration: 0.05), value: progress)

                    Text("\(percent)%")
                        .font(SobrFont.counter(.heavy))
                        .foregroundStyle(SobrColor.textPrimary)
                        .monospacedDigit()
                        .contentTransition(.numericText())
                }
                .frame(width: 200, height: 200)

                VStack(spacing: SobrSpacing.xs) {
                    Text("Calculating")
                        .font(SobrFont.title(.bold))
                        .foregroundStyle(SobrColor.textPrimary)
                    Text(captions[captionIndex])
                        .font(SobrFont.body())
                        .foregroundStyle(SobrColor.textSecondary)
                        .transition(.opacity)
                        .id(captionIndex)
                }

                Spacer()
            }
            .padding(.horizontal, SobrSpacing.screenMargin)
        }
        .onAppear(perform: run)
        .onDisappear {
            driver?.cancel()
            hapticTask?.cancel()
        }
    }

    private func run() {
        HapticsManager.shared.prepare()
        // Haptic burst spins up alongside the fill.
        hapticTask = HapticsManager.shared.tickingBurst(count: 46, duration: totalDuration)

        driver = Task { @MainActor in
            let steps = 100
            let stepDelay = totalDuration / Double(steps)
            for value in 1...steps {
                if Task.isCancelled { return }
                withAnimation(.easeInOut(duration: stepDelay)) { percent = value }
                // Rotate caption in four phases.
                let phase = min(captions.count - 1, (value * captions.count) / 101)
                if phase != captionIndex {
                    withAnimation(.easeInOut) { captionIndex = phase }
                }
                try? await Task.sleep(nanoseconds: UInt64(stepDelay * 1_000_000_000))
            }
            if Task.isCancelled { return }
            HapticsManager.shared.success()
            try? await Task.sleep(nanoseconds: 250_000_000)
            if !Task.isCancelled { vm.advance() }
        }
    }
}
