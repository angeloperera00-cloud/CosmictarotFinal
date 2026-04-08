import SwiftUI

struct DownloadsView: View {
    @ObservedObject var vm: TarotViewModel

    var body: some View {
        ZStack {
            Color(hex: "0a1428").ignoresSafeArea()
            StarfieldView().ignoresSafeArea()

            VStack(spacing: 0) {
                Text("SAVED FILES")
                    .font(.custom("Cinzel-Bold", size: 22))
                    .kerning(4)
                    .foregroundColor(Color(hex: "f0c040"))
                    .padding(.top, 56)
                    .padding(.bottom, 24)

                if vm.downloads.isEmpty {
                    Spacer()
                    VStack(spacing: 12) {
                        Text("📂")
                            .font(.system(size: 40))
                            .opacity(0.4)
                        Text("No saved readings")
                            .font(.custom("CrimsonText-Italic", size: 17))
                            .foregroundColor(Color(hex: "a08060"))
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
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "1a2a5e"), Color(hex: "0a1228")],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(hex: "c9a227").opacity(0.4), lineWidth: 1)
                    )
                Text(reading.cards.first?.emoji ?? "🔮")
                    .font(.system(size: 20))
            }
            .frame(width: 44, height: 44)

            // Info
            VStack(alignment: .leading, spacing: 5) {
                Text("Reading — \(reading.shortDate)")
                    .font(.custom("Cinzel-Regular", size: 12))
                    .kerning(0.5)
                    .foregroundColor(Color(hex: "c9a227"))

                Text(reading.question)
                    .font(.custom("CrimsonText-Italic", size: 13))
                    .foregroundColor(Color(hex: "a08060"))
                    .lineLimit(1)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 13))
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
