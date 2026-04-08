import SwiftUI

struct PickCardsView: View {
    @ObservedObject var vm: TarotViewModel
    @Environment(\.dismiss) private var dismiss

    private let gold = Color(hex: "e0b24a")
    private let softGold = Color(hex: "b58d62")

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                CosmicBackgroundView()

                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: geo.safeAreaInsets.top + 60)

                    titleSection
                        .padding(.horizontal, 28)

                    Spacer()
                        .frame(height: 25)

                    questionInput
                        .padding(.horizontal, 24)

                    Spacer()
                        .frame(height: 35)

                    cardArea
                        .frame(height: 340)

                    Spacer()
                        .frame(height: 0)

                    // ── PROCEED BUTTON — now triggers spin reveal ──
                    Button {
                        vm.prepareForSpinReveal()   // ← only change from original
                    } label: {
                        Text("PROCEED TO REVEAL ✦")
                            .font(.custom("Cinzel-Regular", size: 12))
                            .kerning(2.4)
                            .foregroundColor(vm.canProceed && !vm.question.trimmingCharacters(in: .whitespaces).isEmpty ? gold : softGold.opacity(0.4))
                            .frame(maxWidth: .infinity)
                            .frame(height: 66)
                            .background(
                                RoundedRectangle(cornerRadius: 18)
                                    .fill(Color(hex: "050e2a").opacity(vm.canProceed && !vm.question.trimmingCharacters(in: .whitespaces).isEmpty ? 0.90 : 0.50))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 18)
                                            .stroke(gold.opacity(vm.canProceed && !vm.question.trimmingCharacters(in: .whitespaces).isEmpty ? 0.75 : 0.20), lineWidth: 1.5)
                                    )
                            )
                    }
                    .buttonStyle(.plain)
                    .disabled(!vm.canProceed || vm.question.trimmingCharacters(in: .whitespaces).isEmpty)
                    .opacity(vm.canProceed && !vm.question.trimmingCharacters(in: .whitespaces).isEmpty ? 1 : 0.4)
                    .padding(.horizontal, 24)

                    Spacer()
                        .frame(height: 12)
                }

                // Top fade overlay
                LinearGradient(
                    colors: [
                        Color(hex: "060d1a").opacity(0.95),
                        Color(hex: "060d1a").opacity(0.0)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: geo.safeAreaInsets.top + 60)
                .ignoresSafeArea(edges: .top)
                .allowsHitTesting(false)
            }
            .ignoresSafeArea(edges: .top)
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
    }

    private var topBar: some View {
        HStack {
            Button {
                if !vm.navigationPath.isEmpty {
                    vm.navigationPath.removeLast()
                } else {
                    dismiss()
                }
            } label: {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.05))
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.12), lineWidth: 1)
                        )
                    Image(systemName: "chevron.left")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(.white.opacity(0.95))
                }
                .frame(width: 52, height: 52)
            }
            .buttonStyle(.plain)
            Spacer()
        }
    }

    private var titleSection: some View {
        VStack(spacing: 8) {
            Text("PICK 3 CARDS")
                .font(.custom("Cinzel-Regular", size: 28))
                .kerning(3.6)
                .foregroundColor(gold)

            Text("Choose your card, feel the connection")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(softGold)
        }
    }

    private var questionInput: some View {
        HStack(spacing: 0) {
            TextField(
                "",
                text: Binding(
                    get: { vm.question },
                    set: { vm.question = $0 }
                ),
                prompt: Text("Ask your question...")
                    .foregroundColor(.white.opacity(0.55))
            )
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(.white)
            .padding(.horizontal, 18)
            .frame(height: 66)

            Button { } label: {
                ZStack {
                    Rectangle()
                        .fill(Color(hex: "050e2a").opacity(0.60))
                    Image(systemName: "mic")
                        .font(.system(size: 26, weight: .regular))
                        .foregroundColor(softGold)
                }
                .frame(width: 98, height: 66)
            }
            .buttonStyle(.plain)
        }
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(hex: "050e2a").opacity(0.60))
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(gold.opacity(0.30), lineWidth: 1)
                )
        )
    }

    private var cardArea: some View {
        ZStack(alignment: .bottom) {
            Text(vm.selectedCardIndices.count == 3
                 ? "Your 3 cards are ready"
                 : "Select 3 cards from the deck")
                .font(.custom("Cinzel-Regular", size: 15))
                .italic()
                .foregroundColor(softGold)
                .offset(y: -18)
                .zIndex(1)

            CardFanView(
                cards: vm.deckCards,
                selectedIndices: vm.selectedCardIndices,
                onTap: { index in
                    vm.toggleCard(index: index)
                }
            )
        }
    }
}

#Preview {
    PickCardsView(vm: TarotViewModel())
        .preferredColorScheme(.dark)
}
