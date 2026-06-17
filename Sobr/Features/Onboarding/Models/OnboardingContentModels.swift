import SwiftUI

/// A self-identified symptom shown on the analysis "symptoms" screen, grouped
/// by life area, mirroring the reference app's Mental / Physical / Social split.
struct Symptom: Identifiable, Equatable {
    let id: String
    let title: String
    let category: Category

    enum Category: String, CaseIterable, Identifiable {
        case mental = "Mental"
        case physical = "Physical"
        case social = "Social"
        var id: String { rawValue }
    }
}

/// One slide in an educational carousel. The `accent` drives the slide's
/// per-beat color so the story (depressant → harm → recovery) has momentum.
struct EducationSlide: Identifiable, Equatable {
    let id = UUID()
    let symbol: String          // SF Symbol illustrating the beat
    let title: String
    let body: String
    let accent: Color
}

/// A recovery goal the user can choose to track.
struct Goal: Identifiable, Equatable {
    let id: String
    let title: String
    let symbol: String
    let tint: Color
}

/// An anonymized testimonial. Sobr deliberately uses only anonymous, paraphrased
/// experiences — never fabricated quotes attributed to real named experts.
struct Testimonial: Identifiable, Equatable {
    let id = UUID()
    let quote: String
    let attribution: String     // e.g. "Anonymous · 4 months sober"
}
