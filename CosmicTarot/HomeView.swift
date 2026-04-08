import SwiftUI

struct HomeView: View {
    @ObservedObject var vm: TarotViewModel
    @State private var glowPulse = false
    @State private var orbFloat = false
    @State private var runeRotate = false
    @State private var cardAppeared = false
    @State private var textAppeared = false
    @State private var buttonsAppeared = false

    private let gold = Color(hex: "e0b24a")
    private let softGold = Color(hex: "c6a06a")
    private let dimGold = Color(hex: "8a6a3a")
    private let navyDeep = Color(hex: "060d1a")

    var body: some View {
        GeometryReader { geo in
            let safeTop = geo.safeAreaInsets.top
            let safeBottom = geo.safeAreaInsets.bottom
            let availH = geo.size.height - safeTop - safeBottom - 92 // 92 = tab bar
            let w = geo.size.width

            ZStack {
                CosmicBackgroundView()

                // Ambient glow orbs
                Ellipse()
                    .fill(gold.opacity(0.07))
                    .frame(width: 300, height: 160)
                    .blur(radius: 55)
                    .offset(y: -availH * 0.3)
                    .scaleEffect(glowPulse ? 1.12 : 0.88)
                    .animation(.easeInOut(duration: 4.5).repeatForever(autoreverses: true), value: glowPulse)

                Ellipse()
                    .fill(Color(hex: "2a1a6a").opacity(0.18))
                    .frame(width: 260, height: 120)
                    .blur(radius: 50)
                    .offset(y: availH * 0.3)
                    .scaleEffect(glowPulse ? 0.88 : 1.12)
                    .animation(.easeInOut(duration: 5.5).repeatForever(autoreverses: true), value: glowPulse)

                VStack(spacing: 0) {
                    Spacer().frame(height: safeTop + 10)

                    // ── TITLE ──
                    titleSection(w: w)
                        .opacity(textAppeared ? 1 : 0)
                        .offset(y: textAppeared ? 0 : -12)

                    Spacer().frame(height: availH * 0.03)

                    // ── ORACLE IMAGE CARD ──
                    oracleCard(w: w, availH: availH)

                    Spacer().frame(height: availH * 0.03)

                    // ── DIVIDER ──
                    cosmicDivider
                        .opacity(textAppeared ? 1 : 0)

                    Spacer().frame(height: availH * 0.03)

                    // ── BUTTONS ──
                    actionButtons(w: w)
                        .opacity(buttonsAppeared ? 1 : 0)
                        .offset(y: buttonsAppeared ? 0 : 14)

                    Spacer().frame(height: 92 + safeBottom)
                }
            }
            .ignoresSafeArea(edges: .top)
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            glowPulse = true
            orbFloat = true
            runeRotate = true
            withAnimation(.easeOut(duration: 0.8).delay(0.1)) { cardAppeared = true }
            withAnimation(.easeOut(duration: 0.7).delay(0.3)) { textAppeared = true }
            withAnimation(.easeOut(duration: 0.7).delay(0.55)) { buttonsAppeared = true }
        }
    }

    // MARK: - Title
    private func titleSection(w: CGFloat) -> some View {
        ZStack {
            // Slow rotating ring
            Circle()
                .stroke(
                    AngularGradient(
                        colors: [
                            gold.opacity(0.0),
                            gold.opacity(0.22),
                            gold.opacity(0.0),
                            gold.opacity(0.14),
                            gold.opacity(0.0)
                        ],
                        center: .center
                    ),
                    lineWidth: 1
                )
                .frame(width: 190, height: 190)
                .rotationEffect(.degrees(runeRotate ? 360 : 0))
                .animation(.linear(duration: 28).repeatForever(autoreverses: false), value: runeRotate)

            Circle()
                .stroke(gold.opacity(0.07), lineWidth: 1)
                .frame(width: 152, height: 152)

            VStack(spacing: 5) {
                Text("✦  ✦  ✦")
                    .font(.system(size: 9, weight: .thin))
                    .kerning(6)
                    .foregroundColor(gold.opacity(0.45))

                Text("COSMIC")
                    .font(.custom("Cinzel-Regular", size: 32))
                    .kerning(10)
                    .foregroundColor(gold)
                    .shadow(color: gold.opacity(glowPulse ? 0.45 : 0.15), radius: 14)
                    .animation(.easeInOut(duration: 3.5).repeatForever(autoreverses: true), value: glowPulse)

                Text("TAROT")
                    .font(.custom("Cinzel-Regular", size: 12))
                    .kerning(9)
                    .foregroundColor(softGold.opacity(0.65))
            }
        }
        .frame(height: 190)
    }

    // MARK: - Oracle Card
    private func oracleCard(w: CGFloat, availH: CGFloat) -> some View {
        let cardW = w - 56
        let cardH = availH * 0.44

        return ZStack {
            // Outer pulse ring
            RoundedRectangle(cornerRadius: 26)
                .stroke(gold.opacity(glowPulse ? 0.28 : 0.08), lineWidth: 1.5)
                .frame(width: cardW + 14, height: cardH + 14)
                .blur(radius: 5)
                .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: glowPulse)

            // Card
            RoundedRectangle(cornerRadius: 24)
                .fill(navyDeep.opacity(0.72))
                .frame(width: cardW, height: cardH)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    gold.opacity(0.65),
                                    gold.opacity(0.18),
                                    gold.opacity(0.5),
                                    gold.opacity(0.12),
                                    gold.opacity(0.65)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                )

            VStack(spacing: 0) {
                Image("fortuneTeller")
                    .resizable()
                    .scaledToFill()
                    .frame(width: cardW - 20, height: cardH - 62)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.top, 12)
                    .padding(.horizontal, 10)

                Spacer()

                // Bottom label strip
                VStack(spacing: 3) {
                    Text("THE ORACLE AWAITS")
                        .font(.custom("Cinzel-Regular", size: 10))
                        .kerning(3)
                        .foregroundColor(gold.opacity(0.85))

                    Text("Your destiny lies in the cards")
                        .font(.system(size: 10, weight: .light))
                        .foregroundColor(softGold.opacity(0.5))
                }
                .padding(.bottom, 12)
            }
            .frame(width: cardW, height: cardH)
        }
        .scaleEffect(cardAppeared ? 1 : 0.9)
        .opacity(cardAppeared ? 1 : 0)
    }

    // MARK: - Divider
    private var cosmicDivider: some View {
        HStack(spacing: 10) {
            Rectangle()
                .fill(LinearGradient(colors: [.clear, gold.opacity(0.3)], startPoint: .leading, endPoint: .trailing))
                .frame(height: 0.5)

            Text("✦  CHOOSE YOUR PATH  ✦")
                .font(.custom("Cinzel-Regular", size: 8))
                .kerning(2.5)
                .foregroundColor(dimGold.opacity(0.75))
                .fixedSize()

            Rectangle()
                .fill(LinearGradient(colors: [gold.opacity(0.3), .clear], startPoint: .leading, endPoint: .trailing))
                .frame(height: 0.5)
        }
        .padding(.horizontal, 24)
    }

    // MARK: - Action Buttons
    private func actionButtons(w: CGFloat) -> some View {
        HStack(spacing: 12) {
            // Choose your fate
            Button {
                vm.startReading()
            } label: {
                VStack(spacing: 10) {
                    ZStack {
                        Circle()
                            .fill(gold.opacity(0.08))
                            .frame(width: 44, height: 44)
                            .overlay(
                                Circle().stroke(gold.opacity(0.25), lineWidth: 1)
                            )
                        Image(systemName: "hand.point.up.left")
                            .font(.system(size: 17, weight: .light))
                            .foregroundColor(gold)
                    }

                    VStack(spacing: 3) {
                        Text("CHOOSE")
                            .font(.custom("Cinzel-Regular", size: 10))
                            .kerning(2)
                            .foregroundColor(gold)
                        Text("YOUR FATE")
                            .font(.custom("Cinzel-Regular", size: 10))
                            .kerning(2)
                            .foregroundColor(gold)
                        Text("Pick your cards")
                            .font(.system(size: 9, weight: .light))
                            .foregroundColor(softGold.opacity(0.5))
                            .padding(.top, 1)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(navyDeep.opacity(0.85))
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(gold.opacity(0.35), lineWidth: 1)
                        )
                )
            }
            .buttonStyle(.plain)

            // Cosmos decides
            Button {
                vm.chosenCards = TarotDeck.randomThree()
                vm.question = ""
                vm.navigationPath = [.pick, .shake]
            } label: {
                VStack(spacing: 10) {
                    ZStack {
                        Circle()
                            .fill(gold.opacity(0.08))
                            .frame(width: 44, height: 44)
                            .overlay(
                                Circle().stroke(gold.opacity(0.25), lineWidth: 1)
                            )
                        Image(systemName: "iphone.gen3.radiowaves.left.and.right")
                            .font(.system(size: 17, weight: .light))
                            .foregroundColor(gold)
                    }

                    VStack(spacing: 3) {
                        Text("LET THE")
                            .font(.custom("Cinzel-Regular", size: 10))
                            .kerning(2)
                            .foregroundColor(gold)
                        Text("COSMOS DECIDE")
                            .font(.custom("Cinzel-Regular", size: 10))
                            .kerning(2)
                            .foregroundColor(gold)
                        Text("Cards by destiny")
                            .font(.system(size: 9, weight: .light))
                            .foregroundColor(softGold.opacity(0.5))
                            .padding(.top, 1)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(navyDeep.opacity(0.85))
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(gold.opacity(0.35), lineWidth: 1)
                        )
                )
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    HomeView(vm: TarotViewModel())
        .preferredColorScheme(.dark)
}
