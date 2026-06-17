import SwiftUI

/// The post-onboarding home. Four focused tabs — Home, Progress, Tools and
/// Profile. No chatbot and no social feed by design; Sobr is a private,
/// self-guided tool.
struct MainTabView: View {
    @State private var selection: Tab = .home

    enum Tab: Hashable { case home, progress, tools, profile }

    var body: some View {
        TabView(selection: $selection) {
            DashboardView()
                .tag(Tab.home)
                .tabItem { Label("Home", systemImage: "house.fill") }

            ProgressTabView()
                .tag(Tab.progress)
                .tabItem { Label("Progress", systemImage: "chart.line.uptrend.xyaxis") }

            ToolsView()
                .tag(Tab.tools)
                .tabItem { Label("Tools", systemImage: "square.grid.2x2.fill") }

            ProfileView()
                .tag(Tab.profile)
                .tabItem { Label("Profile", systemImage: "person.fill") }
        }
        .tint(SobrColor.accent)
    }
}
