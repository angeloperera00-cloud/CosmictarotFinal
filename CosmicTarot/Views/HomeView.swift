import SwiftUI

struct HomeView: View {
    @ObservedObject var vm: TarotViewModel
    @State private var floatOffset: CGFloat = 0

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {

                // Top badge
                Text("✦ COSMIC TAROT ✦")
                    .font(.custom("Cinzel-Regular", size: 11))
                    .kerning(3)
                    .foregroundColor(Color(hex: "f0c040"))
                    .padding(.horizontal, 18)
                    .padding(.vertical, 7)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color(hex: "c9a227").opacity(0.45), lineWidth: 1)
                    )
                    .padding(.top, 60)
                    .padding(.bottom, 20)

                // Oracle image
                oracleImage
                    .offset(y: floatOffset)
                    .animation(
                        Animation.easeInOut(duration: 3).repeatForever(autoreverses: true),
                        value: floatOffset
                    )
                    .onAppear { floatOffset = -8 }

                // Quote
                Text("EMBRACE THE JOURNEY,\nTHE COSMOS ALIGNS FOR YOU")
                    .font(.custom("Cinzel-Regular", size: 13))
                    .kerning(1.5)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(hex: "d4b483"))
                    .lineSpacing(6)
                    .padding(.horizontal, 30)
                    .padding(.top, 24)
                    .padding(.bottom, 30)

                // Buttons — CosmicButton is defined in CosmicButton.swift
                VStack(spacing: 12) {
                    CosmicButton(title: "✦ CLICK TO CHOOSE YOUR FATE ✦",
                                 style: .primary) {
                        vm.startReading()
                    }
                    CosmicButton(title: "✦ CLICK TO LET US CHOOSE FOR YOU ✦",
                                 style: .secondary) {
                        vm.autoChoose()
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 100)
            }
        }
        .navigationBarHidden(true)
    }

    @ViewBuilder
    private var oracleImage: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "1a2a5e"), Color(hex: "0d1b3e")],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(hex: "c9a227"), lineWidth: 2)
                )
                .shadow(color: Color(hex: "c9a227").opacity(0.3), radius: 20)
                .shadow(color: Color(hex: "6b3fa0").opacity(0.2), radius: 40)

            // To use your oracle image:
            // 1. Add it to Assets.xcassets named "oracle"
            // 2. Uncomment Image("oracle") below and delete the VStack placeholder

            // Image("oracle")
            //     .resizable()
            //     .scaledToFill()
            //     .clipShape(RoundedRectangle(cornerRadius: 14))

            VStack(spacing: 12) {
                Text("🔮")
                    .font(.system(size: 60))
                Text("CHOOSE OR SHAKE WILL REVEAL")
                    .font(.custom("Cinzel-Regular", size: 10))
                    .kerning(1.5)
                    .foregroundColor(Color(hex: "c9a227").opacity(0.7))
            }
        }
        .frame(
            width: UIScreen.main.bounds.width * 0.88,
            height: UIScreen.main.bounds.width * 0.88 * 1.25
        )
        .frame(maxWidth: 360)
    }
}

#Preview {
    HomeView(vm: TarotViewModel())
        .background(Color(hex: "0a1428"))
}
