import SwiftUI
import StoreKit

/// The hard paywall — the only door into the app, backed by real StoreKit 2
/// purchases.
///
/// It reads its stage from `AppState.pendingCheckout`, so:
/// - **standard:** monthly / yearly / lifetime ($59.99)
/// - **exitOffer:** a discounted lifetime ($49.99), shown after the user tries
///   to leave
/// - **finalOffer:** the best lifetime ($11.99), unlocked a day later
///
/// Prices and the "% off vs monthly" badges come from the live products when
/// loaded (with a static fallback). There is no free exit; the close button only
/// ever reveals a better deal.
struct PaywallView: View {
    @Environment(AppState.self) private var appState
    @Environment(StoreService.self) private var store

    @State private var selectedPlan: SubscriptionPlan = .yearly
    @State private var isPurchasing = false
    @State private var errorMessage: String?

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
                    restoreButton
                    reassurance
                    Color.clear.frame(height: 160)
                }
                .padding(.horizontal, SobrSpacing.screenMargin)
                .padding(.top, SobrSpacing.xs)
            }

            footer
        }
        .onAppear { selectedPlan = defaultPlan(for: stage) }
        .onChange(of: stage) { _, newStage in
            withAnimation(.spring(response: 0.4)) { selectedPlan = defaultPlan(for: newStage) }
        }
        .alert("Something went wrong",
               isPresented: Binding(get: { errorMessage != nil },
                                    set: { if !$0 { errorMessage = nil } })) {
            Button("OK", role: .cancel) { errorMessage = nil }
        } message: {
            Text(errorMessage ?? "")
        }
    }

    private func defaultPlan(for stage: PaywallStage) -> SubscriptionPlan {
        stage == .standard ? .yearly : stage.lifetimePlan
    }

    // MARK: - Actions

    private func buy() {
        guard !isPurchasing else { return }
        isPurchasing = true
        Task {
            defer { isPurchasing = false }
            do {
                let success = try await store.purchase(selectedPlan)
                if success {
                    HapticsManager.shared.success()
                    appState.completePurchase(plan: selectedPlan)
                }
            } catch {
                HapticsManager.shared.warning()
                errorMessage = error.localizedDescription
            }
        }
    }

    private func restore() {
        Task {
            do {
                try await store.restore()
                if store.hasEntitlement {
                    appState.unlockFromEntitlement()
                } else {
                    errorMessage = "No previous purchases were found on this Apple ID."
                }
            } catch {
                errorMessage = error.localizedDescription
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

            Text(name.isEmpty ? "Your plan is ready" : "\(name), your plan is ready")
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
        let percent = store.percentOffVsMonthly(plan)
        return HStack(spacing: SobrSpacing.sm) {
            Image(systemName: stage == .finalOffer ? "gift.fill" : "bolt.fill")
                .foregroundStyle(.white)
            VStack(alignment: .leading, spacing: 2) {
                Text(stage == .finalOffer ? "Your final offer" : "Wait — special offer")
                    .font(SobrFont.callout(.bold))
                Text("Lifetime access, \(percent)% off vs monthly")
                    .font(SobrFont.footnote())
                    .foregroundStyle(.white.opacity(0.9))
            }
            Spacer()
            Text("\(percent)%")
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
                PlanRow(
                    title: plan.title,
                    priceText: store.displayPrice(for: plan),
                    anchorText: store.anchorText(),
                    percentOff: store.percentOffVsMonthly(plan),
                    subtitle: subtitle(for: plan),
                    isSelected: selectedPlan == plan
                ) {
                    HapticsManager.shared.selection()
                    withAnimation(.spring(response: 0.3)) { selectedPlan = plan }
                }
            }
        }
    }

    private func subtitle(for plan: SubscriptionPlan) -> String {
        switch plan {
        case .monthly:
            return "Billed monthly · our baseline price"
        case .yearly:
            return "Just \(store.effectiveMonthlyText(for: plan))/mo · billed yearly"
        case .lifetime, .exitLifetime, .finalLifetime:
            return "Pay once · yours forever"
        }
    }

    private var restoreButton: some View {
        TextLinkButton(title: "Restore purchases") { restore() }
    }

    private var reassurance: some View {
        Label("Private & on-device. Cancel anytime.", systemImage: "lock.shield.fill")
            .font(SobrFont.footnote(.medium))
            .foregroundStyle(SobrColor.textSecondary)
    }

    private var footer: some View {
        VStack(spacing: SobrSpacing.xs) {
            Button(action: buy) {
                Group {
                    if isPurchasing {
                        ProgressView().tint(SobrColor.textOnAccent)
                    } else {
                        Text(ctaTitle)
                    }
                }
                .font(SobrFont.headline(.bold))
                .foregroundStyle(SobrColor.textOnAccent)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(SobrGradient.brand)
                .clipShape(Capsule())
                .shadow(color: SobrColor.accent.opacity(0.35), radius: 18, y: 8)
            }
            .buttonStyle(PressableButtonStyle())
            .disabled(isPurchasing)

            Text("Secured by the App Store · \(store.displayPrice(for: selectedPlan)) \(selectedPlan.periodLabel)")
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
/// a short value subtitle. Purely presentational — all strings are resolved by
/// the parent so the row stays dumb.
private struct PlanRow: View {
    let title: String
    let priceText: String
    let anchorText: String
    let percentOff: Int
    let subtitle: String
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
                        Text(title).font(SobrFont.body(.bold))
                            .foregroundStyle(SobrColor.textPrimary)
                            .lineLimit(1)
                        if percentOff > 0 {
                            Text("\(percentOff)% OFF")
                                .font(SobrFont.caption(.bold))
                                .foregroundStyle(SobrColor.textOnAccent)
                                .padding(.horizontal, 7).padding(.vertical, 3)
                                .background(SobrGradient.brand, in: Capsule())
                                .fixedSize()
                        }
                    }
                    Text(subtitle)
                        .font(SobrFont.footnote())
                        .foregroundStyle(SobrColor.textSecondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text(priceText)
                        .font(SobrFont.body(.bold))
                        .foregroundStyle(SobrColor.textPrimary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    if percentOff > 0 {
                        Text(anchorText)
                            .font(SobrFont.footnote())
                            .strikethrough()
                            .foregroundStyle(SobrColor.textTertiary)
                            .lineLimit(1)
                    }
                }
                .layoutPriority(1)
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
