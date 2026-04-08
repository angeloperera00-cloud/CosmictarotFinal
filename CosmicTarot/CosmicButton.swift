import SwiftUI

// MARK: - Cosmic Button Style
enum CosmicButtonStyle {
    case primary, secondary, outline, danger
}

// MARK: - Cosmic Button
struct CosmicButton: View {
    let title: String
    let style: CosmicButtonStyle
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.custom("Cinzel-Regular", size: 12))
                .kerning(1.6)
                .foregroundColor(textColor)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(background)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(borderColor, lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
        .shadow(color: shadowColor, radius: 10, y: 4)
    }

    private var textColor: Color {
        switch style {
        case .primary, .secondary, .danger:
            return .white
        case .outline:
            return Color(hex: "d8a83c")
        }
    }

    @ViewBuilder
    private var background: some View {
        switch style {
        case .primary:
            LinearGradient(
                colors: [
                    Color(hex: "8a4ff7"),
                    Color(hex: "6d38b5")
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

        case .secondary:
            LinearGradient(
                colors: [
                    Color(hex: "8b5cf6"),
                    Color(hex: "7a3ed0")
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

        case .outline:
            Color.clear

        case .danger:
            LinearGradient(
                colors: [
                    Color(hex: "c0392b"),
                    Color(hex: "962d22")
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
        }
    }

    private var borderColor: Color {
        switch style {
        case .primary, .secondary:
            return Color.white.opacity(0.14)
        case .outline:
            return Color(hex: "d8a83c")
        case .danger:
            return Color.clear
        }
    }

    private var shadowColor: Color {
        switch style {
        case .primary, .secondary:
            return Color(hex: "8b5cf6").opacity(0.28)
        case .outline:
            return Color.clear
        case .danger:
            return Color(hex: "c0392b").opacity(0.25)
        }
    }
}

#Preview {
    VStack(spacing: 12) {
        CosmicButton(title: "CLICK TO CHOOSE YOUR FATE", style: .primary) {}
        CosmicButton(title: "CLICK TO LET US CHOOSE FOR YOU", style: .secondary) {}
        CosmicButton(title: "OUTLINE BUTTON", style: .outline) {}
        CosmicButton(title: "DANGER BUTTON", style: .danger) {}
    }
    .padding()
    .background(
        LinearGradient(
            colors: [
                Color.black,
                Color(hex: "020814"),
                Color(hex: "07163c")
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    )
}
