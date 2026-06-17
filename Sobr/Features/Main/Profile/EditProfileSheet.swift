import SwiftUI

/// A small form to edit the profile basics: name, the sober-since date (which
/// drives every streak), and the daily-spend estimate behind "money saved".
struct EditProfileSheet: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    @State private var name: String
    @State private var soberSince: Date
    @State private var dailySpend: Double

    init(profile: UserProfile) {
        _name = State(initialValue: profile.name)
        _soberSince = State(initialValue: profile.soberSince)
        _dailySpend = State(initialValue: profile.estimatedDailySpend)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Name") {
                    TextField("Your first name", text: $name)
                }

                Section("Sober since") {
                    DatePicker("Start date", selection: $soberSince,
                               in: ...Date.now, displayedComponents: [.date, .hourAndMinute])
                }

                Section("Daily spend estimate") {
                    HStack {
                        Text("$\(Int(dailySpend)) / day")
                        Spacer()
                        Stepper("", value: $dailySpend, in: 0...200, step: 1)
                            .labelsHidden()
                    }
                    Text("Used to estimate the money you've saved.")
                        .font(SobrFont.footnote())
                        .foregroundStyle(SobrColor.textTertiary)
                }
            }
            .navigationTitle("Edit profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                }
            }
        }
    }

    private func save() {
        appState.updateProfile { profile in
            profile.name = name.trimmingCharacters(in: .whitespaces)
            profile.soberSince = soberSince
            profile.estimatedDailySpend = dailySpend
        }
        dismiss()
    }
}
