import Foundation

/// A streak milestone the user can unlock. `dayThreshold` is the number of
/// sober days at which it is earned.
struct Milestone: Identifiable, Equatable {
    let id: String
    let dayThreshold: Int
    let title: String
    let symbol: String

    func isUnlocked(streakDays: Int) -> Bool { streakDays >= dayThreshold }
}

enum MilestoneContent {
    static let all: [Milestone] = [
        Milestone(id: "d1",   dayThreshold: 1,   title: "First day",     symbol: "1.circle.fill"),
        Milestone(id: "d3",   dayThreshold: 3,   title: "72 hours",      symbol: "3.circle.fill"),
        Milestone(id: "w1",   dayThreshold: 7,   title: "One week",      symbol: "star.fill"),
        Milestone(id: "w2",   dayThreshold: 14,  title: "Two weeks",     symbol: "sparkles"),
        Milestone(id: "m1",   dayThreshold: 30,  title: "One month",     symbol: "moon.stars.fill"),
        Milestone(id: "m3",   dayThreshold: 90,  title: "90 days",       symbol: "flame.fill"),
        Milestone(id: "m6",   dayThreshold: 180, title: "Six months",    symbol: "crown.fill"),
        Milestone(id: "y1",   dayThreshold: 365, title: "One year",      symbol: "trophy.fill")
    ]

    /// The next milestone the user is working toward, if any.
    static func next(after streakDays: Int) -> Milestone? {
        all.first { $0.dayThreshold > streakDays }
    }
}
