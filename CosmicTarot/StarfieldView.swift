import SwiftUI

struct Star: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var radius: CGFloat
    var opacity: Double
    var speed: Double
}

struct StarfieldView: View {
    @State private var stars: [Star] = []
    @State private var animating = false

    var body: some View {
        GeometryReader { geo in
            Canvas { context, size in
                for star in stars {
                    let rect = CGRect(
                        x: star.x * size.width,
                        y: star.y * size.height,
                        width: star.radius * 2,
                        height: star.radius * 2
                    )
                    context.fill(
                        Path(ellipseIn: rect),
                        with: .color(Color(hex: "c9b664").opacity(star.opacity))
                    )
                }
            }
            .onAppear {
                stars = (0..<150).map { _ in
                    Star(
                        x: CGFloat.random(in: 0...1),
                        y: CGFloat.random(in: 0...1),
                        radius: CGFloat.random(in: 0.5...2),
                        opacity: Double.random(in: 0.2...0.9),
                        speed: Double.random(in: 2...6)
                    )
                }
                animating = true
                animateStars()
            }
        }
    }

    func animateStars() {
        // Twinkle animation using timer
        Timer.scheduledTimer(withTimeInterval: 0.08, repeats: true) { _ in
            for i in stars.indices {
                let delta = Double.random(in: -0.05...0.05)
                stars[i].opacity = max(0.1, min(1.0, stars[i].opacity + delta))
            }
        }
    }
}
