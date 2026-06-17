import SwiftUI

/// A row of filled stars used for ratings and trust flourishes.
struct StarRow: View {
    var count: Int = 5
    var size: CGFloat = 14
    var color: Color = SobrColor.caution

    var body: some View {
        HStack(spacing: size * 0.34) {
            ForEach(0..<count, id: \.self) { _ in
                Image(systemName: "star.fill")
                    .font(.system(size: size))
                    .foregroundStyle(color)
            }
        }
        .accessibilityElement()
        .accessibilityLabel("\(count) out of \(count) stars")
    }
}
