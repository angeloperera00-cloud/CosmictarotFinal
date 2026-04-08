import SwiftUI

struct ContentView: View {
    @StateObject private var vm = TarotViewModel()

    var body: some View {
        ZStack(alignment: .bottom) {
            LinearGradient(
                colors: [
                    Color.black,
                    Color(hex: "020814"),
                    Color(hex: "07163c")
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            StarfieldView()
                .ignoresSafeArea()
                .allowsHitTesting(false)

            TabContent(vm: vm)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.clear)
                .zIndex(1)

            BottomNavBar(vm: vm)
                .zIndex(2)
        }
        .ignoresSafeArea(edges: .bottom)
        .preferredColorScheme(.dark)
    }
}

// MARK: - Tab Content Router
struct TabContent: View {
    @ObservedObject var vm: TarotViewModel

    var body: some View {
        NavigationStack(path: $vm.navigationPath) {
            Group {
                switch vm.selectedTab {
                case .home:
                    HomeView(vm: vm)
                case .history:
                    HistoryView(vm: vm)
                case .downloads:
                    DownloadsView(vm: vm)
                case .settings:
                    SettingsView(vm: vm)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color.clear)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(for: NavigationRoute.self) { route in
                switch route {
                case .pick:
                    PickCardsView(vm: vm)

                case .shake:
                    ShakeRevealView(vm: vm)

                case .spinReveal:                  // ← NEW
                    SpinRevealView(vm: vm)

                case .reading:
                    ReadingviewNew(vm: vm)
                }
            }
        }
        .background(Color.clear)
        .tint(Color(hex: "f0c040"))
    }
}

// MARK: - Bottom Nav Bar
struct BottomNavBar: View {
    @ObservedObject var vm: TarotViewModel

    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color(hex: "c9a227").opacity(0.18))
                .frame(height: 0.5)

            HStack(spacing: 0) {
                ForEach(AppTab.allCases, id: \.self) { tab in
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            vm.selectedTab = tab
                            vm.navigationPath = []
                        }
                    } label: {
                        VStack(spacing: 5) {
                            Image(systemName: vm.selectedTab == tab
                                  ? tab.activeImage
                                  : tab.systemImage)
                                .font(.system(size: 21, weight: .medium))

                            Text(tab.title)
                                .font(.custom("Cinzel-Regular", size: 9))
                                .kerning(1.1)
                        }
                        .foregroundColor(
                            vm.selectedTab == tab
                            ? Color(hex: "f0c040")
                            : Color(hex: "a08060")
                        )
                        .frame(maxWidth: .infinity)
                        .padding(.top, 10)
                        .padding(.bottom, 18)
                    }
                    .buttonStyle(.plain)
                }
            }
            .background(
                LinearGradient(
                    colors: [
                        Color(hex: "030812").opacity(0.96),
                        Color(hex: "041020").opacity(0.98)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
    }
}

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB,
                  red: Double(r) / 255,
                  green: Double(g) / 255,
                  blue: Double(b) / 255,
                  opacity: Double(a) / 255)
    }
}

#Preview {
    ContentView()
}
