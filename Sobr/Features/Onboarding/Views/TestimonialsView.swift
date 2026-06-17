import SwiftUI

/// "Rewiring benefits" — a scrollable list of anonymous, paraphrased
/// experiences. Sobr intentionally avoids fabricated named-expert endorsements.
struct TestimonialsView: View {
    @Environment(OnboardingViewModel.self) private var vm

    var body: some View {
        ZStack(alignment: .bottom) {
            SobrScreenBackground(tint: SobrColor.accent, showStars: false)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: SobrSpacing.lg) {
                    BackBar { vm.back() }

                    VStack(spacing: SobrSpacing.xs) {
                        Text("The other side")
                            .font(SobrFont.title(.heavy))
                            .foregroundStyle(SobrColor.textPrimary)
                        Text("Real, anonymous experiences from people who stopped.")
                            .font(SobrFont.callout())
                            .foregroundStyle(SobrColor.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)

                    ForEach(TestimonialContent.all) { testimonial in
                        TestimonialCard(testimonial: testimonial)
                    }

                    Color.clear.frame(height: SobrSpacing.scrollFooterClearance)
                }
                .padding(.horizontal, SobrSpacing.screenMargin)
                .padding(.top, SobrSpacing.xs)
            }

            FadingFooter {
                PrimaryButton(title: "Continue") { vm.advance() }
            }
        }
    }
}

private struct TestimonialCard: View {
    let testimonial: Testimonial

    var body: some View {
        VStack(alignment: .leading, spacing: SobrSpacing.sm) {
            HStack(spacing: SobrSpacing.sm) {
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 30))
                    .foregroundStyle(SobrColor.accent)
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(SobrColor.accent)
                Spacer()
                StarRow(size: 10)
            }

            Text("\u{201C}\(testimonial.quote)\u{201D}")
                .font(SobrFont.body(.medium))
                .foregroundStyle(SobrColor.textPrimary)
                .fixedSize(horizontal: false, vertical: true)

            Text(testimonial.attribution)
                .font(SobrFont.footnote())
                .foregroundStyle(SobrColor.textTertiary)
        }
        .padding(SobrSpacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(SobrColor.surface, in: RoundedRectangle(cornerRadius: SobrRadius.lg))
    }
}
