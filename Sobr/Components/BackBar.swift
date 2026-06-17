import SwiftUI

/// A leading back-chevron in a circular surface, reused by screens that allow
/// stepping back through onboarding.
struct BackBar: View {
    var onBack: () -> Void

    var body: some View {
        HStack {
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(SobrColor.textPrimary)
                    .frame(width: 40, height: 40)
                    .background(SobrColor.surface, in: Circle())
            }
            .buttonStyle(PressableButtonStyle())
            Spacer()
        }
    }
}
