import SwiftUI

/// The thin animated progress bar shown at the top of the quiz, paired with a
/// back button and a static locale pill — mirroring the reference onboarding.
struct OnboardingProgressBar: View {
    /// Progress in 0...1.
    let progress: Double
    var onBack: (() -> Void)?

    var body: some View {
        HStack(spacing: SobrSpacing.md) {
            if let onBack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(SobrColor.textPrimary)
                        .frame(width: 40, height: 40)
                        .background(SobrColor.surface, in: Circle())
                }
                .buttonStyle(PressableButtonStyle())
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(SobrColor.separator)
                    Capsule()
                        .fill(SobrGradient.brand)
                        .frame(width: max(8, geo.size.width * progress))
                }
            }
            .frame(height: 8)

            LocalePill()
        }
    }
}

/// A small static "EN" locale pill. Decorative — matches the reference UI.
private struct LocalePill: View {
    var body: some View {
        HStack(spacing: 4) {
            Text("🇺🇸")
            Text("EN").font(SobrFont.caption(.bold))
        }
        .foregroundStyle(SobrColor.textSecondary)
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(SobrColor.surface, in: Capsule())
    }
}
