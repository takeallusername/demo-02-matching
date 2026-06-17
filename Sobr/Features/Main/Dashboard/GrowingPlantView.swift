import SwiftUI

/// A growth metaphor for the streak: a plant that advances through stages as the
/// sober days add up (seed → sprout → seedling → young plant → tree). Replaces
/// the reference app's "life tree" with Sobr's calmer, on-brand version.
struct GrowingPlantView: View {
    let streakDays: Int

    private var stage: Stage { Stage(streakDays: streakDays) }

    var body: some View {
        VStack(spacing: SobrSpacing.sm) {
            ZStack {
                Circle()
                    .fill(SobrColor.recovery.opacity(0.12))
                    .frame(width: 150, height: 150)
                Circle()
                    .strokeBorder(SobrColor.recovery.opacity(0.3), lineWidth: 1)
                    .frame(width: 150, height: 150)

                Image(systemName: stage.symbol)
                    .font(.system(size: stage.symbolSize, weight: .semibold))
                    .foregroundStyle(SobrColor.recovery)
                    .symbolEffect(.bounce, value: streakDays)
                    .contentTransition(.symbolEffect(.replace))
            }
            .shadow(color: SobrColor.recovery.opacity(0.4), radius: 24)

            Text(stage.label)
                .font(SobrFont.callout(.semibold))
                .foregroundStyle(SobrColor.textSecondary)
        }
    }

    /// Growth stages mapped from sober days.
    private enum Stage {
        case seed, sprout, seedling, plant, tree

        init(streakDays: Int) {
            switch streakDays {
            case ..<1:    self = .seed
            case 1..<7:   self = .sprout
            case 7..<30:  self = .seedling
            case 30..<90: self = .plant
            default:      self = .tree
            }
        }

        var symbol: String {
            switch self {
            case .seed:     return "circle.fill"
            case .sprout:   return "leaf.fill"
            case .seedling: return "camera.macro"
            case .plant:    return "tree.fill"
            case .tree:     return "tree.circle.fill"
            }
        }

        var symbolSize: CGFloat {
            switch self {
            case .seed:     return 28
            case .sprout:   return 52
            case .seedling: return 64
            case .plant:    return 72
            case .tree:     return 84
            }
        }

        var label: String {
            switch self {
            case .seed:     return "Your journey begins"
            case .sprout:   return "Taking root"
            case .seedling: return "Growing stronger"
            case .plant:    return "Flourishing"
            case .tree:     return "Standing tall"
            }
        }
    }
}
