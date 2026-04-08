import SwiftUI
import CoreMotion

struct ShakeRevealView: View {
    @ObservedObject var vm: TarotViewModel
    @State private var cardScale: CGFloat = 1.0
    @State private var cardGlow: Bool = false
    @State private var floatOffset: CGFloat = 0
    @State private var revealed = false

    private let motionManager = CMMotionManager()

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(hex: "0a1428").ignoresSafeArea()
            StarfieldView().ignoresSafeArea()

            VStack(spacing: 0) {
                // Title
                VStack(spacing: 6) {
                    Text("SHAKE PHONE TO REVEAL")
                        .font(.custom("Cinzel-Bold", size: 24))
                        .kerning(3)
                        .foregroundColor(Color(hex: "f0c040"))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .minimumScaleFactor(0.7)

                    Text("Or tap the cards to unveil your destiny")
                        .font(.custom("CrimsonText-Italic", size: 16))
                        .foregroundColor(Color(hex: "a08060"))
                }
                .padding(.top, 56)
                .padding(.horizontal, 20)

                // Question box
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(hex: "0b163c").opacity(0.7))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(hex: "c9a227").opacity(0.35), lineWidth: 1)
                        )
                    Text(vm.question.isEmpty
                         ? "Focus your intention on the cards..."
                         : "\"\(vm.question)\"")
                        .font(.custom("CrimsonText-Italic", size: 17))
                        .foregroundColor(Color(hex: "d4b483"))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                .padding(.top, 18)

                Spacer()

                // Big floating card
                ZStack {
                    RoundedRectangle(cornerRadius: 18)
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "1c2d68"), Color(hex: "0e1a3d"), Color(hex: "0a1228")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(
                                    cardGlow ? Color(hex: "f0c040") : Color(hex: "c9a227").opacity(0.5),
                                    lineWidth: cardGlow ? 2 : 1.5
                                )
                        )
                        .shadow(
                            color: cardGlow
                                ? Color(hex: "c9a227").opacity(0.5)
                                : Color(hex: "6b3fa0").opacity(0.15),
                            radius: cardGlow ? 30 : 20
                        )

                    // Inner border
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(hex: "c9a227").opacity(0.15), lineWidth: 1)
                        .padding(12)

                    Text("🃏")
                        .font(.system(size: 52))
                        .opacity(0.7)
                        .shadow(color: Color(hex: "c9a227").opacity(0.4), radius: 10)
                }
                .frame(width: min(UIScreen.main.bounds.width * 0.62, 240))
                .aspectRatio(2/3, contentMode: .fit)
                .scaleEffect(cardScale)
                .offset(y: floatOffset)
                .onTapGesture { triggerReveal() }
                .animation(
                    Animation.easeInOut(duration: 3.5).repeatForever(autoreverses: true),
                    value: floatOffset
                )
                .onAppear { floatOffset = -10 }

                Text("Tap to reveal your fate")
                    .font(.custom("CrimsonText-Italic", size: 14))
                    .foregroundColor(Color(hex: "a08060"))
                    .padding(.top, 14)
                    .opacity(cardGlow ? 0.5 : 1)
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: cardGlow)

                Spacer()
            }

            // Bottom reveal button
            VStack {
                Button { triggerReveal() } label: {
                    Text("REVEAL THE CARDS ✦")
                        .font(.custom("Cinzel-Regular", size: 13))
                        .kerning(3)
                        .foregroundColor(Color(hex: "f0c040"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 17)
                        .background(
                            LinearGradient(
                                colors: [Color(hex: "1e2f6a"), Color(hex: "2d4090")],
                                startPoint: .leading, endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(hex: "c9a227").opacity(0.55), lineWidth: 1.5)
                        )
                }
                .padding(.horizontal, 16)
            }
            .padding(.bottom, 90)
        }
        .navigationBarBackButtonHidden(false)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { startShakeDetection() }
        .onDisappear { motionManager.stopAccelerometerUpdates() }
    }

    // MARK: - Reveal
    func triggerReveal() {
        guard !revealed else { return }
        revealed = true

        let impact = UIImpactFeedbackGenerator(style: .heavy)
        impact.impactOccurred()

        withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) {
            cardScale = 1.1
            cardGlow = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut(duration: 0.3)) {
                cardScale = 1.0
            }
            vm.revealCards()
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
