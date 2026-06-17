import Foundation

/// Pure, testable helpers for turning a `soberSince` date into the figures the
/// UI shows: whole days for the streak and a live D/H/M/S breakdown for the
/// dashboard counter. Kept free of any UI or storage dependency.
enum SobrietyClock {

    /// Whole days elapsed since `start` (never negative).
    static func streakDays(since start: Date, now: Date = .now) -> Int {
        let days = Calendar.current.dateComponents([.day], from: start, to: now).day ?? 0
        return max(0, days)
    }

    /// A live countdown-style breakdown for the headline counter.
    static func elapsed(since start: Date, now: Date = .now) -> Elapsed {
        let interval = max(0, now.timeIntervalSince(start))
        let totalSeconds = Int(interval)
        return Elapsed(
            days: totalSeconds / 86_400,
            hours: (totalSeconds % 86_400) / 3_600,
            minutes: (totalSeconds % 3_600) / 60,
            seconds: totalSeconds % 60
        )
    }

    struct Elapsed: Equatable {
        let days, hours, minutes, seconds: Int
    }
}
