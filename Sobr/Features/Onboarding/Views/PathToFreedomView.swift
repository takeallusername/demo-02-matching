import SwiftUI

/// "Your path to freedom" — a simple two-line chart contrasting a steady upward
/// recovery curve (with Sobr) against a declining one (without), plus a social
/// proof figure. The chart is drawn with `Path` for full visual control.
struct PathToFreedomView: View {
    @Environment(OnboardingViewModel.self) private var vm
    @State private var animate = false

    // Normalised sample curves (0...1), purely illustrative.
    private let withSobr: [CGFloat]    = [0.30, 0.42, 0.50, 0.62, 0.70, 0.82, 0.90, 0.98]
    private let withoutSobr: [CGFloat] = [0.32, 0.40, 0.30, 0.34, 0.26, 0.30, 0.22, 0.16]

    var body: some View {
        ZStack {
            SobrScreenBackground(tint: SobrColor.recovery, showStars: false)

            VStack(spacing: SobrSpacing.lg) {
                BackBar { vm.back() }

                VStack(spacing: SobrSpacing.xs) {
                    Text("Your path to freedom")
                        .font(SobrFont.title(.heavy))
                        .foregroundStyle(SobrColor.textPrimary)
                    Text("With Sobr, recovery compounds.")
                        .font(SobrFont.body())
                        .foregroundStyle(SobrColor.textSecondary)
                }

                chart
                    .frame(height: 220)
                    .padding(.vertical, SobrSpacing.md)

                legend

                VStack(spacing: 2) {
                    Text("Recovery is the rule, not the exception.")
                        .font(SobrFont.callout(.semibold))
                        .foregroundStyle(SobrColor.textPrimary)
                    Text("Most people who set out to cut down improve over time.")
                        .font(SobrFont.footnote())
                        .foregroundStyle(SobrColor.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, SobrSpacing.xs)

                Spacer()

                PrimaryButton(title: "Continue",
                              gradient: SobrGradient.recovery) { vm.advance() }
                    .padding(.bottom, SobrSpacing.sm)
            }
            .padding(.horizontal, SobrSpacing.screenMargin)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.1).delay(0.2)) { animate = true }
        }
    }

    private var chart: some View {
        GeometryReader { geo in
            ZStack {
                curve(points: withoutSobr, in: geo.size)
                    .trim(from: 0, to: animate ? 1 : 0)
                    .stroke(SobrColor.harm.opacity(0.8),
                            style: StrokeStyle(lineWidth: 3, lineCap: .round, dash: [2, 6]))

                curve(points: withSobr, in: geo.size)
                    .trim(from: 0, to: animate ? 1 : 0)
                    .stroke(SobrGradient.recovery,
                            style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .shadow(color: SobrColor.recovery.opacity(0.6), radius: 8)
            }
        }
    }

    /// Builds a smooth-ish polyline through the normalised points.
    private func curve(points: [CGFloat], in size: CGSize) -> Path {
        Path { path in
            guard points.count > 1 else { return }
            let stepX = size.width / CGFloat(points.count - 1)
            func point(_ i: Int) -> CGPoint {
                CGPoint(x: CGFloat(i) * stepX,
                        y: size.height * (1 - points[i]))
            }
            path.move(to: point(0))
            for i in 1..<points.count {
                path.addLine(to: point(i))
            }
        }
    }

    private var legend: some View {
        HStack(spacing: SobrSpacing.lg) {
            LegendDot(color: SobrColor.recovery, label: "With Sobr")
            LegendDot(color: SobrColor.harm, label: "Without")
        }
    }

    private struct LegendDot: View {
        let color: Color
        let label: String
        var body: some View {
            HStack(spacing: 6) {
                Circle().fill(color).frame(width: 8, height: 8)
                Text(label)
                    .font(SobrFont.footnote(.semibold))
                    .foregroundStyle(SobrColor.textSecondary)
            }
        }
    }
}
