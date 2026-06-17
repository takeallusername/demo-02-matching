import SwiftUI

/// The hard paywall — the only door into the app.
///
/// It reads its stage from `AppState.pendingCheckout`, so:
/// - **standard:** monthly / yearly / lifetime ($59.99)
/// - **exitOffer:** a discounted lifetime ($49.99), shown after the user tries
///   to leave
/// - **finalOffer:** the best lifetime ($11.99), unlocked a day later
///
/// Every price shows how much it saves versus paying monthly. There is no free
/// exit; the close button only ever reveals a better deal.
struct PaywallView: View {
    @Environment(AppState.self) private var appState

    @State private var selectedPlan: SubscriptionPlan = .yearly

    private var checkout: PendingCheckout? { appState.pendingCheckout }
    private var stage: PaywallStage { checkout?.stage ?? .standard }
    private var name: String { checkout?.draft.name ?? "" }

    /// The plans on offer for the current stage, headline plan first.
    private var plans: [SubscriptionPlan] {
        switch stage {
        case .standard:   return [.yearly, .monthly, .lifetime]
        case .exitOffer:  return [.exitLifetime, .yearly, .monthly]
        case .finalOffer: return [.finalLifetime, .yearly, .monthly]
        }
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            SobrScreenBackground(tint: SobrColor.accent, showStars: false)

            ScrollView(showsIndicators: false) {
                VStack(spacing: SobrSpacing.lg) {
                    closeRow
                    header
                    if stage != .standard { offerBanner }
                    benefitCloud
                    planList
                    reassurance
                    Color.clear.frame(height: 150)
                }
                .padding(.horizontal, SobrSpacing.screenMargin)
                .padding(.top, SobrSpacing.xs)
            }

            footer
        }
        .onAppear { selectedPlan = stage.lifetimePlan == .lifetime ? .yearly : stage.lifetimePlan }
        .onChange(of: stage) { _, newStage in
            withAnimation(.spring(response: 0.4)) {
                selectedPlan = newStage.lifetimePlan
            }
        }
    }

    // MARK: - Sections

    private var closeRow: some View {
        HStack {
            Button {
                // Hard paywall: leaving only ever surfaces a better offer.
                withAnimation { appState.registerExitIntent() }
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(SobrColor.textTertiary)
                    .frame(width: 36, height: 36)
                    .background(SobrColor.surface, in: Circle())
            }
            .buttonStyle(PressableButtonStyle())
            Spacer()
        }
    }

    private var header: some View {
        VStack(spacing: SobrSpacing.sm) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 34))
                .foregroundStyle(SobrColor.accent)

            Text(name.isEmpty ? "Your plan is ready"
                              : "\(name), your plan is ready")
                .font(SobrFont.title(.heavy))
                .foregroundStyle(SobrColor.textPrimary)
                .multilineTextAlignment(.center)

            if let date = checkout?.draft.targetDate {
                VStack(spacing: 4) {
                    Text("You could be free from alcohol by")
                        .font(SobrFont.callout())
                        .foregroundStyle(SobrColor.textSecondary)
                    Text(date, format: .dateTime.month(.wide).day().year())
                        .font(SobrFont.headline(.bold))
                        .foregroundStyle(SobrColor.textOnAccent)
                        .padding(.horizontal, SobrSpacing.md)
                        .padding(.vertical, SobrSpacing.xs)
                        .background(SobrColor.textPrimary, in: Capsule())
                }
            }
        }
    }

    /// The urgency banner for downsell stages.
    private var offerBanner: some View {
        let plan = stage.lifetimePlan
        return HStack(spacing: SobrSpacing.sm) {
            Image(systemName: stage == .finalOffer ? "gift.fill" : "bolt.fill")
                .foregroundStyle(.white)
            VStack(alignment: .leading, spacing: 2) {
                Text(stage == .finalOffer ? "Your final offer" : "Wait — special offer")
                    .font(SobrFont.callout(.bold))
                Text("Lifetime access, \(plan.percentOffVsMonthly)% off vs monthly")
                    .font(SobrFont.footnote())
                    .foregroundStyle(.white.opacity(0.9))
            }
            Spacer()
            Text("\(plan.percentOffVsMonthly)%")
                .font(SobrFont.title(.heavy))
                .foregroundStyle(.white)
        }
        .foregroundStyle(.white)
        .padding(SobrSpacing.md)
        .background(SobrGradient.brand, in: RoundedRectangle(cornerRadius: SobrRadius.lg))
        .shadow(color: SobrColor.accent.opacity(0.4), radius: 16, y: 6)
    }

    private var benefitCloud: some View {
        let benefits: [(String, String)] = [
            ("Better sleep", "moon.stars.fill"),
            ("Steadier mood", "face.smiling.fill"),
            ("More energy", "bolt.fill"),
            ("Sharper focus", "scope"),
            ("Money saved", "banknote.fill"),
            ("Stronger relationships", "heart.fill")
        ]
        return VStack(spacing: SobrSpacing.sm) {
            Text("Everything you unlock")
                .font(SobrFont.headline(.bold))
                .foregroundStyle(SobrColor.textPrimary)
            FlowLayout(spacing: SobrSpacing.xs) {
                ForEach(benefits, id: \.0) { title, icon in
                    TagChip(title: title, icon: icon, tint: SobrColor.accent)
                }
            }
        }
    }

    private var planList: some View {
        VStack(spacing: SobrSpacing.sm) {
            ForEach(plans) { plan in
                PlanRow(plan: plan, isSelected: selectedPlan == plan) {
                    withAnimation(.spring(response: 0.3)) { selectedPlan = plan }
                }
            }
        }
    }

    private var reassurance: some View {
        Label("Private & on-device. Cancel anytime.", systemImage: "lock.shield.fill")
            .font(SobrFont.footnote(.medium))
            .foregroundStyle(SobrColor.textSecondary)
    }

    private var footer: some View {
        VStack(spacing: SobrSpacing.xs) {
            PrimaryButton(title: ctaTitle) {
                appState.completePurchase(plan: selectedPlan)
            }
            Text("Secured payment · \(selectedPlan.priceText) \(selectedPlan.periodLabel)")
                .font(SobrFont.caption(.medium))
                .foregroundStyle(SobrColor.textTertiary)
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

    private var ctaTitle: String {
        selectedPlan.isLifetime ? "Get lifetime access" : "Start my journey"
    }
}

/// A single selectable plan row showing price, the "% off vs monthly" badge and
/// — for yearly — the effective monthly cost.
private struct PlanRow: View {
    let plan: SubscriptionPlan
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: SobrSpacing.md) {
                Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                    .font(.system(size: 22))
                    .foregroundStyle(isSelected ? SobrColor.accent : SobrColor.separator)

                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: SobrSpacing.xs) {
                        Text(plan.title).font(SobrFont.body(.bold))
                            .foregroundStyle(SobrColor.textPrimary)
                        if plan.percentOffVsMonthly > 0 {
                            Text("\(plan.percentOffVsMonthly)% OFF")
                                .font(SobrFont.caption(.bold))
                                .foregroundStyle(SobrColor.textOnAccent)
                                .padding(.horizontal, 7).padding(.vertical, 3)
                                .background(SobrGradient.brand, in: Capsule())
                        }
                    }
                    Text(subtitle)
                        .font(SobrFont.footnote())
                        .foregroundStyle(SobrColor.textSecondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text(plan.priceText)
                        .font(SobrFont.body(.bold))
                        .foregroundStyle(SobrColor.textPrimary)
                    if plan.percentOffVsMonthly > 0 {
                        Text(plan.anchorText)
                            .font(SobrFont.footnote())
                            .strikethrough()
                            .foregroundStyle(SobrColor.textTertiary)
                    }
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

    /// A short value line per plan.
    private var subtitle: String {
        switch plan {
        case .monthly:
            return "Billed monthly · our baseline price"
        case .yearly:
            return "Just \(plan.effectiveMonthlyText)/mo · billed yearly"
        case .lifetime, .exitLifetime, .finalLifetime:
            return "Pay once · yours forever"
        }
    }
}
