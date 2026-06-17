import SwiftUI

/// A reusable swipeable education carousel. Each slide carries its own accent,
/// so the background, progress dashes and illustration recolor per beat. Used
/// for both the "Understanding alcohol" and "Welcome to Sobr" sections.
struct EducationCarouselView: View {
    @Environment(OnboardingViewModel.self) private var vm
    let slides: [EducationSlide]
    let title: String
    let onFinish: () -> Void

    @State private var index = 0

    private var current: EducationSlide { slides[index] }
    private var isLast: Bool { index == slides.count - 1 }

    var body: some View {
        ZStack {
            SobrScreenBackground(tint: current.accent, showStars: false)
                .animation(.easeInOut(duration: 0.4), value: index)

            VStack(spacing: SobrSpacing.lg) {
                HStack(spacing: SobrSpacing.md) {
                    backControl
                    SegmentedProgress(count: slides.count, current: index, tint: current.accent)
                }
                .padding(.top, SobrSpacing.xs)

                Spacer()

                IllustrationBadge(symbol: current.symbol, accent: current.accent)
                    .id(current.id)
                    .transition(.scale.combined(with: .opacity))

                VStack(spacing: SobrSpacing.md) {
                    Text(current.title)
                        .font(SobrFont.hero())
                        .foregroundStyle(SobrColor.textPrimary)
                        .multilineTextAlignment(.center)

                    Text(current.body)
                        .font(SobrFont.body())
                        .foregroundStyle(SobrColor.textSecondary)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .id(current.id)
                .transition(.opacity)
                .padding(.horizontal, SobrSpacing.xs)

                Spacer()

                ProgressDots(count: slides.count, current: index)

                PrimaryButton(title: isLast ? "Continue" : "Next",
                              gradient: SobrGradient.forAccent(current.accent)) {
                    next()
                }
            }
            .padding(.horizontal, SobrSpacing.screenMargin)
            .padding(.bottom, SobrSpacing.sm)
        }
        // Allow swiping between slides as well as tapping Next.
        .gesture(
            DragGesture(minimumDistance: 30)
                .onEnded { value in
                    if value.translation.width < 0 { next() }
                    else if value.translation.width > 0 { previous() }
                }
        )
    }

    @ViewBuilder private var backControl: some View {
        Button {
            previous()
        } label: {
            Image(systemName: "chevron.left")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(SobrColor.textPrimary)
                .frame(width: 40, height: 40)
                .background(SobrColor.surface, in: Circle())
        }
        .buttonStyle(PressableButtonStyle())
    }

    private func next() {
        if isLast {
            onFinish()
        } else {
            withAnimation(.easeInOut(duration: 0.35)) { index += 1 }
        }
    }

    private func previous() {
        if index == 0 {
            vm.back()
        } else {
            withAnimation(.easeInOut(duration: 0.35)) { index -= 1 }
        }
    }
}

/// The circular illustration badge at the top of each education slide.
private struct IllustrationBadge: View {
    let symbol: String
    let accent: Color

    var body: some View {
        ZStack {
            Circle()
                .fill(accent.opacity(0.16))
                .frame(width: 180, height: 180)
            Circle()
                .strokeBorder(accent.opacity(0.4), lineWidth: 1)
                .frame(width: 180, height: 180)
            Image(systemName: symbol)
                .font(.system(size: 72, weight: .semibold))
                .foregroundStyle(accent)
        }
        .shadow(color: accent.opacity(0.4), radius: 30)
    }
}
