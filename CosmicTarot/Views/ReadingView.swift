import SwiftUI

struct ReadingView: View {
    @ObservedObject var vm: TarotViewModel
    @State private var cardsAppeared = false
    @State private var savedToast = false

    let positions = ["PAST", "PRESENT", "FUTURE"]

    var body: some View {
        ZStack {
            Color(hex: "0a1428").ignoresSafeArea()
            StarfieldView().ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // Title
                    VStack(spacing: 8) {
                        Text("YOUR READING")
                            .font(.custom("Cinzel-Bold", size: 22))
                            .kerning(4)
                            .foregroundColor(Color(hex: "f0c040"))

                        Text("✦ · ✦")
                            .foregroundColor(Color(hex: "c9a227").opacity(0.5))
                            .font(.title3)
                    }
                    .padding(.top, 56)

                    // 3 Cards Row
                    HStack(spacing: 10) {
                        ForEach(Array(vm.chosenCards.enumerated()), id: \.offset) { index, card in
                            RevealedCardView(
                                card: card,
                                position: positions[index],
                                delay: Double(index) * 0.25,
                                appeared: cardsAppeared
                            )
                        }
                    }
                    .padding(.horizontal, 16)

                    // Interpretation box
                    VStack(alignment: .leading, spacing: 12) {
                        Text("✦ THE ORACLE SPEAKS ✦")
                            .font(.custom("Cinzel-Regular", size: 11))
                            .kerning(3)
                            .foregroundColor(Color(hex: "f0c040"))

                        if vm.isLoadingReading {
                            HStack(spacing: 6) {
                                ForEach(0..<3) { i in
                                    Circle()
                                        .fill(Color(hex: "c9a227"))
                                        .frame(width: 7, height: 7)
                                        .opacity(vm.isLoadingReading ? 1 : 0)
                                        .animation(
                                            Animation.easeInOut(duration: 0.6)
                                                .repeatForever()
                                                .delay(Double(i) * 0.2),
                                            value: vm.isLoadingReading
                                        )
                                }
                            }
                            .padding(.vertical, 8)
                        } else {
                            Text(vm.currentInterpretation)
                                .font(.custom("CrimsonText-Regular", size: 16))
                                .foregroundColor(Color(hex: "d4b483"))
                                .lineSpacing(6)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(hex: "0b163c").opacity(0.85))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(hex: "c9a227").opacity(0.35), lineWidth: 1)
                    )
                    .padding(.horizontal, 16)

                    // Buttons
                    HStack(spacing: 12) {
                        Button {
                            vm.saveCurrentReading()
                            withAnimation { savedToast = true }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation { savedToast = false }
                            }
                        } label: {
                            Label("SAVE", systemImage: "square.and.arrow.down")
                                .font(.custom("Cinzel-Regular", size: 11))
                                .kerning(2)
                                .foregroundColor(Color(hex: "c9a227"))
                                .padding(.vertical, 14)
                                .frame(maxWidth: .infinity)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color(hex: "c9a227"), lineWidth: 1)
                                )
                        }

                        Button {
                            vm.navigationPath = []
                        } label: {
                            Text("HOME")
                                .font(.custom("Cinzel-Regular", size: 11))
                                .kerning(2)
                                .foregroundColor(Color(hex: "c9a227"))
                                .padding(.vertical, 14)
                                .frame(maxWidth: .infinity)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color(hex: "c9a227"), lineWidth: 1)
                                )
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 100)
                }
            }

            // Save toast
            if savedToast {
                VStack {
                    Spacer()
                    Text("Reading saved ✦")
                        .font(.custom("Cinzel-Regular", size: 13))
                        .foregroundColor(Color(hex: "f0c040"))
                        .padding(.horizontal, 20).padding(.vertical, 12)
                        .background(Color(hex: "0b163c").opacity(0.95))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(hex: "c9a227"), lineWidth: 1)
                        )
                        .padding(.bottom, 100)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.1)) {
                cardsAppeared = true
            }
        }
    }
}

// MARK: - Individual Revealed Card
struct RevealedCardView: View {
    let card: TarotCard
    let position: String
    let delay: Double
    let appeared: Bool

    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "1a2a5e"), Color(hex: "0d1b3e")],
                            startPoint: .top, endPoint: .bottom
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(hex: "c9a227"), lineWidth: 2)
                    )
                    .shadow(color: Color(hex: "c9a227").opacity(0.3), radius: 12)

                Text(card.emoji)
                    .font(.system(size: 32))
            }
            .aspectRatio(2/3, contentMode: .fit)
            .rotation3DEffect(
                .degrees(appeared ? 0 : 90),
                axis: (x: 0, y: 1, z: 0)
            )
            .opacity(appeared ? 1 : 0)
            .animation(
                .spring(response: 0.6, dampingFraction: 0.7).delay(delay),
                value: appeared
            )

            Text(position)
                .font(.custom("Cinzel-Regular", size: 8))
                .kerning(2)
                .foregroundColor(Color(hex: "c9a227"))

            Text(card.name)
                .font(.custom("CrimsonText-Italic", size: 10))
                .foregroundColor(Color(hex: "a08060"))
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
    }
}
