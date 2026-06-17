import SwiftUI

/// Reveals text one character at a time with a soft "두두두" haptic tick as it
/// types, then a gentle settle tap at the end.
///
/// The full string is laid out invisibly underneath to reserve the final size,
/// so the surrounding layout never reflows or jumps as characters appear — it
/// also guarantees the text can't overflow mid-animation.
struct TypewriterText: View {
    let text: String
    var font: Font = SobrFont.title(.bold)
    var color: Color = SobrColor.textPrimary
    var alignment: TextAlignment = .center
    var charInterval: Double = 0.03
    var hapticEvery: Int = 2
    var startDelay: Double = 0
    var onFinished: (() -> Void)? = nil

    @State private var revealedCount = 0
    @State private var driver: Task<Void, Never>?

    private var frameAlignment: Alignment {
        switch alignment {
        case .leading: return .topLeading
        case .trailing: return .topTrailing
        default: return .top
        }
    }

    var body: some View {
        ZStack(alignment: frameAlignment) {
            // Invisible full text reserves the final footprint.
            styled(text).opacity(0)
            styled(String(text.prefix(revealedCount)))
        }
        .onAppear(perform: start)
        .onDisappear { driver?.cancel() }
    }

    private func styled(_ value: String) -> some View {
        Text(value)
            .font(font)
            .foregroundStyle(color)
            .multilineTextAlignment(alignment)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: frameAlignment)
    }

    private func start() {
        driver?.cancel()
        revealedCount = 0
        let characters = Array(text)
        driver = Task { @MainActor in
            if startDelay > 0 {
                try? await Task.sleep(nanoseconds: UInt64(startDelay * 1_000_000_000))
            }
            for index in characters.indices {
                if Task.isCancelled { return }
                revealedCount = index + 1
                let char = characters[index]
                if !char.isWhitespace && index % hapticEvery == 0 {
                    HapticsManager.shared.tick(intensity: 0.45)
                }
                try? await Task.sleep(nanoseconds: UInt64(charInterval * 1_000_000_000))
            }
            if Task.isCancelled { return }
            HapticsManager.shared.softTap(intensity: 0.7)
            onFinished?()
        }
    }
}
