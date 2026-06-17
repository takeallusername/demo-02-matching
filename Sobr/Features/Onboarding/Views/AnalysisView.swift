import SwiftUI

/// "Analysis complete" — presents the user's self-assessment score against a
/// reference average using two animated bars, with a clear, prominent
/// disclaimer that this is **not** a medical diagnosis. Content scrolls and the
/// CTA is pinned, so it fits every device without overflow.
struct AnalysisView: View {
    @Environment(OnboardingViewModel.self) private var vm
    @State private var animate = false

    private var delta: Int { max(0, vm.dependenceScore - vm.averageScore) }

    var body: some View {
        ZStack(alignment: .bottom) {
            SobrScreenBackground(tint: SobrColor.harm, showStars: false)

            ScrollView(showsIndicators: false) {
                VStack(spacing: SobrSpacing.lg) {
                    BackBar { vm.back() }

                    HStack(spacing: SobrSpacing.xs) {
                        Text("Analysis complete")
                            .font(SobrFont.title(.heavy))
                            .foregroundStyle(SobrColor.textPrimary)
                            .minimumScaleFactor(0.7)
                            .lineLimit(1)
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundStyle(SobrColor.accent)
                    }

                    Text("Here's what your answers tell us.")
                        .font(SobrFont.body())
                        .foregroundStyle(SobrColor.textSecondary)
                        .multilineTextAlignment(.center)

                    comparisonCard

                    if delta > 0 {
                        Text("\(delta)% higher than the average drinker")
                            .font(SobrFont.callout(.bold))
                            .foregroundStyle(SobrColor.harm)
                            .multilineTextAlignment(.center)
                    }

                    Text("This is a self-assessment, not a medical diagnosis.")
                        .font(SobrFont.footnote())
                        .foregroundStyle(SobrColor.textTertiary)
                        .multilineTextAlignment(.center)

                    Color.clear.frame(height: SobrSpacing.scrollFooterClearance)
                }
                .padding(.horizontal, SobrSpacing.screenMargin)
                .padding(.top, SobrSpacing.xs)
            }

            FadingFooter {
                PrimaryButton(title: "Check your symptoms") { vm.advance() }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.9).delay(0.2)) { animate = true }
        }
    }

    private var comparisonCard: some View {
        VStack(spacing: SobrSpacing.md) {
            Text("Your responses suggest a meaningful reliance on alcohol.")
                .font(SobrFont.callout(.medium))
                .foregroundStyle(SobrColor.textSecondary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)

            HStack(alignment: .bottom, spacing: SobrSpacing.xl) {
                ScoreBar(label: "Your score", value: vm.dependenceScore,
                         gradient: SobrGradient.harm, animate: animate)
                ScoreBar(label: "Average", value: vm.averageScore,
                         gradient: SobrGradient.brand, animate: animate)
            }
            .frame(height: 200)
        }
        .padding(SobrSpacing.lg)
        .background(SobrColor.surface, in: RoundedRectangle(cornerRadius: SobrRadius.xl))
    }
}

/// A single labelled, animated vertical bar with its percentage on top.
private struct ScoreBar: View {
    let label: String
    let value: Int
    let gradient: LinearGradient
    let animate: Bool

    var body: some View {
        VStack(spacing: SobrSpacing.xs) {
            GeometryReader { geo in
                VStack(spacing: 0) {
                    Spacer(minLength: 0)
                    RoundedRectangle(cornerRadius: SobrRadius.sm)
                        .fill(gradient)
                        // Clamp so an extreme value can never exceed the track.
                        .frame(height: animate ? geo.size.height * CGFloat(min(value, 100)) / 100 : 0)
                        .overlay(alignment: .top) {
                            Text("\(value)%")
                                .font(SobrFont.headline(.heavy))
                                .foregroundStyle(.white)
                                .padding(.top, SobrSpacing.xs)
                                .opacity(animate ? 1 : 0)
                        }
                }
            }
            .frame(width: 70)

            Text(label)
                .font(SobrFont.footnote(.semibold))
                .foregroundStyle(SobrColor.textSecondary)
        }
    }
}
