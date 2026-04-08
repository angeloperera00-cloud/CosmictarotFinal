import SwiftUI
import CoreMotion

struct ShakeRevealView: View {
    @ObservedObject var vm: TarotViewModel
    @State private var cardScale: CGFloat = 1.0
    @State private var cardGlow: Bool = false
    @State private var revealed = false
    @State private var shakeOffset: CGFloat = 0
    @State private var glowPulse = false
    @State private var card1Offset: CGSize = .zero
    @State private var card2Offset: CGSize = .zero
    @State private var card3Offset: CGSize = .zero
    @State private var card1Rotation: Double = -12
    @State private var card2Rotation: Double = 0
    @State private var card3Rotation: Double = 12
    @State private var cardsRevealed = false

    private let motionManager = CMMotionManager()
    private let gold = Color(hex: "e0b24a")
    private let softGold = Color(hex: "c6a06a")
    private let navy = Color(hex: "050e2a")

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                CosmicBackgroundView()

                // Gold ambient glow behind cards
                Ellipse()
                    .fill(gold.opacity(glowPulse ? 0.12 : 0.05))
                    .frame(width: 280, height: 120)
                    .blur(radius: 40)
                    .offset(y: geo.size.height * 0.08)
                    .animation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true), value: glowPulse)

                VStack(spacing: 0) {
                    // Back button
                    HStack {
                        Button {
                            vm.navigationPath = []
                            vm.selectedTab = .home
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
                    VStack(spacing: 6) {
                        Text("SHAKE TO REVEAL")
                            .font(.custom("Cinzel-Regular", size: 24))
                            .kerning(4)
                            .foregroundColor(gold)
                            .multilineTextAlignment(.center)
                            .shadow(color: gold.opacity(glowPulse ? 0.4 : 0.1), radius: 10)
                            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: glowPulse)

                        Text("Shake the phone to unveil your destiny")
                            .font(.custom("Cinzel-Regular", size: 11))
                            .kerning(1)
                            .foregroundColor(softGold.opacity(0.6))
                    }
                    .padding(.top, 8)
                    .padding(.horizontal, 20)

                    // Question input
                    HStack(spacing: 0) {
                        TextField(
                            "",
                            text: Binding(
                                get: { vm.question },
                                set: { vm.question = $0 }
                            ),
                            prompt: Text("Ask your question...")
                                .foregroundColor(.white.opacity(0.3))
                        )
                        .font(.system(size: 15, weight: .light))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .frame(height: 52)

                        Image(systemName: "mic")
                            .font(.system(size: 20, weight: .light))
                            .foregroundColor(softGold)
                            .padding(.trailing, 16)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(navy.opacity(0.6))
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(gold.opacity(0.3), lineWidth: 1)
                            )
                    )
                    .padding(.horizontal, 24)
                    .padding(.top, 16)

                    Spacer()

                    // Stacked cards
                    ZStack {
                        if cardsRevealed {
                            // Spread out 3 cards after reveal
                            if vm.chosenCards.indices.contains(0) {
                                revealedCard(card: vm.chosenCards[0], offset: CGSize(width: -115, height: 25), rotation: -18)
                            }
                            if vm.chosenCards.indices.contains(1) {
                                revealedCard(card: vm.chosenCards[1], offset: CGSize(width: 0, height: -10), rotation: 0)
                            }
                            if vm.chosenCards.indices.contains(2) {
                                revealedCard(card: vm.chosenCards[2], offset: CGSize(width: 115, height: 25), rotation: 18)
                            }
                        } else {
                            // Stacked deck before reveal
                            stackedCard(index: 2, rotation: card3Rotation, offset: card3Offset, opacity: 0.5)
                            stackedCard(index: 1, rotation: card2Rotation * 0.5, offset: card2Offset, opacity: 0.75)
                            stackedCard(index: 0, rotation: card1Rotation * 0, offset: card1Offset, opacity: 1.0)
                        }
                    }
                    .frame(height: 320)
                    .offset(x: shakeOffset, y: -30)

                    // Tap hint
                    if !cardsRevealed {
                        VStack(spacing: 8) {
                            Image(systemName: "iphone.gen3.radiowaves.left.and.right")
                                .font(.system(size: 32, weight: .light))
                                .foregroundColor(gold.opacity(0.8))
                                .rotationEffect(.degrees(glowPulse ? -15 : 15))
                                .animation(.easeInOut(duration: 0.4).repeatForever(autoreverses: true), value: glowPulse)
                            Text("Shake your phone to reveal")
                                .font(.custom("Cinzel-Regular", size: 11))
                                .kerning(2)
                                .foregroundColor(softGold.opacity(0.65))
                        }
                        .padding(.top, 12)
                    } else {
                        Text("Your cards await...")
                            .font(.custom("Cinzel-Regular", size: 11))
                            .kerning(2)
                            .foregroundColor(softGold.opacity(0.65))
                            .padding(.top, 12)
                    }

                    Spacer()
                }

                // Bottom button — only after cards revealed
                if cardsRevealed {
                    VStack {
                        Button {
                            vm.navigationPath = [.reading]
                        } label: {
                            Text("PROCEED TO READING ✦")
                                .font(.custom("Cinzel-Regular", size: 13))
                                .kerning(3)
                                .foregroundColor(gold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(navy.opacity(0.90))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(gold.opacity(0.5), lineWidth: 1.5)
                                        )
                                )
                        }
                        .padding(.horizontal, 24)
                    }
                    .padding(.bottom, 100)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.spring(response: 0.5, dampingFraction: 0.7), value: cardsRevealed)
                }
            }
            .ignoresSafeArea(edges: .top)
        }
        .ignoresSafeArea(.keyboard)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            glowPulse = true
            startShakeDetection()
            // Animate cards floating in stack
            withAnimation(.easeInOut(duration: 2.2).repeatForever(autoreverses: true)) {
                card1Rotation = 2
                card2Rotation = -3
                card3Rotation = 4
            }
        }
        .onDisappear { motionManager.stopAccelerometerUpdates() }
    }

    // MARK: - Stacked Card
    private func stackedCard(index: Int, rotation: Double, offset: CGSize, opacity: Double) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "091525"), Color(hex: "060d1a")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            gold.opacity(cardGlow ? 0.9 : 0.45),
                            lineWidth: cardGlow ? 2 : 1.5
                        )
                )
                .shadow(
                    color: gold.opacity(cardGlow ? 0.35 : 0.1),
                    radius: cardGlow ? 20 : 8
                )

            // Inner border
            RoundedRectangle(cornerRadius: 14)
                .stroke(gold.opacity(0.15), lineWidth: 1)
                .padding(10)

            // Sparkle icon
            Image(systemName: "sparkle")
                .font(.system(size: 32, weight: .thin))
                .foregroundColor(gold.opacity(cardGlow ? 0.9 : 0.5))
                .shadow(color: gold.opacity(0.4), radius: 8)
        }
        .frame(width: 200, height: 300)
        .rotationEffect(.degrees(rotation))
        .offset(CGSize(width: CGFloat(index) * 4, height: CGFloat(index) * -4))
        .opacity(opacity)
        .animation(.easeInOut(duration: 2.2).repeatForever(autoreverses: true), value: rotation)
    }

    // MARK: - Revealed Card
    private func revealedCard(card: TarotCard, offset: CGSize, rotation: Double) -> some View {
        VStack(spacing: 8) {
            TarotCardImageView(card: card, cornerRadius: 16)
                .frame(width: 130, height: 195)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(gold.opacity(0.7), lineWidth: 1.5)
                )
                .shadow(color: gold.opacity(0.25), radius: 12)

            Text(card.name)
                .font(.custom("Cinzel-Regular", size: 9))
                .kerning(1)
                .foregroundColor(softGold.opacity(0.7))
                .multilineTextAlignment(.center)
                .frame(width: 130)
                .lineLimit(2)
        }
        .rotationEffect(.degrees(rotation))
        .offset(offset)
        .transition(.scale(scale: 0.5).combined(with: .opacity))
    }

    // MARK: - Reveal
    func triggerReveal() {
        guard !revealed else {
            if cardsRevealed {
                vm.navigationPath = [.reading]
                vm.fetchReading()
            }
            return
        }
        revealed = true

        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()

        // Shake animation
        withAnimation(.interpolatingSpring(stiffness: 500, damping: 5)) {
            shakeOffset = 14
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.interpolatingSpring(stiffness: 500, damping: 5)) {
                shakeOffset = -14
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.interpolatingSpring(stiffness: 500, damping: 8)) {
                shakeOffset = 0
            }
        }

        withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
            cardScale = 1.08
            cardGlow = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                cardsRevealed = true
            }
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }

        vm.fetchReading()

        // Auto-navigate after 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            vm.navigationPath = [.reading]
        }
    }

    // MARK: - Shake Detection
    func startShakeDetection() {
        guard motionManager.isAccelerometerAvailable else { return }
        motionManager.accelerometerUpdateInterval = 0.1
        var lastX: Double = 0, lastY: Double = 0, lastZ: Double = 0

        motionManager.startAccelerometerUpdates(to: .main) { data, _ in
            guard let data = data else { return }
            let delta = abs(data.acceleration.x - lastX)
                      + abs(data.acceleration.y - lastY)
                      + abs(data.acceleration.z - lastZ)
            lastX = data.acceleration.x
            lastY = data.acceleration.y
            lastZ = data.acceleration.z

            if delta > 3.0 && !revealed {
                DispatchQueue.main.async {
                    if vm.shakeFeedback {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    }
                    triggerReveal()
                }
            }
        }
    }
}

#Preview {
    ShakeRevealView(vm: TarotViewModel())
        .preferredColorScheme(.dark)
}
