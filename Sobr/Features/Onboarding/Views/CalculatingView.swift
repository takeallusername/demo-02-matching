import SwiftUI

/// The "Calculating" interstitial: an animated ring fills from 0→100% while a
/// rotating set of reassuring captions plays, then auto-advances to the result.
struct CalculatingView: View {
    @Environment(OnboardingViewModel.self) private var vm

    @State private var progress: Double = 0
    @State private var captionIndex = 0

    private let captions = [
        "Understanding your responses",
        "Comparing with screening data",
        "Mapping your triggers",
        "Building your plan"
    ]

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

                    Text("\(Int(progress * 100))%")
                        .font(SobrFont.counter(.heavy))
                        .foregroundStyle(SobrColor.textPrimary)
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
        .onAppear(perform: runAnimation)
    }

    private func runAnimation() {
        withAnimation(.easeInOut(duration: 2.8)) { progress = 1 }

        // Rotate captions in step with the fill.
        for i in captions.indices {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.7) {
                withAnimation(.easeInOut) { captionIndex = min(i, captions.count - 1) }
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.1) {
            vm.advance()
        }
    }
}
