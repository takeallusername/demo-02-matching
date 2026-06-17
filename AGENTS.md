# Sobr — agent guide

Sobr is a **native iOS app built with SwiftUI** (Xcode 16+, iOS 17+). It helps
people get sober from alcohol: a full educational/assessment onboarding flow
followed by a focused daily app.

## Conventions

- **SwiftUI + MVVM.** App state lives in `AppState` (`@Observable`); each feature
  owns its own view-model. Keep views thin and declarative.
- **Design tokens only.** Use `SobrColor`, `SobrFont`, `SobrSpacing`,
  `SobrRadius`, `SobrGradient` — never hard-code colors, fonts or magic numbers.
- **Content is data.** Quiz, symptoms, education slides, goals and the recovery
  timeline are declared in `Features/Onboarding/Content` and the `Main` feature
  folders. Change copy there, not in views.
- **Storage** goes through the `ProfileStoring` protocol. All data stays
  on-device; do not add network sync of recovery data.
- **Reusable UI** lives in `Components/`; keep those views "dumb".

## Product guardrails (intentional)

- **No AI chatbot, no community/social feed, no leaderboard.**
- The urge-support flow is **supportive, never shaming**.
- Always keep the **withdrawal safety disclaimer** and the *not medical advice*
  framing. Do not fabricate statistics or attribute quotes to real named people.

## Project layout

See `README.md` for the full tree. The Xcode project uses a file-system
synchronized group, so new files added under `Sobr/` are picked up automatically.
