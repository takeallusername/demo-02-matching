import SwiftUI

/// The Sobr wordmark. A condensed, heavy, slightly italic treatment evoking
/// forward momentum. Used on the splash, welcome and social-proof screens.
struct SobrLogo: View {
    var size: CGFloat = 28
    var color: Color = SobrColor.textPrimary

    var body: some View {
        Text("SOBR")
            .font(.system(size: size, weight: .black, design: .rounded))
            .italic()
            .tracking(2)
            .foregroundStyle(color)
            .accessibilityLabel("Sobr")
    }
}

#Preview {
    ZStack {
        SobrColor.background.ignoresSafeArea()
        SobrLogo(size: 40)
    }
}
