import SwiftUI

/// A bottom-pinned footer (typically a primary CTA) sitting over a soft fade, so
/// scrolling content dissolves behind it instead of colliding with it. Place it
/// as the bottom layer of a `ZStack(alignment: .bottom)`.
///
/// Centralises the footer treatment that several onboarding and paywall screens
/// share, keeping their CTAs visually consistent.
struct FadingFooter<Content: View>: View {
    var fadeHeight: CGFloat = 150
    @ViewBuilder var content: Content

    var body: some View {
        content
            .padding(.horizontal, SobrSpacing.screenMargin)
            .padding(.bottom, SobrSpacing.sm)
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(colors: [.clear, SobrColor.background, SobrColor.background],
                               startPoint: .top, endPoint: .bottom)
                    .frame(height: fadeHeight)
                    .allowsHitTesting(false),
                alignment: .bottom
            )
    }
}
