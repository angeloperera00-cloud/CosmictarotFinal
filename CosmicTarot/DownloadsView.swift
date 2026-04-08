import SwiftUI

struct DownloadsView: View {
    @ObservedObject var vm: TarotViewModel

    var body: some View {
        ZStack {
            CosmicBackgroundView()

            VStack(spacing: 0) {
                Text("SAVED FILES")
                    .font(.custom("Cinzel-Regular", size: 22))
                    .kerning(6)
                    .foregroundColor(Color(hex: "e0b24a"))
                    .padding(.top, 56)
                    .padding(.bottom, 24)

                if vm.downloads.isEmpty {
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "folder")
                            .font(.system(size: 40))
                            .foregroundColor(Color(hex: "c6a06a").opacity(0.4))
                        Text("No saved readings")
                            .font(.custom("Cinzel-Regular", size: 14))
                            .foregroundColor(Color(hex: "c6a06a").opacity(0.5))
                    }
                    Spacer()
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 10) {
                            ForEach(vm.downloads) { reading in
                                DownloadRowView(reading: reading)
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

struct DownloadRowView: View {
    let reading: TarotReading

    var body: some View {
        HStack(spacing: 14) {
            // Icon
            Group {
                if let card = reading.cards.first {
                    TarotCardImageView(card: card, cornerRadius: 8)
                        .frame(width: 44, height: 44)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(hex: "e0b24a").opacity(0.35), lineWidth: 1)
                        )
                } else {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(hex: "050e2a"))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(hex: "e0b24a").opacity(0.35), lineWidth: 1)
                        )
                        .frame(width: 44, height: 44)
                }
            }

            // Info
            VStack(alignment: .leading, spacing: 5) {
                Text("Reading — \(reading.shortDate)")
                    .font(.custom("Cinzel-Regular", size: 12))
                    .kerning(0.5)
                    .foregroundColor(Color(hex: "e0b24a").opacity(0.7))

                Text(reading.question)
                    .font(.custom("Cinzel-Regular", size: 13))
                    .foregroundColor(Color(hex: "c6a06a").opacity(0.7))
                    .lineLimit(1)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 13))
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
