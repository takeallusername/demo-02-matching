import UIKit

/// Centralised haptics. Generators are kept prepared so feedback fires with
/// minimal latency, which is what makes the rapid "tick-tick-tick" bursts (the
/// progress ring filling, text typing out) feel tactile and trustworthy.
///
/// All calls are main-actor bound because `UIFeedbackGenerator` must be used
/// from the main thread.
@MainActor
final class HapticsManager {
    static let shared = HapticsManager()

    private let rigid = UIImpactFeedbackGenerator(style: .rigid)
    private let soft = UIImpactFeedbackGenerator(style: .soft)
    private let light = UIImpactFeedbackGenerator(style: .light)
    private let selectionGenerator = UISelectionFeedbackGenerator()
    private let notification = UINotificationFeedbackGenerator()

    private init() {}

    /// Warm up the generators (call when a haptic-heavy screen appears).
    func prepare() {
        rigid.prepare(); soft.prepare(); light.prepare(); selectionGenerator.prepare()
    }

    // MARK: - Discrete feedback

    /// A crisp tick — the unit of the "두두두" bursts.
    func tick(intensity: CGFloat = 0.6) {
        rigid.impactOccurred(intensity: intensity)
        rigid.prepare()
    }

    func softTap(intensity: CGFloat = 0.6) {
        soft.impactOccurred(intensity: intensity)
        soft.prepare()
    }

    func lightTap(intensity: CGFloat = 0.5) {
        light.impactOccurred(intensity: intensity)
        light.prepare()
    }

    func selection() {
        selectionGenerator.selectionChanged()
        selectionGenerator.prepare()
    }

    func success() { notification.notificationOccurred(.success) }
    func warning() { notification.notificationOccurred(.warning) }

    // MARK: - Bursts

    /// Fire `count` ticks across `duration`, optionally accelerating so the
    /// burst feels like it's "spinning up". Returns the driving task so callers
    /// can cancel it if the view disappears early.
    @discardableResult
    func tickingBurst(count: Int,
                      duration: Double,
                      accelerating: Bool = true,
                      startIntensity: CGFloat = 0.35,
                      endIntensity: CGFloat = 0.8) -> Task<Void, Never> {
        Task { @MainActor in
            guard count > 0 else { return }
            for i in 0..<count {
                if Task.isCancelled { return }
                let progress = Double(i) / Double(max(1, count - 1))
                // Ease so spacing tightens toward the end when accelerating.
                let eased = accelerating ? (progress * progress) : progress
                let step = duration / Double(count)
                let delay = accelerating ? step * (1.6 - eased) : step
                let intensity = startIntensity + (endIntensity - startIntensity) * CGFloat(progress)
                tick(intensity: intensity)
                try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            }
        }
    }
}
