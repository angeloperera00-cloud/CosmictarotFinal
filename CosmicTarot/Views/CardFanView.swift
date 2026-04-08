import SwiftUI

struct CardFanView: View {
    @ObservedObject var vm: TarotViewModel

    private let cardCount = 20
    private let totalAngle: Double = 150
    private let cardW: CGFloat = 72
    private let cardH: CGFloat = 115

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(0..<cardCount, id: \.self) { index in
                    let angle = angleFor(index: index)
                    let pos = positionFor(index: index, in: geo.size)
                    let isSelected = vm.selectedCardIndices.contains(index)

                    SingleFanCard(
                        isSelected: isSelected,
                        angle: angle
                    )
                    .position(x: pos.x, y: pos.y)
                    .zIndex(isSelected ? Double(index) + 100 : Double(index))
                    .onTapGesture {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.6)) {
                            vm.toggleCard(index: index)
                        }
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()
                    }
                }
            }
        }
    }

    private func angleFor(index: Int) -> Double {
        let start = -totalAngle / 2
        return start + (totalAngle / Double(cardCount - 1)) * Double(index)
    }

    private func positionFor(index: Int, in size: CGSize) -> CGPoint {
        let angle = angleFor(index: index)
        let rad = angle * .pi / 180
        let radius = size.width * 0.62
        let cx = size.width / 2
        let cy = size.height + radius * 0.72

        let x = cx + sin(rad) * radius
        let y = cy - cos(rad) * radius
        return CGPoint(x: x, y: y)
    }
}

struct SingleFanCard: View {
    let isSelected: Bool
    let angle: Double
    @State private var glowPulse: Bool = false

    var body: some View {
        ZStack {
            // Card background
            RoundedRectangle(cornerRadius: 10)
                .fill(
                    LinearGradient(
                        colors: isSelected
                            ? [Color(hex: "2d3f80"), Color(hex: "1a2a5e"), Color(hex: "0e1a3d")]
                            : [Color(hex: "1e2f6a"), Color(hex: "0e1a3d"), Color(hex: "0a1228")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            // Inner border
            RoundedRectangle(cornerRadius: 7)
                .stroke(Color(hex: "c9a227").opacity(0.15), lineWidth: 1)
                .padding(7)

            // Star symbol
            Text("✦")
                .font(.system(size: 18))
                .foregroundColor(Color(hex: "c9a227").opacity(isSelected ? 0.7 : 0.25))

            // Checkmark
            if isSelected {
                VStack {
                    HStack {
                        Spacer()
                        Text("✓")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(Color(hex: "f0c040"))
                            .padding(6)
                    }
                    Spacer()
                }
            }
        }
        .frame(width: 72, height: 115)
        .rotationEffect(.degrees(angle))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(
                    isSelected ? Color(hex: "f0c040") : Color(hex: "c9a227").opacity(0.45),
                    lineWidth: isSelected ? 2 : 1.5
                )
        )
        .shadow(
            color: isSelected ? Color(hex: "f0c040").opacity(glowPulse ? 0.7 : 0.4) : Color.black.opacity(0.5),
            radius: isSelected ? 14 : 5
        )
        .scaleEffect(isSelected ? 1.06 : 1.0)
        .onAppear {
            if isSelected {
                withAnimation(Animation.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                    glowPulse = true
                }
            }
        }
        .onChange(of: isSelected) { newVal in
            if newVal {
                withAnimation(Animation.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                    glowPulse = true
                }
            } else {
                glowPulse = false
            }
        }
    }
}
