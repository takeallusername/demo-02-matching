import SwiftUI

/// App entry point. Owns the single `AppState` and injects it into the
/// environment so any view can read the active profile.
@main
struct SobrApp: App {
    @State private var appState = AppState()
    @State private var store = StoreService()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(appState)
                .environment(store)
                .preferredColorScheme(.dark)
                .tint(SobrColor.accent)
        }
    }
}
