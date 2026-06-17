import Foundation

/// The self-identifiable symptoms shown after the analysis, grouped by life
/// area. Items are drawn from well-documented effects of regular/heavy alcohol
/// use (NHS, CDC, NIAAA, WHO) and phrased in plain, non-clinical language.
enum SymptomContent {

    static let all: [Symptom] = [
        // Mental
        Symptom(id: "anxiety",        title: "Anxiety, especially the morning after", category: .mental),
        Symptom(id: "lowMood",        title: "Low mood or depression",                 category: .mental),
        Symptom(id: "brainFog",       title: "Brain fog & poor concentration",         category: .mental),
        Symptom(id: "memory",         title: "Memory gaps or blackouts",               category: .mental),
        Symptom(id: "irritable",      title: "Mood swings & irritability",             category: .mental),
        Symptom(id: "unmotivated",    title: "Low motivation",                         category: .mental),

        // Physical
        Symptom(id: "sleep",          title: "Poor, broken sleep",                     category: .physical),
        Symptom(id: "fatigue",        title: "Low energy & fatigue",                   category: .physical),
        Symptom(id: "hangovers",      title: "Frequent hangovers",                     category: .physical),
        Symptom(id: "weight",         title: "Weight gain & bloating",                 category: .physical),
        Symptom(id: "stomach",        title: "Stomach or digestion issues",            category: .physical),
        Symptom(id: "immune",         title: "Getting sick more often",                category: .physical),

        // Social
        Symptom(id: "relationships",  title: "Tension or arguments with loved ones",   category: .social),
        Symptom(id: "money",          title: "Money slipping away on alcohol",         category: .social),
        Symptom(id: "work",           title: "Falling behind at work or study",        category: .social),
        Symptom(id: "isolation",      title: "Pulling away from people",               category: .social),
        Symptom(id: "regret",         title: "Regret over things said or done",        category: .social),
        Symptom(id: "hobbies",        title: "Losing interest in hobbies",             category: .social)
    ]

    static func grouped() -> [(Symptom.Category, [Symptom])] {
        Symptom.Category.allCases.map { category in
            (category, all.filter { $0.category == category })
        }
    }
}
