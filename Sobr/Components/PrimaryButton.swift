import SwiftUI

/// The primary call-to-action button used throughout Sobr: a full-width,
/// gradient-filled pill with an optional trailing icon. Supports a disabled
/// state and a tappable press animation.
struct PrimaryButton: View {
    let title: String
    var icon: String? = "arrow.right"
    var gradient: LinearGradient = SobrGradient.brand
    var isEnabled: Bool = true
    let action: () -> Void

    var body: some View {
        Button {
            HapticsManager.shared.softTap(intensity: 0.8)
            action()
        } label: {
            HStack(spacing: SobrSpacing.xs) {
                Text(title)
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .bold))
                }
            }
            .font(SobrFont.headline(.bold))
            .foregroundStyle(SobrColor.textOnAccent)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(gradient)
            .clipShape(Capsule())
            .shadow(color: SobrColor.accent.opacity(isEnabled ? 0.35 : 0),
                    radius: 18, y: 8)
        }
        .buttonStyle(PressableButtonStyle())
        .opacity(isEnabled ? 1 : 0.4)
        .disabled(!isEnabled)
    }
}

/// A neutral secondary action (e.g. "Not now", "Skip test").
struct TextLinkButton: View {
    let title: String
    var color: Color = SobrColor.textSecondary
    let action: () -> Void

    var body: some View {
        Button {
            HapticsManager.shared.lightTap()
            action()
        } label: {
            Text(title)
                .font(SobrFont.callout(.semibold))
                .foregroundStyle(color)
        }
        .buttonStyle(PressableButtonStyle())
    }
}

/// Shared press feedback: a subtle scale-down while held.
struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.7),
                       value: configuration.isPressed)
    }
}
