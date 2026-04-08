import SwiftUI

struct HistoryView: View {
    @ObservedObject var vm: TarotViewModel

    var body: some View {
        ZStack {
            Color(hex: "0a1428").ignoresSafeArea()
            StarfieldView().ignoresSafeArea()

            VStack(spacing: 0) {
                Text("PAST REVEALINGS")
                    .font(.custom("Cinzel-Bold", size: 22))
                    .kerning(4)
                    .foregroundColor(Color(hex: "f0c040"))
                    .padding(.top, 56)
                    .padding(.bottom, 24)

                if vm.history.isEmpty {
                    Spacer()
                    Text("No readings yet")
                        .font(.custom("CrimsonText-Italic", size: 17))
                        .foregroundColor(Color(hex: "a08060"))
                    Spacer()
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 10) {
                            ForEach(vm.history) { reading in
                                HistoryRowView(reading: reading)
                                    .onTapGesture {
                                        vm.selectedTab = .home
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                            vm.loadReading(reading)
                                        }
                                    }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 100)
                    }
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
                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(hex: "1a2a5e"))
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color(hex: "c9a227").opacity(0.4), lineWidth: 1)
                            )
                        Text(card.emoji)
                            .font(.system(size: 12))
                    }
                    .frame(width: 30, height: 44)
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 2)
                }
            }

            // Info
            VStack(alignment: .leading, spacing: 5) {
                Text(reading.shortDate)
                    .font(.custom("Cinzel-Regular", size: 10))
                    .kerning(1)
                    .foregroundColor(Color(hex: "c9a227"))

                Text(reading.question)
                    .font(.custom("CrimsonText-Italic", size: 14))
                    .foregroundColor(Color(hex: "a08060"))
                    .lineLimit(1)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 12))
                .foregroundColor(Color(hex: "c9a227").opacity(0.5))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(Color(hex: "0b163c").opacity(0.6))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(hex: "c9a227").opacity(0.2), lineWidth: 1)
        )
    }
}
