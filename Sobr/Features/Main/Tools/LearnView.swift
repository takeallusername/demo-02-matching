import SwiftUI

/// A small "learn" library that reuses the onboarding education content as a
/// browsable list — reinforcing the science whenever the user wants a reminder.
struct LearnView: View {
    private let lessons = EducationContent.understandingAlcohol
                        + EducationContent.welcomeToSobr

    var body: some View {
        ZStack {
            SobrScreenBackground(tint: SobrColor.caution)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: SobrSpacing.md) {
                    Text("Understanding the habit")
                        .font(SobrFont.title(.heavy))
                        .foregroundStyle(SobrColor.textPrimary)
                        .padding(.bottom, SobrSpacing.xs)

                    ForEach(lessons) { lesson in
                        LessonRow(slide: lesson)
                    }

                    Text("Information is paraphrased from public NHS, NIAAA, CDC and WHO materials and is for education only.")
                        .font(SobrFont.caption(.medium))
                        .foregroundStyle(SobrColor.textTertiary)
                        .padding(.top, SobrSpacing.xs)

                    Color.clear.frame(height: SobrSpacing.lg)
                }
                .padding(.horizontal, SobrSpacing.screenMargin)
                .padding(.top, SobrSpacing.md)
            }
        }
        .navigationTitle("Learn")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct LessonRow: View {
    let slide: EducationSlide
    @State private var expanded = false

    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.25)) { expanded.toggle() }
        } label: {
            VStack(alignment: .leading, spacing: SobrSpacing.xs) {
                HStack(spacing: SobrSpacing.sm) {
                    Image(systemName: slide.symbol)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(slide.accent)
                        .frame(width: 40, height: 40)
                        .background(slide.accent.opacity(0.16), in: RoundedRectangle(cornerRadius: SobrRadius.sm))
                    Text(slide.title)
                        .font(SobrFont.body(.bold))
                        .foregroundStyle(SobrColor.textPrimary)
                        .multilineTextAlignment(.leading)
                    Spacer()
                    Image(systemName: expanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(SobrColor.textTertiary)
                }
                if expanded {
                    Text(slide.body)
                        .font(SobrFont.callout())
                        .foregroundStyle(SobrColor.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.leading, 52)
                }
            }
            .padding(SobrSpacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(SobrColor.surface, in: RoundedRectangle(cornerRadius: SobrRadius.lg))
        }
        .buttonStyle(PressableButtonStyle())
    }
}
