import SwiftUI

/// A numbered, single-select choice row used by the quiz. Tapping selects it;
/// the selected state is reflected with the brand accent.
struct OptionCard: View {
    let index: Int
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button {
            HapticsManager.shared.selection()
            action()
        } label: {
            HStack(spacing: SobrSpacing.md) {
                Text("\(index)")
                    .font(SobrFont.callout(.bold))
                    .foregroundStyle(isSelected ? SobrColor.textOnAccent : SobrColor.textPrimary)
                    .frame(width: 28, height: 28)
                    .background {
                        Circle().fill(isSelected ? AnyShapeStyle(SobrGradient.brand)
                                                  : AnyShapeStyle(SobrColor.accent.opacity(0.18)))
                    }

                Text(title)
                    .font(SobrFont.body(.medium))
                    .foregroundStyle(SobrColor.textPrimary)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, SobrSpacing.md)
            .padding(.vertical, SobrSpacing.md)
            .background(SobrColor.surface, in: RoundedRectangle(cornerRadius: SobrRadius.pill))
            .overlay {
                RoundedRectangle(cornerRadius: SobrRadius.pill)
                    .strokeBorder(isSelected ? SobrColor.accent : .clear, lineWidth: 1.5)
            }
        }
        .buttonStyle(PressableButtonStyle())
    }
}
