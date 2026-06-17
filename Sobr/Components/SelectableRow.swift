import SwiftUI

/// A multi-select row used by the Symptoms and Goals screens. Optionally shows
/// a leading SF Symbol in a tinted bubble, and a trailing check when selected.
struct SelectableRow: View {
    let title: String
    var subtitle: String? = nil
    var icon: String? = nil
    var iconTint: Color = SobrColor.accent
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button {
            HapticsManager.shared.selection()
            action()
        } label: {
            HStack(spacing: SobrSpacing.md) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(iconTint)
                        .frame(width: 36, height: 36)
                        .background(iconTint.opacity(0.16), in: Circle())
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(SobrFont.body(.semibold))
                        .foregroundStyle(SobrColor.textPrimary)
                        .multilineTextAlignment(.leading)
                    if let subtitle {
                        Text(subtitle)
                            .font(SobrFont.footnote())
                            .foregroundStyle(SobrColor.textSecondary)
                            .multilineTextAlignment(.leading)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                ZStack {
                    Circle()
                        .strokeBorder(isSelected ? .clear : SobrColor.separator, lineWidth: 1.5)
                        .background(Circle().fill(isSelected ? AnyShapeStyle(SobrGradient.brand)
                                                              : AnyShapeStyle(Color.clear)))
                        .frame(width: 24, height: 24)
                    if isSelected {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(SobrColor.textOnAccent)
                    }
                }
            }
            .padding(.horizontal, SobrSpacing.md)
            .padding(.vertical, SobrSpacing.sm + 2)
            .background(SobrColor.surface, in: RoundedRectangle(cornerRadius: SobrRadius.lg))
            .overlay {
                RoundedRectangle(cornerRadius: SobrRadius.lg)
                    .strokeBorder(isSelected ? iconTint.opacity(0.6) : .clear, lineWidth: 1.5)
            }
        }
        .buttonStyle(PressableButtonStyle())
    }
}
