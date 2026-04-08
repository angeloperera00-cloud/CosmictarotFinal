import SwiftUI

struct CosmicBackgroundView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(hex: "060d1a"),
                    Color(hex: "091525"),
                    Color(hex: "0b1c35")
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            StarfieldView()
                .ignoresSafeArea()
                .allowsHitTesting(false)
        }
    }
}

#Preview {
    CosmicBackgroundView()
}
