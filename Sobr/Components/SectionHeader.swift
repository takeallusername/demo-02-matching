import SwiftUI

/// A labelled section header (title plus optional subtitle) used across the main
/// app to introduce content groups.
struct SectionHeader: View {
    let title: String
    var subtitle: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(SobrFont.headline(.bold))
                .foregroundStyle(SobrColor.textPrimary)
            if let subtitle {
                Text(subtitle)
                    .font(SobrFont.footnote())
                    .foregroundStyle(SobrColor.textSecondary)
            }
        }
    }
}
