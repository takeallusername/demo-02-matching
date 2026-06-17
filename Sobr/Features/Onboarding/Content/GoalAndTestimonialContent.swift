import SwiftUI

/// Goals offered on the "Choose your goals" screen — the positive flip-side of
/// the documented benefits of cutting out alcohol.
enum GoalContent {
    static let all: [Goal] = [
        Goal(id: "sleep",        title: "Sleep better",                 symbol: "moon.stars.fill",   tint: SobrColor.calm),
        Goal(id: "mood",         title: "Improved mood & less anxiety", symbol: "face.smiling.fill", tint: SobrColor.recovery),
        Goal(id: "energy",       title: "More energy",                  symbol: "bolt.fill",         tint: SobrColor.caution),
        Goal(id: "money",        title: "Save money",                   symbol: "banknote.fill",     tint: SobrColor.accent),
        Goal(id: "focus",        title: "Clearer thinking & focus",     symbol: "scope",             tint: SobrColor.accentSecondary),
        Goal(id: "relationships",title: "Stronger relationships",       symbol: "heart.fill",        tint: SobrColor.harm),
        Goal(id: "health",       title: "Better physical health",       symbol: "figure.run",        tint: SobrColor.recovery),
        Goal(id: "control",      title: "Self-control & confidence",    symbol: "checkmark.seal.fill", tint: SobrColor.accent)
    ]
}

/// Anonymous, paraphrased testimonials for the social-proof screen. These are
/// illustrative composites, not real attributed quotes — a deliberate ethical
/// choice given how easily fabricated expert endorsements mislead.
enum TestimonialContent {
    static let all: [Testimonial] = [
        Testimonial(quote: "I finally sleep through the night. The mornings without dread are everything.",
                    attribution: "Anonymous · 3 months sober"),
        Testimonial(quote: "Tracking the days made it real. Seeing the streak grow is what kept me going.",
                    attribution: "Anonymous · 6 weeks sober"),
        Testimonial(quote: "My anxiety dropped off a cliff after the first month. I didn't expect that.",
                    attribution: "Anonymous · 4 months sober"),
        Testimonial(quote: "Mapping my triggers changed everything. I stopped getting caught off guard.",
                    attribution: "Anonymous · 5 months sober"),
        Testimonial(quote: "I'm more present with my family than I've been in years.",
                    attribution: "Anonymous · 1 year sober")
    ]
}
