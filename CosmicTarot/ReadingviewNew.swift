import SwiftUI

struct ReadingviewNew: View {
    @ObservedObject var vm: TarotViewModel
    @State private var cardsAppeared = false
    @State private var savedToast = false

    private let gold = Color(hex: "e0b24a")
    private let softGold = Color(hex: "c6a06a")
    private let navy = Color(hex: "050e2a")

    let positions = ["PAST", "PRESENT", "FUTURE"]

    var body: some View {
        GeometryReader { geo in
            ZStack {
                CosmicBackgroundView()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {

                        // Back button
                        HStack {
                            Button {
                                vm.navigationPath = []
                            } label: {
                                ZStack {
                                    Circle()
                                        .fill(Color.white.opacity(0.05))
                                        .overlay(Circle().stroke(Color.white.opacity(0.12), lineWidth: 1))
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 20, weight: .medium))
                                        .foregroundColor(.white.opacity(0.95))
                                }
                                .frame(width: 48, height: 48)
                            }
                            .buttonStyle(.plain)
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, geo.safeAreaInsets.top + 8)

                        // Title
                        VStack(spacing: 10) {
                            Text("YOUR READING")
                                .font(.custom("Cinzel-Regular", size: 24))
                                .kerning(6)
                                .foregroundColor(gold)

                            Text("✦  ✦")
                                .foregroundColor(gold.opacity(0.4))
                                .font(.system(size: 14, weight: .thin))
                                .kerning(8)
                        }
                        .padding(.top, 4)
                        .padding(.bottom, 24)

                        // 3 Cards Row
                        HStack(spacing: 12) {
                            ForEach(Array(vm.chosenCards.enumerated()), id: \.offset) { index, card in
                                RevealedCardNewView(
                                    card: card,
                                    position: positions[index],
                                    delay: Double(index) * 0.22,
                                    appeared: cardsAppeared
                                )
                            }
                        }
                        .padding(.horizontal, 20)

                        // Oracle box
                        VStack(alignment: .leading, spacing: 14) {
                            HStack {
                                Rectangle()
                                    .fill(LinearGradient(colors: [.clear, gold.opacity(0.3)], startPoint: .leading, endPoint: .trailing))
                                    .frame(height: 0.5)
                                Text("✦  THE ORACLE SPEAKS  ✦")
                                    .font(.custom("Cinzel-Regular", size: 10))
                                    .kerning(2.5)
                                    .foregroundColor(gold.opacity(0.8))
                                    .fixedSize()
                                Rectangle()
                                    .fill(LinearGradient(colors: [gold.opacity(0.3), .clear], startPoint: .leading, endPoint: .trailing))
                                    .frame(height: 0.5)
                            }

                            if vm.isLoadingReading {
                                HStack(spacing: 10) {
                                    ForEach(0..<3, id: \.self) { i in
                                        Circle()
                                            .fill(gold)
                                            .frame(width: 7, height: 7)
                                            .opacity(0.3)
                                            .animation(
                                                Animation.easeInOut(duration: 0.55)
                                                    .repeatForever(autoreverses: true)
                                                    .delay(Double(i) * 0.18),
                                                value: vm.isLoadingReading
                                            )
                                    }
                                }
                                .padding(.vertical, 16)
                                .frame(maxWidth: .infinity)
                            } else {
                                Text(vm.currentInterpretation)
                                    .font(.system(size: 15, weight: .light))
                                    .foregroundColor(softGold.opacity(0.85))
                                    .lineSpacing(7)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(navy.opacity(0.80))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(gold.opacity(0.22), lineWidth: 1)
                                )
                        )
                        .padding(.horizontal, 20)
                        .padding(.top, 24)

                        // Buttons
                        Button {
                            vm.saveCurrentReading()
                            withAnimation { savedToast = true }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                withAnimation { savedToast = false }
                            }
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "tray.and.arrow.down")
                                    .font(.system(size: 13, weight: .light))
                                Text("DOWNLOAD")
                                    .font(.custom("Cinzel-Regular", size: 11))
                                    .kerning(2)
                            }
                            .foregroundColor(gold)
                            .padding(.vertical, 16)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(navy.opacity(0.85))
                                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(gold.opacity(0.4), lineWidth: 1))
                            )
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        .padding(.bottom, 110)
                    }
                }

                // Save toast
                if savedToast {
                    VStack {
                        Spacer()
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle")
                                .font(.system(size: 14))
                                .foregroundColor(gold)
                            Text("Downloaded ✦")
                                .font(.custom("Cinzel-Regular", size: 12))
                                .kerning(1.5)
                                .foregroundColor(gold)
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 14)
                        .background(
                            Capsule()
                                .fill(navy.opacity(0.96))
                                .overlay(Capsule().stroke(gold.opacity(0.4), lineWidth: 1))
                        )
                        .shadow(color: gold.opacity(0.15), radius: 12)
                        .padding(.bottom, 110)
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .ignoresSafeArea(edges: .top)
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            withAnimation(.spring(response: 0.55, dampingFraction: 0.72).delay(0.1)) {
                cardsAppeared = true
            }
        }
    }
}

// MARK: - Individual Revealed Card
struct RevealedCardNewView: View {
    let card: TarotCard
    let position: String
    let delay: Double
    let appeared: Bool

    private let gold = Color(hex: "e0b24a")
    private let softGold = Color(hex: "c6a06a")
    private let navy = Color(hex: "050e2a")

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                TarotCardImageView(card: card, cornerRadius: 12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                LinearGradient(
                                    colors: [gold.opacity(0.8), gold.opacity(0.3), gold.opacity(0.7)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                    )
                    .shadow(color: gold.opacity(0.2), radius: 10)
            }
            .aspectRatio(2/3, contentMode: .fit)
            .rotation3DEffect(
                .degrees(appeared ? 0 : 90),
                axis: (x: 0, y: 1, z: 0)
            )
            .opacity(appeared ? 1 : 0)
            .animation(
                .spring(response: 0.55, dampingFraction: 0.72).delay(delay),
                value: appeared
            )

            Text(position)
                .font(.custom("Cinzel-Regular", size: 8))
                .kerning(2.5)
                .foregroundColor(gold.opacity(0.7))

            Text(card.name)
                .font(.system(size: 10, weight: .light))
                .foregroundColor(softGold.opacity(0.65))
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
    }
}
