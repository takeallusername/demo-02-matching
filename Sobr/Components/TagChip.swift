import SwiftUI

/// A small benefit/feature chip used on the paywall and analysis screens, e.g.
/// "Better Sleep", "Clearer Skin". Optionally carries a leading SF Symbol.
struct TagChip: View {
    let title: String
    var icon: String? = nil
    var tint: Color = SobrColor.accent

    var body: some View {
        HStack(spacing: 6) {
            if let icon {
                Image(systemName: icon).font(.system(size: 11, weight: .bold))
            }
            Text(title).font(SobrFont.footnote(.semibold))
        }
        .foregroundStyle(tint)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(tint.opacity(0.14), in: Capsule())
        .overlay(Capsule().strokeBorder(tint.opacity(0.35), lineWidth: 1))
    }
}

/// Page-control dots for the education carousels.
struct ProgressDots: View {
    let count: Int
    let current: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<count, id: \.self) { i in
                Circle()
                    .fill(i == current ? SobrColor.textPrimary : SobrColor.textPrimary.opacity(0.25))
                    .frame(width: i == current ? 8 : 6, height: i == current ? 8 : 6)
                    .animation(.spring(response: 0.3), value: current)
            }
        }
    }
}

/// Segmented "dash" progress used at the top of the multi-step education
/// sections (the row of growing dashes in the reference UI).
struct SegmentedProgress: View {
    let count: Int
    let current: Int
    var tint: Color = SobrColor.accent

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<count, id: \.self) { i in
                Capsule()
                    .fill(i <= current ? AnyShapeStyle(tint) : AnyShapeStyle(SobrColor.separator))
                    .frame(height: 4)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: current)
    }
}
