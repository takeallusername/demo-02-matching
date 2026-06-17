import SwiftUI

/// The Profile tab: the sobriety card, tracked goals, editable settings, a clear
/// privacy statement, and a reset. Mutations go through `AppState` so they are
/// persisted immediately.
struct ProfileView: View {
    @Environment(AppState.self) private var appState
    @State private var showingEdit = false
    @State private var showingResetConfiret = false

    private var profile: UserProfile? { appState.profile }

    var body: some View {
        NavigationStack {
            ZStack {
                SobrScreenBackground(tint: SobrColor.accent)

                if let profile {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: SobrSpacing.lg) {
                            SobrietyCard(memberName: profile.name.isEmpty ? nil : profile.name,
                                         streakDays: SobrietyClock.streakDays(since: profile.soberSince),
                                         soberSince: profile.soberSince)

                            goalsSection(profile)
                            settingsSection
                            privacySection

                            Color.clear.frame(height: SobrSpacing.lg)
                        }
                        .padding(.horizontal, SobrSpacing.screenMargin)
                        .padding(.top, SobrSpacing.md)
                    }
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Edit") { showingEdit = true }
                        .foregroundStyle(SobrColor.accent)
                }
            }
            .sheet(isPresented: $showingEdit) {
                if let profile { EditProfileSheet(profile: profile) }
            }
        }
    }

    // MARK: - Sections

    private func goalsSection(_ profile: UserProfile) -> some View {
        let goals = GoalContent.all.filter { profile.selectedGoalIDs.contains($0.id) }
        return Group {
            if !goals.isEmpty {
                VStack(alignment: .leading, spacing: SobrSpacing.sm) {
                    SectionHeader(title: "Goals you're tracking")
                    FlowLayout(spacing: SobrSpacing.xs) {
                        ForEach(goals) { goal in
                            TagChip(title: goal.title, icon: goal.symbol, tint: goal.tint)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: SobrSpacing.sm) {
            SectionHeader(title: "Settings")
            Button(role: .destructive) {
                showingResetConfiret = true
            } label: {
                Label("Reset all data & restart", systemImage: "arrow.counterclockwise")
                    .font(SobrFont.body(.semibold))
                    .foregroundStyle(SobrColor.harm)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(SobrSpacing.md)
                    .background(SobrColor.surface, in: RoundedRectangle(cornerRadius: SobrRadius.lg))
            }
            .confirmationDialog("Reset everything?",
                                isPresented: $showingResetConfiret, titleVisibility: .visible) {
                Button("Reset and start over", role: .destructive) {
                    appState.resetEverything()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This permanently clears your streak and answers from this device.")
            }
        }
    }

    private var privacySection: some View {
        HStack(alignment: .top, spacing: SobrSpacing.sm) {
            Image(systemName: "lock.shield.fill").foregroundStyle(SobrColor.recovery)
            Text("Your answers and streak stay on this device. Sobr doesn't upload your recovery data to any server.")
                .font(SobrFont.footnote())
                .foregroundStyle(SobrColor.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(SobrSpacing.md)
        .background(SobrColor.recovery.opacity(0.1), in: RoundedRectangle(cornerRadius: SobrRadius.md))
    }
}
