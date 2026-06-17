# Sobr

**Sobr** is a native iOS app (SwiftUI) that helps people take back control from
alcohol. It's a calm, private, self-guided sobriety companion — a "Quittr for
alcohol", reimagined around clarity rather than shame.

> The clear-headed you is already on the way.

## What it does

A full onboarding journey that educates, assesses and motivates, followed by a
focused daily app:

**Onboarding** (mirrors a best-in-class flow, adapted for alcohol)
1. Splash → Welcome → sobriety-card preview
2. A 10-question self-assessment quiz (adapted from the validated **AUDIT** and
   **CAGE** screening instruments)
3. "Calculating" → an **Analysis** screen scoring you against an average, with a
   clear *not-a-diagnosis* disclaimer
4. **Symptoms** you self-identify with (Mental / Physical / Social)
5. **Understanding alcohol** — a 5-beat educational carousel (depressant → harm
   → relationships → rebound anxiety → recovery), each beat in its own color
6. **Welcome to Sobr** — a 6-beat product tour
7. Anonymous testimonials → a recovery graph (**Path to Freedom**)
8. **Choose your goals** → notifications → a personalised **plan reveal**
9. A **rating** prompt (placed immediately before checkout) → a **hard paywall**

### Pricing & the hard paywall

The paywall is the only door into the app — there is no free entry. Plans:

| Plan | Price | Off vs monthly |
|---|---|---|
| Monthly | $12.99 / mo | — (baseline) |
| Yearly | $44.99 / yr | ~71% |
| Lifetime | $59.99 once | ~62% |

Every discount is computed against a **full year of monthly billing**
($12.99 × 12), so the user always sees an honest "% off vs monthly".

**Downsell ladder** (persisted across launches):
- Try to leave without buying → **Lifetime $49.99** (exit offer)
- Still not converted a **day later** → **Lifetime $11.99** (final offer)

### In-app purchases (StoreKit 2)

Purchases run through **StoreKit 2** (`StoreService`): product loading,
verified `purchase()`, a `Transaction.updates` listener, entitlement checks and
**Restore purchases**. Prices and the "% off" badges come from the live products
when loaded, with a static fallback.

A `Sobr/Resources/Sobr.storekit` config is bundled and wired into the scheme, so
the **full purchase flow runs in the simulator** with no App Store Connect setup.
For production, create the matching products (see `SubscriptionPlan.productID`)
in App Store Connect and add the In-App Purchase capability.

**Main app** (4 tabs, no AI, no community — by design)
- **Home** — a live sobriety counter, a growth metaphor (seed → tree), an
  urge-support button, a daily pledge, the next milestone and money saved
- **Progress** — milestone badges, a science-based recovery timeline, and your
  self-assessment baseline
- **Tools** — guided breathing, an urge-surfing reset, a learn library, and
  "My why"
- **Profile** — your sobriety card, tracked goals, editable settings and a reset

## Deliberate design choices

- **Supportive, not shaming.** The urge tool uses *urge surfing* and slow
  breathing (both evidence-aligned) instead of confronting the user.
- **Privacy by design.** Everything is stored **on-device** via `UserDefaults`;
  no recovery data is uploaded anywhere.
- **Honest & safe.** A persistent safety note warns that dependent drinkers can
  face dangerous withdrawal and should seek medical help. Nothing here is
  medical advice.
- **No fabricated endorsements.** Testimonials are anonymous, illustrative
  composites — never fake quotes attributed to real named experts.

## Architecture

Clean MVVM with a clear separation of concerns:

```
Sobr/
  App/            App entry, AppState (single source of truth), RootView router
  DesignSystem/   Color, type, spacing, gradient tokens (no magic numbers)
  Components/     Reusable, dumb UI building blocks
  Models/         UserProfile, SobrietyClock (pure logic)
  Services/       PersistenceService (storage behind a protocol)
  Features/
    Onboarding/   Models · Content · ViewModel · Views
    Main/         Dashboard · Progress · Tools · Profile
  Resources/      Assets
```

- **State** lives in `AppState` (`@Observable`); features own their own
  view-models. Views stay thin and declarative.
- **Content is data.** Quiz questions, symptoms, education slides, goals and the
  recovery timeline are declared as plain models in `Content/`, so copy changes
  never touch view code.
- **Storage** sits behind the `ProfileStoring` protocol, so it's swappable and
  testable.

## Running it

Requires **Xcode 16+** and **iOS 17+**.

```bash
open Sobr.xcodeproj
```

Select the **Sobr** scheme and run on an iPhone simulator.

## Content & sources

Educational copy and the screening quiz are paraphrased from public materials
from **NIAAA, NHS, CDC and WHO**, and the behavioral tools (self-monitoring,
trigger mapping, urge surfing, CBT-style reframing, goal-setting, breathing) are
grounded in published evidence. Effects of self-guided tools are real but
modest; Sobr is a starting point and a companion, not a replacement for
professional treatment.

*Sobr is not a medical device and does not provide medical advice. If you are
physically dependent on alcohol, please consult a healthcare professional before
stopping.*
