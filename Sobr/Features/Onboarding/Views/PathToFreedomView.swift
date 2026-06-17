import SwiftUI

/// "Your path to freedom" — a simple two-line chart contrasting a steady upward
/// recovery curve (with Sobr) against a declining one (without), plus a social
/// proof line. Scrolls with a pinned CTA so it never overflows; the chart is
/// drawn in normalised coordinates so it can never exceed its frame.
struct PathToFreedomView: View {
    @Environment(OnboardingViewModel.self) private var vm
    @State private var animate = false

    // Normalised sample curves (0...1), purely illustrative.
    private let withSobr: [CGFloat]    = [0.30, 0.42, 0.50, 0.62, 0.70, 0.82, 0.90, 0.98]
    private let withoutSobr: [CGFloat] = [0.32, 0.40, 0.30, 0.34, 0.26, 0.30, 0.22, 0.16]

    var body: some View {
        ZStack(alignment: .bottom) {
            SobrScreenBackground(tint: SobrColor.recovery, showStars: false)

            ScrollView(showsIndicators: false) {
                VStack(spacing: SobrSpacing.lg) {
                    BackBar { vm.back() }

                    VStack(spacing: SobrSpacing.xs) {
                        Text("Your path to freedom")
                            .font(SobrFont.title(.heavy))
                            .foregroundStyle(SobrColor.textPrimary)
                            .minimumScaleFactor(0.7)
                            .lineLimit(1)
                        Text("With Sobr, recovery compounds.")
                            .font(SobrFont.body())
                            .foregroundStyle(SobrColor.textSecondary)
                    }

                    chart
                        .frame(height: 200)
                        .padding(SobrSpacing.md)
                        .background(SobrColor.surface, in: RoundedRectangle(cornerRadius: SobrRadius.lg))

                    legend

                    VStack(spacing: 4) {
                        Text("Recovery is the rule, not the exception.")
                            .font(SobrFont.callout(.semibold))
                            .foregroundStyle(SobrColor.textPrimary)
                            .multilineTextAlignment(.center)
                        Text("Most people who set out to cut down improve over time.")
                            .font(SobrFont.footnote())
                            .foregroundStyle(SobrColor.textSecondary)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    Color.clear.frame(height: SobrSpacing.scrollFooterClearance)
                }
                .padding(.horizontal, SobrSpacing.screenMargin)
                .padding(.top, SobrSpacing.xs)
            }

            FadingFooter {
                PrimaryButton(title: "Continue", gradient: SobrGradient.recovery) { vm.advance() }
            }
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

    /// Builds a polyline through the normalised points, inset slightly so the
    /// stroke width never clips at the top/bottom edges.
    private func curve(points: [CGFloat], in size: CGSize) -> Path {
        Path { path in
            guard points.count > 1 else { return }
            let inset: CGFloat = 6
            let usableHeight = max(0, size.height - inset * 2)
            let stepX = size.width / CGFloat(points.count - 1)
            func point(_ i: Int) -> CGPoint {
                CGPoint(x: CGFloat(i) * stepX,
                        y: inset + usableHeight * (1 - points[i]))
            }
            path.move(to: point(0))
            for i in 1..<points.count { path.addLine(to: point(i)) }
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
