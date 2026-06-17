import SwiftUI

/// "Symptoms" — a scrollable, grouped, multi-select list of effects the user
/// may recognise, with a sticky warning banner and CTA. Mirrors the reference
/// app's Mental / Physical / Social grouping.
struct SymptomsView: View {
    @Environment(OnboardingViewModel.self) private var vm

    var body: some View {
        ZStack(alignment: .bottom) {
            SobrScreenBackground(tint: SobrColor.harm, showStars: false)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: SobrSpacing.lg) {
                    BackBar { vm.back() }

                    Text("Symptoms")
                        .font(SobrFont.title(.heavy))
                        .foregroundStyle(SobrColor.textPrimary)
                        .frame(maxWidth: .infinity)

                    WarningBanner(text: "Heavy alcohol use can quietly affect your body and mind.")

                    Text("Select any you've noticed:")
                        .font(SobrFont.body(.semibold))
                        .foregroundStyle(SobrColor.textPrimary)

                    ForEach(SymptomContent.grouped(), id: \.0) { category, symptoms in
                        VStack(alignment: .leading, spacing: SobrSpacing.sm) {
                            Text(category.rawValue.uppercased())
                                .font(SobrFont.caption(.bold)).tracking(1)
                                .foregroundStyle(SobrColor.textTertiary)

                            ForEach(symptoms) { symptom in
                                SelectableRow(
                                    title: symptom.title,
                                    isSelected: vm.selectedSymptomIDs.contains(symptom.id)
                                ) {
                                    toggle(symptom.id)
                                }
                            }
                        }
                    }

                    // Spacer so content clears the pinned CTA.
                    Color.clear.frame(height: 96)
                }
                .padding(.horizontal, SobrSpacing.screenMargin)
                .padding(.top, SobrSpacing.xs)
            }

            PrimaryButton(title: "Build my plan") { vm.advance() }
                .padding(.horizontal, SobrSpacing.screenMargin)
                .padding(.bottom, SobrSpacing.sm)
                .background(
                    LinearGradient(colors: [.clear, SobrColor.background],
                                   startPoint: .top, endPoint: .bottom)
                        .frame(height: 140)
                        .allowsHitTesting(false),
                    alignment: .bottom
                )
        }
    }

    private func toggle(_ id: String) {
        withAnimation(.spring(response: 0.3)) {
            if vm.selectedSymptomIDs.contains(id) {
                vm.selectedSymptomIDs.remove(id)
            } else {
                vm.selectedSymptomIDs.insert(id)
            }
        }
    }
}

/// A rounded warning banner used to introduce the symptoms list.
struct WarningBanner: View {
    let text: String
    var body: some View {
        Text(text)
            .font(SobrFont.callout(.semibold))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(SobrSpacing.md)
            .background(SobrGradient.harm, in: RoundedRectangle(cornerRadius: SobrRadius.md))
    }
}
