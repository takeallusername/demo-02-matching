import Foundation

/// The onboarding quiz.
///
/// Structure mirrors the reference app (gender → frequency → referral → a run of
/// behavioural questions → name/age), but the diagnostic questions are adapted
/// from validated alcohol-screening instruments — the WHO **AUDIT** (frequency,
/// typical quantity, impaired control, "eye-opener" morning drinking) and the
/// **CAGE** questionnaire (others concerned / cutting down). The weights drive a
/// self-assessment score only; this is **not** a clinical diagnosis (see the
/// disclaimer surfaced on the analysis screen).
///
/// Sources: WHO AUDIT (Babor et al., 2001); Ewing JA, CAGE, JAMA 1984;
/// NIAAA "Rethinking Drinking".
enum QuizContent {

    static let questions: [QuizQuestion] = [
        // 1 — context (unscored), mirrors reference Q1
        QuizQuestion(
            id: "gender",
            prompt: "What is your gender?",
            options: [
                QuizOption(label: "Male"),
                QuizOption(label: "Female"),
                QuizOption(label: "Prefer not to say")
            ]
        ),

        // 2 — AUDIT Q1: frequency of drinking
        QuizQuestion(
            id: "frequency",
            prompt: "How often do you have a drink containing alcohol?",
            options: [
                QuizOption(label: "Monthly or less", weight: 0.2),
                QuizOption(label: "2–4 times a month", weight: 0.45),
                QuizOption(label: "2–3 times a week", weight: 0.7),
                QuizOption(label: "4 or more times a week", weight: 1.0)
            ]
        ),

        // 3 — context (unscored), mirrors reference Q3
        QuizQuestion(
            id: "referral",
            prompt: "Where did you hear about us?",
            options: [
                QuizOption(label: "X"),
                QuizOption(label: "Instagram"),
                QuizOption(label: "TikTok"),
                QuizOption(label: "A friend"),
                QuizOption(label: "Google"),
                QuizOption(label: "Somewhere else")
            ]
        ),

        // 4 — tolerance, mirrors reference "shift to more extreme"
        QuizQuestion(
            id: "tolerance",
            prompt: "Have you noticed you need more alcohol to feel the same effect?",
            options: [
                QuizOption(label: "No", weight: 0.1),
                QuizOption(label: "Yes", weight: 1.0)
            ]
        ),

        // 5 — age of first drink, mirrors reference "age of first exposure"
        QuizQuestion(
            id: "ageFirstDrink",
            prompt: "At what age did you have your first full drink?",
            options: [
                QuizOption(label: "14 or younger", weight: 1.0),
                QuizOption(label: "15 to 17", weight: 0.7),
                QuizOption(label: "18 to 20", weight: 0.45),
                QuizOption(label: "21 or older", weight: 0.25)
            ]
        ),

        // 6 — AUDIT Q4: impaired control once started
        QuizQuestion(
            id: "impairedControl",
            prompt: "Do you find it hard to stop drinking once you've started?",
            options: [
                QuizOption(label: "Rarely or never", weight: 0.2),
                QuizOption(label: "Occasionally", weight: 0.6),
                QuizOption(label: "Frequently", weight: 1.0)
            ]
        ),

        // 7 — drinking to cope, mirrors reference "cope with pain"
        QuizQuestion(
            id: "copeEmotion",
            prompt: "Do you use alcohol to cope with stress, anxiety, or low mood?",
            options: [
                QuizOption(label: "Rarely or never", weight: 0.2),
                QuizOption(label: "Occasionally", weight: 0.6),
                QuizOption(label: "Frequently", weight: 1.0)
            ]
        ),

        // 8 — drinking more than intended, mirrors reference "when stressed"
        QuizQuestion(
            id: "moreThanIntended",
            prompt: "Do you often end up drinking more than you intended?",
            options: [
                QuizOption(label: "Frequently", weight: 1.0),
                QuizOption(label: "Rarely or never", weight: 0.2),
                QuizOption(label: "Occasionally", weight: 0.6)
            ]
        ),

        // 9 — boredom drinking, mirrors reference "out of boredom"
        QuizQuestion(
            id: "boredom",
            prompt: "Do you drink out of boredom or habit?",
            options: [
                QuizOption(label: "Rarely or never", weight: 0.2),
                QuizOption(label: "Frequently", weight: 1.0),
                QuizOption(label: "Occasionally", weight: 0.6)
            ]
        ),

        // 10 — AUDIT Q6 / CAGE "eye-opener": morning drinking
        QuizQuestion(
            id: "morningDrink",
            prompt: "Have you ever needed a drink in the morning to steady your nerves?",
            options: [
                QuizOption(label: "Yes", weight: 1.0),
                QuizOption(label: "No", weight: 0.1)
            ]
        )
    ]
}
