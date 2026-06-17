import SwiftUI

/// "Finally — a little more about you." Collects the user's first name and age
/// band, then completes the quiz. The CTA stays disabled until both are set.
struct AboutYouView: View {
    @Environment(OnboardingViewModel.self) private var vm
    @FocusState private var nameFocused: Bool

    private var canContinue: Bool {
        !vm.name.trimmingCharacters(in: .whitespaces).isEmpty && vm.ageRange != nil
    }

    var body: some View {
        @Bindable var vm = vm
        ZStack {
            SobrScreenBackground(tint: SobrColor.accent)

            VStack(alignment: .leading, spacing: SobrSpacing.lg) {
                OnboardingProgressBar(progress: 1) { vm.back() }
                    .padding(.top, SobrSpacing.xs)

                VStack(spacing: SobrSpacing.xs) {
                    Text("Finally").font(SobrFont.largeTitle(.heavy))
                        .foregroundStyle(SobrColor.textPrimary)
                    Text("A little more about you")
                        .font(SobrFont.headline(.regular))
                        .foregroundStyle(SobrColor.textSecondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, SobrSpacing.xs)

                VStack(alignment: .leading, spacing: SobrSpacing.xs) {
                    Text("NAME").font(SobrFont.caption(.bold)).tracking(1)
                        .foregroundStyle(SobrColor.textTertiary)
                    TextField("", text: $vm.name, prompt: Text("Your first name")
                        .foregroundColor(SobrColor.textTertiary))
                        .font(SobrFont.body(.semibold))
                        .foregroundStyle(SobrColor.textPrimary)
                        .focused($nameFocused)
                        .submitLabel(.done)
                        .padding(SobrSpacing.md)
                        .background(SobrColor.surface, in: RoundedRectangle(cornerRadius: SobrRadius.md))
                }

                VStack(alignment: .leading, spacing: SobrSpacing.xs) {
                    Text("AGE").font(SobrFont.caption(.bold)).tracking(1)
                        .foregroundStyle(SobrColor.textTertiary)
                    AgeGrid(selection: $vm.ageRange)
                }

                Spacer()

                PrimaryButton(title: "Complete quiz", isEnabled: canContinue) {
                    nameFocused = false
                    vm.advance()
                }
                .padding(.bottom, SobrSpacing.sm)
            }
            .padding(.horizontal, SobrSpacing.screenMargin)
        }
        .contentShape(Rectangle())
        .onTapGesture { nameFocused = false }
    }
}

/// A wrapping grid of age-band chips.
private struct AgeGrid: View {
    @Binding var selection: AgeRange?
    private let columns = [GridItem(.adaptive(minimum: 96), spacing: SobrSpacing.sm)]

    var body: some View {
        LazyVGrid(columns: columns, spacing: SobrSpacing.sm) {
            ForEach(AgeRange.allCases) { range in
                let isSelected = selection == range
                Button {
                    withAnimation(.spring(response: 0.3)) { selection = range }
                } label: {
                    Text(range.rawValue)
                        .font(SobrFont.callout(.semibold))
                        .foregroundStyle(isSelected ? SobrColor.textOnAccent : SobrColor.textPrimary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, SobrSpacing.sm)
                        .background {
                            RoundedRectangle(cornerRadius: SobrRadius.md)
                                .fill(isSelected ? AnyShapeStyle(SobrGradient.brand)
                                                 : AnyShapeStyle(SobrColor.surface))
                        }
                }
                .buttonStyle(PressableButtonStyle())
            }
        }
    }
}
