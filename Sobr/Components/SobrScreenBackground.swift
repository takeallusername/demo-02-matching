import SwiftUI

/// The standard Sobr screen backdrop: a deep midnight base with an optional
/// soft tinted wash at the top and a scattering of faint "stars" for depth,
/// echoing the calm night-sky mood of the reference onboarding.
struct SobrScreenBackground: View {
    var tint: Color = SobrColor.accent
    var showStars: Bool = true

    var body: some View {
        ZStack {
            SobrColor.background
            SobrGradient.screenWash(tint)
            if showStars {
                StarfieldView()
                    .opacity(0.5)
                    .allowsHitTesting(false)
            }
        }
        .ignoresSafeArea()
    }
}

/// A lightweight, deterministic starfield. Seeded so the layout is stable
/// across redraws (no distracting reshuffle on every state change).
private struct StarfieldView: View {
    private let stars: [Star] = {
        var generator = SeededGenerator(seed: 42)
        return (0..<40).map { _ in
            Star(
                x: Double.random(in: 0...1, using: &generator),
                y: Double.random(in: 0...1, using: &generator),
                size: Double.random(in: 1...2.5, using: &generator),
                opacity: Double.random(in: 0.05...0.35, using: &generator)
            )
        }
    }()

    var body: some View {
        GeometryReader { geo in
            ForEach(stars) { star in
                Circle()
                    .fill(.white.opacity(star.opacity))
                    .frame(width: star.size, height: star.size)
                    .position(x: star.x * geo.size.width,
                              y: star.y * geo.size.height)
            }
        }
    }

    private struct Star: Identifiable {
        let id = UUID()
        let x, y, size, opacity: Double
    }
}

/// A tiny seedable RNG so the starfield is stable between renders.
private struct SeededGenerator: RandomNumberGenerator {
    private var state: UInt64
    init(seed: UInt64) { state = seed &+ 0x9E3779B97F4A7C15 }
    mutating func next() -> UInt64 {
        state &+= 0x9E3779B97F4A7C15
        var z = state
        z = (z ^ (z >> 30)) &* 0xBF58476D1CE4E5B9
        z = (z ^ (z >> 27)) &* 0x94D049BB133111EB
        return z ^ (z >> 31)
    }
}
