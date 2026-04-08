import SwiftUI

struct HistoryView: View {
    @ObservedObject var vm: TarotViewModel

    var body: some View {
        ZStack {
            CosmicBackgroundView()

            VStack(spacing: 0) {
                Text("PAST REVEALINGS")
                    .font(.custom("Cinzel-Regular", size: 22))
                    .kerning(6)
                    .foregroundColor(Color(hex: "e0b24a"))
                    .padding(.top, 56)
                    .padding(.bottom, 24)

                if vm.history.isEmpty {
                    Spacer()
                    Text("No readings yet")
                        .font(.custom("Cinzel-Regular", size: 14))
                        .foregroundColor(Color(hex: "c6a06a").opacity(0.5))
                    Spacer()
                } else {
                    List {
                        ForEach(vm.history) { reading in
                            HistoryRowView(reading: reading)
                                .onTapGesture {
                                    vm.selectedTab = .home
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        vm.loadReading(reading)
                                    }
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        withAnimation {
                                            vm.history.removeAll { $0.id == reading.id }
                                        }
                                    } label: {
                                        Image(systemName: "trash")
                                    }
                                    .tint(.red)
                                }
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                        }
                        Color.clear.frame(height: 100).listRowBackground(Color.clear).listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct HistoryRowView: View {
    let reading: TarotReading

    var body: some View {
        HStack(spacing: 14) {
            // Mini cards
            HStack(spacing: -8) {
                ForEach(reading.cards.prefix(3)) { card in
                    TarotCardImageView(card: card, cornerRadius: 4)
                        .frame(width: 30, height: 44)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color(hex: "e0b24a").opacity(0.35), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.3), radius: 2, x: 2)
                }
            }

            // Info
            VStack(alignment: .leading, spacing: 5) {
                Text(reading.shortDate)
                    .font(.custom("Cinzel-Regular", size: 10))
                    .kerning(1)
                    .foregroundColor(Color(hex: "e0b24a").opacity(0.7))

                Text(reading.question)
                    .font(.custom("Cinzel-Regular", size: 13))
                    .foregroundColor(Color(hex: "c6a06a").opacity(0.7))
                    .lineLimit(1)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 12))
                .foregroundColor(Color(hex: "e0b24a").opacity(0.4))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(Color(hex: "050e2a").opacity(0.75))
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color(hex: "e0b24a").opacity(0.18), lineWidth: 1)
        )
    }
}

// MARK: - Preview
struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = TarotViewModel()
        vm.history = [
            TarotReading(question: "What will happen in my future?", cards: Array(TarotDeck.all.prefix(3)), interpretation: "The cosmos speaks..."),
            TarotReading(question: "Will I find love?", cards: Array(TarotDeck.all.prefix(3)), interpretation: "The stars align..."),
            TarotReading(question: "General Reading", cards: Array(TarotDeck.all.prefix(3)), interpretation: "The universe reveals...")
        ]
        return HistoryView(vm: vm)
            .preferredColorScheme(.dark)
    }
}
