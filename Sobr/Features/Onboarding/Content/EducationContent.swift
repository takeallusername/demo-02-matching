import SwiftUI

/// Copy for the two educational carousels.
///
/// `understandingAlcohol` mirrors the reference app's "why this is a problem"
/// story (a depressant → bodily harm → strained relationships → rebound
/// anxiety → recovery), each beat in its own accent color. `welcomeToSobr`
/// mirrors the "what our app does" feature story.
///
/// The science is paraphrased from NIAAA, NHS, CDC and WHO public materials and
/// kept deliberately non-alarmist. Nothing here is a clinical claim.
enum EducationContent {

    /// Carousel 1 — understanding alcohol (5 beats).
    static let understandingAlcohol: [EducationSlide] = [
        EducationSlide(
            symbol: "drop.fill",
            title: "Alcohol is a depressant",
            body: "That \u{201C}relaxed\u{201D} feeling is alcohol slowing your nervous system. It boosts GABA and dampens your brain \u{2014} which is exactly why one drink leads to another.",
            accent: SobrColor.calm
        ),
        EducationSlide(
            symbol: "heart.slash.fill",
            title: "It quietly strains your body",
            body: "Regular drinking taxes your liver, heart and sleep, and raises long-term health risks. Much of the damage builds silently, long before you feel it.",
            accent: SobrColor.harm
        ),
        EducationSlide(
            symbol: "person.2.slash.fill",
            title: "It erodes what matters",
            body: "Alcohol dulls real connection and replaces it with the next drink. Over time that means more conflict, more distance, and more mornings of regret.",
            accent: SobrColor.harm
        ),
        EducationSlide(
            symbol: "cloud.rain.fill",
            title: "Feeling anxious or low?",
            body: "As the alcohol wears off your brain rebounds into an over-excited state \u{2014} the racing heart and dread of \u{201C}hangxiety.\u{201D} Drinking to fix it only feeds the cycle.",
            accent: SobrColor.calm
        ),
        EducationSlide(
            symbol: "leaf.fill",
            title: "Recovery is possible",
            body: "Your brain is built to heal. With time alcohol-free it rebalances \u{2014} bringing back deeper sleep, steadier mood and a clearer head.",
            accent: SobrColor.recovery
        )
    ]

    /// Carousel 2 — welcome to Sobr (6 feature beats).
    static let welcomeToSobr: [EducationSlide] = [
        EducationSlide(
            symbol: "sparkles",
            title: "Welcome to Sobr",
            body: "A calm, private space to take back control \u{2014} built on proven behavioral science, not willpower alone.",
            accent: SobrColor.accent
        ),
        EducationSlide(
            symbol: "brain.head.profile",
            title: "Rewire your habits",
            body: "Short, science-backed tools help you break the automatic loop between trigger and drink, one day at a time.",
            accent: SobrColor.accent
        ),
        EducationSlide(
            symbol: "flame.fill",
            title: "Stay motivated",
            body: "A daily check-in and a growing streak keep your progress visible \u{2014} so quitting feels like winning, not white-knuckling.",
            accent: SobrColor.accent
        ),
        EducationSlide(
            symbol: "shield.lefthalf.filled",
            title: "Spot your triggers",
            body: "Sobr helps you map the moments that make you want to drink, and gives you a plan ready for when they hit.",
            accent: SobrColor.accent
        ),
        EducationSlide(
            symbol: "medal.fill",
            title: "Know yourself",
            body: "Track your strengths, learn your patterns, and earn milestones as the days add up.",
            accent: SobrColor.accent
        ),
        EducationSlide(
            symbol: "arrow.up.heart.fill",
            title: "Level up your life",
            body: "Better sleep, steadier mood, more energy and money back in your pocket \u{2014} the benefits compound the longer you go.",
            accent: SobrColor.accent
        )
    ]
}
