import SwiftUI

struct SpinRevealView: View {
    @ObservedObject var vm: TarotViewModel

    private let gold     = Color(hex: "e0b24a")
    private let softGold = Color(hex: "b58d62")
    private let positions = ["PAST", "PRESENT", "FUTURE"]

    @State private var cardStates: [SpinState]  = [.waiting, .waiting, .waiting]
    @State private var statusText               = "The universe is speaking…"
    @State private var progress: Double         = 0
    @State private var revealedNames: [Bool]    = [false, false, false]
    @State private var revealedKeywords: [Bool] = [false, false, false]

    var body: some View {
        GeometryReader { geo in
            ZStack {
                CosmicBackgroundView()

                VStack(spacing: 0) {

                    Spacer().frame(height: geo.safeAreaInsets.top + 50)

                    // ── Title ──
                    Text("REVEALING")
                        .font(.custom("Cinzel-Regular", size: 26))
                        .kerning(4)
                        .foregroundColor(gold)

                    Text("The universe is speaking…")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(softGold)
                        .padding(.top, 5)

                    Spacer().frame(height: 30)

                    // ── 3 Cards row ──
                    HStack(alignment: .top, spacing: 12) {
                        ForEach(0..<3, id: \.self) { i in
                            VStack(spacing: 10) {
                                SpinningCardView(
                                    card: vm.chosenCards.indices.contains(i) ? vm.chosenCards[i] : nil,
                                    state: cardStates[i]
                                )
                                .frame(width: 100, height: 162)

                                Text(positions[i])
                                    .font(.custom("Cinzel-Regular", size: 9))
                                    .kerning(2)
                                    .foregroundColor(gold.opacity(0.55))
                            }
                        }
                    }
                    .padding(.horizontal, 16)

                    Spacer().frame(height: 30)

                    // ── Card reveal rows — slide in one by one ──
                    VStack(spacing: 0) {
                        ForEach(0..<3, id: \.self) { i in
                            if revealedNames[i], vm.chosenCards.indices.contains(i) {
                                let card = vm.chosenCards[i]

                                VStack(spacing: 0) {
                                    // Divider above first row
                                    if i == 0 {
                                        Rectangle()
                                            .fill(gold.opacity(0.15))
                                            .frame(height: 0.5)
                                    }

                                    HStack(spacing: 14) {
                                        // Card image in circle
                                        TarotCardImageView(card: card, cornerRadius: 26)
                                            .frame(width: 52, height: 52)
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(gold.opacity(0.3), lineWidth: 1))

                                        VStack(alignment: .leading, spacing: 4) {
                                            HStack(spacing: 8) {
                                                Text(positions[i])
                                                    .font(.custom("Cinzel-Regular", size: 9))
                                                    .kerning(1.5)
                                                    .foregroundColor(gold.opacity(0.5))
                                                Text("·")
                                                    .foregroundColor(gold.opacity(0.3))
                                                    .font(.system(size: 10))
                                                Text(card.name)
                                                    .font(.custom("Cinzel-Regular", size: 14))
                                                    .foregroundColor(gold)
                                            }

                                            if revealedKeywords[i] {
                                                Text(card.keywords)
                                                    .font(.system(size: 12))
                                                    .foregroundColor(softGold.opacity(0.85))
                                                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                                            }
                                        }

                                        Spacer()

                                        // Small sparkle
                                        Image(systemName: "sparkle")
                                            .foregroundColor(gold.opacity(0.4))
                                            .font(.system(size: 14))
                                    }
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 14)

                                    Rectangle()
                                        .fill(gold.opacity(0.12))
                                        .frame(height: 0.5)
                                        .padding(.horizontal, 24)
                                }
                                .transition(.opacity.combined(with: .move(edge: .bottom)))
                            }
                        }
                    }
                    .animation(.easeOut(duration: 0.5), value: revealedNames)
                    .animation(.easeOut(duration: 0.4), value: revealedKeywords)

                    Spacer()

                    // ── Status + progress ──
                    VStack(spacing: 14) {
                        Text(statusText)
                            .font(.custom("Cinzel-Regular", size: 13))
                            .foregroundColor(.white.opacity(0.6))
                            .animation(.easeInOut(duration: 0.3), value: statusText)

                        GeometryReader { barGeo in
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(gold.opacity(0.15))
                                    .frame(height: 3)
                                Capsule()
                                    .fill(gold)
                                    .frame(width: barGeo.size.width * progress, height: 3)
                                    .animation(.linear(duration: 9), value: progress)
                            }
                        }
                        .frame(height: 3)
                        .padding(.horizontal, 44)
                    }

                    Spacer().frame(height: geo.safeAreaInsets.bottom + 30)
                }
            }
            .ignoresSafeArea(edges: .top)
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
        .onAppear { startSequence() }
    }

    // MARK: - Sequence

    private func startSequence() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation { progress = 1.0 }
        }

        let labels = [
            "✦ Revealing your past…",
            "✦ Revealing your present…",
            "✦ Revealing your future…"
        ]

        for i in 0..<3 {
            let base = Double(i) * 3.0

            DispatchQueue.main.asyncAfter(deadline: .now() + base) {
                withAnimation { cardStates[i] = .spinning }
                withAnimation(.easeInOut) { statusText = labels[i] }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + base + 1.4) {
                withAnimation { cardStates[i] = .slowing }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + base + 2.1) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.6)) {
                    cardStates[i] = .revealed
                }
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            }
            // Name row slides in
            DispatchQueue.main.asyncAfter(deadline: .now() + base + 2.5) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    revealedNames[i] = true
                }
            }
            // Keywords fade in shortly after
            DispatchQueue.main.asyncAfter(deadline: .now() + base + 3.0) {
                withAnimation { revealedKeywords[i] = true }
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 9.5) {
            withAnimation { statusText = "✨ The cards have spoken" }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 11.0) {
            vm.navigationPath.append(.reading)
        }
    }
}

// MARK: - Spin State
enum SpinState: Equatable {
    case waiting, spinning, slowing, revealed
}

// MARK: - Spinning Card View
struct SpinningCardView: View {
    let card: TarotCard?
    let state: SpinState

    private let gold = Color(hex: "e0b24a")

    // Drive spin with a repeating animation on a dummy value
    @State private var spinAngle: Double = 0   // 0…360, used to derive scaleX
    @State private var scaleY: CGFloat   = 1
    @State private var showFront         = false
    @State private var glowing           = false
    @State private var spinTask: Task<Void, Never>?

    // scaleX derived from spinAngle: cos gives 1→0→-1→0→1
    // We use abs(cos) so the card slams flat at 90° and 270°
    private var scaleX: CGFloat {
        CGFloat(abs(cos(spinAngle * .pi / 180)))
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(LinearGradient(
                    colors: [Color(hex: "1a2a5e"), Color(hex: "0d1b3e")],
                    startPoint: .topLeading, endPoint: .bottomTrailing
                ))

            if !showFront {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(gold.opacity(0.22), lineWidth: 1)
                        .padding(5)
                    Text("✦")
                        .font(.system(size: 26))
                        .foregroundColor(gold)
                }
            }

            if showFront, let card = card {
                TarotCardImageView(card: card, cornerRadius: 10)
            }
        }
        .scaleEffect(x: scaleX, y: scaleY)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(glowing ? gold : gold.opacity(0.55), lineWidth: glowing ? 2.5 : 1.5)
        )
        .shadow(color: glowing ? gold.opacity(0.6) : .clear, radius: 12)
        .onChange(of: state, perform: handleStateChange)
        .onDisappear { spinTask?.cancel() }
    }

    private func handleStateChange(_ newState: SpinState) {
        spinTask?.cancel()
        spinTask = nil

        switch newState {
        case .waiting:
            spinAngle = 0; glowing = false

        case .spinning:
            glowing = true
            startSpinTask(degreesPerTick: 18, tickNanos: 16_000_000) // ~60fps, fast

        case .slowing:
            startSpinTask(degreesPerTick: 6, tickNanos: 30_000_000)  // slower

        case .revealed:
            glowing = false
            // Snap flat, swap face, snap back
            withAnimation(.linear(duration: 0.06)) { spinAngle = 90 }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.07) {
                showFront = true
                withAnimation(.linear(duration: 0.06)) { spinAngle = 0 }
            }
            // Bounce
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.14) {
                withAnimation(.spring(response: 0.28, dampingFraction: 0.45)) { scaleY = 1.1 }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.17) {
                    withAnimation(.spring(response: 0.26, dampingFraction: 0.55)) { scaleY = 1.0 }
                }
            }
        }
    }

    /// Async task loop — runs on main actor, not throttled by run loop mode
    private func startSpinTask(degreesPerTick: Double, tickNanos: UInt64) {
        spinTask = Task { @MainActor in
            while !Task.isCancelled {
                spinAngle = (spinAngle + degreesPerTick).truncatingRemainder(dividingBy: 360)
                try? await Task.sleep(nanoseconds: tickNanos)
            }
        }
    }
}

// MARK: - Preview
struct SpinRevealView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = TarotViewModel()
        vm.chosenCards = Array(TarotDeck.all.prefix(3))
        return SpinRevealView(vm: vm)
            .preferredColorScheme(.dark)
    }
}
