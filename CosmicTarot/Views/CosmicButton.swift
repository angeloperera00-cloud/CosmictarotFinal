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
                .font(.custom("Cinzel-Regular", size: 13))
                .kerning(2)
                .foregroundColor(textColor)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(background)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(borderColor, lineWidth: 1)
                )
        }
        .shadow(color: shadowColor, radius: 12)
    }

    private var textColor: Color {
        switch style {
        case .primary, .secondary, .danger: return .white
        case .outline: return Color(hex: "c9a227")
        }
    }

    @ViewBuilder
    private var background: some View {
        switch style {
        case .primary:
            LinearGradient(
                colors: [Color(hex: "6b3fa0"), Color(hex: "4a2880")],
                startPoint: .leading, endPoint: .trailing
            )
        case .secondary:
            LinearGradient(
                colors: [Color(hex: "8b5cf6"), Color(hex: "6b3fa0")],
                startPoint: .leading, endPoint: .trailing
            )
        case .outline:
            Color.clear
        case .danger:
            LinearGradient(
                colors: [Color(hex: "c0392b"), Color(hex: "962d22")],
                startPoint: .leading, endPoint: .trailing
            )
        }
    }

    private var borderColor: Color {
        switch style {
        case .primary:   return Color(hex: "8b5cf6")
        case .secondary: return Color(hex: "8b5cf6").opacity(0.6)
        case .outline:   return Color(hex: "c9a227")
        case .danger:    return Color.clear
        }
    }

    private var shadowColor: Color {
        switch style {
        case .primary:   return Color(hex: "6b3fa0").opacity(0.5)
        case .secondary: return Color(hex: "8b5cf6").opacity(0.3)
        case .outline:   return Color.clear
        case .danger:    return Color(hex: "c0392b").opacity(0.3)
        }
    }
}

#Preview {
    VStack(spacing: 12) {
        CosmicButton(title: "PRIMARY BUTTON", style: .primary) {}
        CosmicButton(title: "SECONDARY BUTTON", style: .secondary) {}
        CosmicButton(title: "OUTLINE BUTTON", style: .outline) {}
        CosmicButton(title: "DANGER BUTTON", style: .danger) {}
    }
    .padding()
    .background(Color(hex: "0a1428"))
}
