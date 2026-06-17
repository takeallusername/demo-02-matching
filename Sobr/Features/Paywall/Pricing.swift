import Foundation

/// The purchasable plans and their fixed marketing prices.
///
/// Every discount in the app is expressed **relative to the monthly plan** —
/// specifically against a full year of monthly billing (`yearOfMonthly`) — so
/// the user always sees a consistent "X% off vs monthly" figure.
enum SubscriptionPlan: String, Identifiable, CaseIterable {
    case monthly
    case yearly
    case lifetime          // standard lifetime
    case exitLifetime      // shown when the user tries to leave
    case finalLifetime     // shown a day later if still not converted

    var id: String { rawValue }

    /// The App Store product identifier. Subscriptions (`monthly`, `yearly`)
    /// live in one subscription group; the lifetime tiers are separate
    /// non-consumables (one SKU per downsell price). These IDs match both the
    /// bundled `Sobr.storekit` test config and what you'd create in App Store
    /// Connect for production.
    var productID: String {
        switch self {
        case .monthly:       return "com.sobr.app.monthly"
        case .yearly:        return "com.sobr.app.yearly"
        case .lifetime:      return "com.sobr.app.lifetime"
        case .exitLifetime:  return "com.sobr.app.lifetime.exit"
        case .finalLifetime: return "com.sobr.app.lifetime.final"
        }
    }

    /// Resolve a plan from a product identifier (e.g. from a StoreKit
    /// transaction).
    static func plan(forProductID id: String) -> SubscriptionPlan? {
        allCases.first { $0.productID == id }
    }

    var price: Double {
        switch self {
        case .monthly:       return 12.99
        case .yearly:        return 44.99
        case .lifetime:      return 59.99
        case .exitLifetime:  return 49.99
        case .finalLifetime: return 11.99
        }
    }

    var title: String {
        switch self {
        case .monthly: return "Monthly"
        case .yearly:  return "Yearly"
        case .lifetime, .exitLifetime, .finalLifetime: return "Lifetime"
        }
    }

    var periodLabel: String {
        switch self {
        case .monthly: return "per month"
        case .yearly:  return "per year"
        case .lifetime, .exitLifetime, .finalLifetime: return "one-time payment"
        }
    }

    var isLifetime: Bool { self == .lifetime || self == .exitLifetime || self == .finalLifetime }

    // MARK: - Discount maths (all relative to monthly)

    /// The headline monthly price — the baseline for every discount.
    static let monthlyPrice = 12.99

    /// One year of monthly billing. Discounts compare against this so a yearly
    /// or lifetime plan reads as a large, honest "% off vs monthly".
    static let yearOfMonthly = monthlyPrice * 12

    /// Whole-percent discount versus a year of monthly billing (monthly = 0%).
    var percentOffVsMonthly: Int {
        guard self != .monthly else { return 0 }
        let ratio = 1 - price / Self.yearOfMonthly
        return max(0, Int((ratio * 100).rounded()))
    }

    /// Effective monthly cost (used for the "just $x/mo" framing on yearly).
    var effectiveMonthly: Double {
        self == .yearly ? price / 12 : price
    }

    // MARK: - Formatting

    var priceText: String { Self.currency(price) }
    var effectiveMonthlyText: String { Self.currency(effectiveMonthly) }

    /// The crossed-out reference price (a year of monthly) for lifetime/yearly.
    var anchorText: String { Self.currency(Self.yearOfMonthly) }

    static func currency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        let fractionDigits = value.rounded() == value ? 0 : 2
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: value)) ?? "$\(value)"
    }
}
