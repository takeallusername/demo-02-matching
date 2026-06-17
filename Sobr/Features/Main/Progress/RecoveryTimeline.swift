import Foundation

/// A documented "what happens when you stop" benefit, keyed to a sober-time
/// threshold. Content is paraphrased from public NHS / NIAAA / CDC materials on
/// the timeline of recovery after stopping alcohol, and is intentionally
/// general — individual experiences vary.
struct RecoveryBenefit: Identifiable, Equatable {
    let id = UUID()
    let timeLabel: String
    let hoursThreshold: Double  // sober hours at which this becomes "reached"
    let title: String
    let detail: String
}

enum RecoveryTimeline {
    static let benefits: [RecoveryBenefit] = [
        RecoveryBenefit(timeLabel: "24 hours", hoursThreshold: 24,
                        title: "Your body starts clearing",
                        detail: "Blood sugar begins to stabilise and your body starts processing out the last of the alcohol."),
        RecoveryBenefit(timeLabel: "72 hours", hoursThreshold: 72,
                        title: "Energy returns",
                        detail: "Most alcohol has left your system and early energy and hydration improvements begin."),
        RecoveryBenefit(timeLabel: "1 week", hoursThreshold: 168,
                        title: "Deeper sleep",
                        detail: "Sleep quality improves as your rest stops being disrupted by alcohol, so you wake more refreshed."),
        RecoveryBenefit(timeLabel: "2 weeks", hoursThreshold: 336,
                        title: "Steadier digestion",
                        detail: "Your stomach lining settles and digestion steadies; many people notice early weight changes."),
        RecoveryBenefit(timeLabel: "1 month", hoursThreshold: 720,
                        title: "Clearer skin & lower blood pressure",
                        detail: "Liver fat reduces, skin often looks clearer and blood pressure tends to trend downward."),
        RecoveryBenefit(timeLabel: "3 months", hoursThreshold: 2160,
                        title: "Sharper mind, steadier mood",
                        detail: "Concentration and memory sharpen, mood and energy grow more stable, and immune function improves."),
        RecoveryBenefit(timeLabel: "6 months", hoursThreshold: 4320,
                        title: "Your liver recovers",
                        detail: "Liver function can improve substantially and cardiovascular markers continue to get better."),
        RecoveryBenefit(timeLabel: "1 year", hoursThreshold: 8760,
                        title: "A reset life",
                        detail: "Long-term health risks fall markedly, with a year of savings and reset habits behind you.")
    ]

    static func isReached(_ benefit: RecoveryBenefit, soberHours: Double) -> Bool {
        soberHours >= benefit.hoursThreshold
    }
}
