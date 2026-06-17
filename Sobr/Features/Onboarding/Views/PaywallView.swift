import SwiftUI

/// The paywall. Presents a personalised plan, the benefits of going sober, a
/// testimonial and two subscription options. `onFinish(premium:)` reports
/// whether the user subscribed; a low-key free option keeps the app usable
/// without paying (a deliberate ethical departure from hard paywalls).
struct PaywallView: View {
    @Environment(OnboardingViewModel.self) private var vm
    let onFinish: (_ premium: Bool) -> Void

    @State private var selectedPlan: Plan = .annual

    private let benefits: [(String, String)] = [
        ("Better sleep", "moon.stars.fill"),
        ("Steadier mood", "face.smiling.fill"),
        ("More energy", "bolt.fill"),
        ("Sharper focus", "scope"),
        ("Money saved", "banknote.fill"),
        ("Stronger relationships", "heart.fill")
    ]

    var body: some View {
        ZStack(alignment: .bottom) {
            SobrScreenBackground(tint: SobrColor.accent, showStars: false)

            ScrollView(showsIndicators: false) {
                VStack(spacing: SobrSpacing.lg) {
                    header
                    benefitCloud
                    testimonial
                    planPicker
                    Color.clear.frame(height: 150)
                }
                .padding(.horizontal, SobrSpacing.screenMargin)
                .padding(.top, SobrSpacing.lg)
            }

            footer
        }
    }

    // MARK: - Sections

    private var header: some View {
        VStack(spacing: SobrSpacing.md) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 34))
                .foregroundStyle(SobrColor.accent)

            Text(vm.name.isEmpty ? "We've made you a custom plan."
                                 : "\(vm.name), we've made you a custom plan.")
                .font(SobrFont.title(.heavy))
                .foregroundStyle(SobrColor.textPrimary)
                .multilineTextAlignment(.center)

            VStack(spacing: 4) {
                Text("You could be free from alcohol by")
                    .font(SobrFont.callout())
                    .foregroundStyle(SobrColor.textSecondary)
                Text(vm.projectedDate, format: .dateTime.month(.wide).day().year())
                    .font(SobrFont.headline(.bold))
                    .foregroundStyle(SobrColor.textOnAccent)
                    .padding(.horizontal, SobrSpacing.md)
                    .padding(.vertical, SobrSpacing.xs)
                    .background(SobrColor.textPrimary, in: Capsule())
            }
        }
    }

    private var benefitCloud: some View {
        VStack(spacing: SobrSpacing.sm) {
            Text("Become the best version of yourself")
                .font(SobrFont.headline(.bold))
                .foregroundStyle(SobrColor.textPrimary)
                .multilineTextAlignment(.center)

            FlowLayout(spacing: SobrSpacing.xs) {
                ForEach(benefits, id: \.0) { title, icon in
                    TagChip(title: title, icon: icon, tint: SobrColor.accent)
                }
            }
        }
    }

    private var testimonial: some View {
        VStack(spacing: SobrSpacing.sm) {
            HStack(spacing: 2) {
                ForEach(0..<5, id: \.self) { _ in
                    Image(systemName: "star.fill").font(.system(size: 12))
                        .foregroundStyle(SobrColor.caution)
                }
            }
            Text("\u{201C}I didn't realise how much alcohol was running my life until I stopped. The clarity is worth everything.\u{201D}")
                .font(SobrFont.body(.medium))
                .foregroundStyle(SobrColor.textPrimary)
                .multilineTextAlignment(.center)
            Text("Anonymous · 7 months sober")
                .font(SobrFont.footnote())
                .foregroundStyle(SobrColor.textTertiary)
        }
        .padding(SobrSpacing.md)
        .background(SobrColor.surface, in: RoundedRectangle(cornerRadius: SobrRadius.lg))
    }

    private var planPicker: some View {
        VStack(spacing: SobrSpacing.sm) {
            HStack {
                Text("Choose your plan")
                    .font(SobrFont.headline(.bold))
                    .foregroundStyle(SobrColor.textPrimary)
                Spacer()
                Text("Limited offer")
                    .font(SobrFont.caption(.bold))
                    .foregroundStyle(SobrColor.accent)
                    .padding(.horizontal, 10).padding(.vertical, 5)
                    .background(SobrColor.accent.opacity(0.15), in: Capsule())
            }

            ForEach(Plan.allCases) { plan in
                PlanRow(plan: plan, isSelected: selectedPlan == plan) {
                    withAnimation(.spring(response: 0.3)) { selectedPlan = plan }
                }
            }

            Label("Private & on-device. Cancel anytime.", systemImage: "lock.shield.fill")
                .font(SobrFont.footnote(.medium))
                .foregroundStyle(SobrColor.textSecondary)
                .padding(.top, SobrSpacing.xs)
        }
    }

    private var footer: some View {
        VStack(spacing: SobrSpacing.xs) {
            PrimaryButton(title: "Start my journey today") { onFinish(true) }
            TextLinkButton(title: "Continue with the free version") { onFinish(false) }
        }
        .padding(.horizontal, SobrSpacing.screenMargin)
        .padding(.top, SobrSpacing.md)
        .padding(.bottom, SobrSpacing.sm)
        .background(
            LinearGradient(colors: [.clear, SobrColor.background, SobrColor.background],
                           startPoint: .top, endPoint: .bottom)
                .frame(height: 200).allowsHitTesting(false),
            alignment: .bottom
        )
    }
}

/// The two subscription options shown on the paywall.
enum Plan: String, CaseIterable, Identifiable {
    case annual, lifetime
    var id: String { rawValue }

    var title: String { self == .annual ? "Annual" : "Lifetime" }
    var price: String { self == .annual ? "$44 / year" : "$77 once" }
    var strikethrough: String { self == .annual ? "$110" : "$199" }
    var caption: String? { self == .annual ? "60% off · billed yearly" : "Pay once, yours forever" }
}

private struct PlanRow: View {
    let plan: Plan
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: SobrSpacing.md) {
                Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                    .font(.system(size: 22))
                    .foregroundStyle(isSelected ? SobrColor.accent : SobrColor.separator)

                VStack(alignment: .leading, spacing: 2) {
                    Text(plan.title).font(SobrFont.body(.bold))
                        .foregroundStyle(SobrColor.textPrimary)
                    if let caption = plan.caption {
                        Text(caption).font(SobrFont.footnote())
                            .foregroundStyle(SobrColor.textSecondary)
                    }
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text(plan.price).font(SobrFont.body(.bold))
                        .foregroundStyle(SobrColor.textPrimary)
                    Text(plan.strikethrough)
                        .font(SobrFont.footnote())
                        .strikethrough()
                        .foregroundStyle(SobrColor.textTertiary)
                }
            }
            .padding(SobrSpacing.md)
            .background(SobrColor.surface, in: RoundedRectangle(cornerRadius: SobrRadius.lg))
            .overlay {
                RoundedRectangle(cornerRadius: SobrRadius.lg)
                    .strokeBorder(isSelected ? SobrColor.accent : SobrColor.separator,
                                  lineWidth: isSelected ? 2 : 1)
            }
        }
        .buttonStyle(PressableButtonStyle())
    }
}
