import SwiftUI

// MARK: - TarotCardImageView
// Drop this file into your Views folder.
// Use anywhere you want to show a card — it uses the real image if available,
// falls back to emoji if not found in Assets.

struct TarotCardImageView: View {
    let card: TarotCard
    var cornerRadius: CGFloat = 12

    var body: some View {
        Group {
            if let uiImage = UIImage(named: card.imageName) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                // Fallback — dark card with emoji
                ZStack {
                    LinearGradient(
                        colors: [Color(hex: "1a2a5e"), Color(hex: "0d1b3e")],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                    Text(card.emoji)
                        .font(.system(size: 40))
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

// MARK: - Preview
struct TarotCardImageView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(red: 0.02, green: 0.05, blue: 0.1).ignoresSafeArea()
            HStack(spacing: 12) {
                TarotCardImageView(card: TarotDeck.all[1], cornerRadius: 12)
                    .frame(width: 100, height: 160)
                TarotCardImageView(card: TarotDeck.all[8], cornerRadius: 12)
                    .frame(width: 100, height: 160)
                TarotCardImageView(card: TarotDeck.all[16], cornerRadius: 12)
                    .frame(width: 100, height: 160)
            }
        }
        .preferredColorScheme(.dark)
    }
}
