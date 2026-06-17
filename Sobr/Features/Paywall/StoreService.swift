import StoreKit
import Observation

/// StoreKit 2 integration: loads products, runs purchases, verifies and listens
/// for transactions, and tracks the user's current entitlements.
///
/// For local development, the bundled `Sobr.storekit` config lets the whole
/// flow run in the simulator without App Store Connect. For production, create
/// the matching products (see `SubscriptionPlan.productID`) in App Store Connect.
@Observable
@MainActor
final class StoreService {

    enum LoadState: Equatable { case idle, loading, loaded, failed(String) }

    private(set) var products: [Product] = []
    private(set) var purchasedProductIDs: Set<String> = []
    private(set) var loadState: LoadState = .idle

    /// True once the user owns any subscription or lifetime product.
    var hasEntitlement: Bool { !purchasedProductIDs.isEmpty }

    @ObservationIgnored private var updatesTask: Task<Void, Never>?

    init() {
        // Observe transactions that happen outside an explicit purchase call
        // (renewals, Ask-to-Buy approvals, purchases on other devices).
        updatesTask = listenForTransactions()
        Task {
            await loadProducts()
            await refreshEntitlements()
        }
    }

    deinit { updatesTask?.cancel() }

    // MARK: - Products

    func product(for plan: SubscriptionPlan) -> Product? {
        products.first { $0.id == plan.productID }
    }

    func loadProducts() async {
        loadState = .loading
        do {
            let ids = SubscriptionPlan.allCases.map(\.productID)
            products = try await Product.products(for: ids)
            loadState = .loaded
        } catch {
            loadState = .failed(error.localizedDescription)
        }
    }

    // MARK: - Display helpers (real StoreKit prices, with static fallback)

    /// Localised price string, falling back to the static price if products
    /// haven't loaded yet.
    func displayPrice(for plan: SubscriptionPlan) -> String {
        product(for: plan)?.displayPrice ?? plan.priceText
    }

    /// "% off vs monthly", computed from live prices when available so the badge
    /// always matches what the user is actually charged.
    func percentOffVsMonthly(_ plan: SubscriptionPlan) -> Int {
        guard plan != .monthly,
              let monthly = product(for: .monthly)?.price,
              let planPrice = product(for: plan)?.price,
              monthly > 0 else {
            return plan.percentOffVsMonthly
        }
        let yearOfMonthly = monthly * 12
        let ratio = Decimal(1) - planPrice / yearOfMonthly
        let percent = NSDecimalNumber(decimal: ratio).doubleValue * 100
        return max(0, Int(percent.rounded()))
    }

    /// The crossed-out reference price (a full year of monthly billing).
    func anchorText() -> String {
        if let monthly = product(for: .monthly) {
            return (monthly.price * 12).formatted(monthly.priceFormatStyle)
        }
        return SubscriptionPlan.currency(SubscriptionPlan.yearOfMonthly)
    }

    /// Effective per-month price for the yearly plan ("just $x/mo").
    func effectiveMonthlyText(for plan: SubscriptionPlan) -> String {
        guard plan == .yearly, let yearly = product(for: .yearly) else {
            return plan.effectiveMonthlyText
        }
        return (yearly.price / 12).formatted(yearly.priceFormatStyle)
    }

    // MARK: - Purchase / restore

    /// Attempts to buy a plan. Returns `true` only on a verified, successful
    /// purchase; `false` for cancellation/pending; throws on failure.
    @discardableResult
    func purchase(_ plan: SubscriptionPlan) async throws -> Bool {
        guard let product = product(for: plan) else { throw StoreError.productNotFound }

        let result = try await product.purchase()
        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await transaction.finish()
            await refreshEntitlements()
            return true
        case .userCancelled, .pending:
            return false
        @unknown default:
            return false
        }
    }

    /// Restores prior purchases (e.g. after reinstall).
    func restore() async throws {
        try await AppStore.sync()
        await refreshEntitlements()
    }

    // MARK: - Entitlements

    func refreshEntitlements() async {
        var owned: Set<String> = []
        for await result in Transaction.currentEntitlements {
            guard let transaction = try? checkVerified(result) else { continue }
            if transaction.revocationDate == nil {
                owned.insert(transaction.productID)
            }
        }
        purchasedProductIDs = owned
    }

    // MARK: - Internals

    private func listenForTransactions() -> Task<Void, Never> {
        Task(priority: .background) { [weak self] in
            for await result in Transaction.updates {
                guard let self else { continue }
                guard let transaction = try? self.checkVerified(result) else { continue }
                await transaction.finish()
                await self.refreshEntitlements()
            }
        }
    }

    private nonisolated func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified: throw StoreError.failedVerification
        case .verified(let safe): return safe
        }
    }

    enum StoreError: LocalizedError {
        case productNotFound, failedVerification

        var errorDescription: String? {
            switch self {
            case .productNotFound:   return "This plan isn't available right now. Please try again."
            case .failedVerification: return "We couldn't verify your purchase with the App Store."
            }
        }
    }
}
