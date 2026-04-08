import SwiftUI

struct SettingsView: View {
    @ObservedObject var vm: TarotViewModel
    @State private var showClearConfirm = false

    var body: some View {
        ZStack {
            CosmicBackgroundView()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    Text("PREFERENCES")
                        .font(.custom("Cinzel-Regular", size: 22))
                        .kerning(6)
                        .foregroundColor(Color(hex: "e0b24a"))
                        .padding(.top, 56)
                        .padding(.bottom, 8)

                    // Preferences section
                    SettingsSectionBox(title: "PREFERENCES") {
                        SettingsToggleRow(
                            icon: "iphone.radiowaves.left.and.right",
                            label: "Shake Feedbacks",
                            value: $vm.shakeFeedback
                        )
                        Divider().background(Color(hex: "c9a227").opacity(0.1))
                        SettingsToggleRow(
                            icon: "music.note",
                            label: "Music & Effects",
                            value: $vm.musicEnabled
                        )
                        Divider().background(Color(hex: "c9a227").opacity(0.1))
                        SettingsToggleRow(
                            icon: "bell",
                            label: "Notifications",
                            value: $vm.notificationsEnabled
                        )
                    }

                    // Legal & About
                    SettingsSectionBox(title: "LEGAL & ABOUT") {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Cosmic Tarot v1.0")
                                .font(.custom("Cinzel-Regular", size: 12))
                                .foregroundColor(Color(hex: "e0b24a").opacity(0.8))

                            Text("For entertainment purposes only.\nTarot readings are for creative and reflective purposes and are not a substitute for professional advice.")
                                .font(.system(size: 13, weight: .light))
                                .foregroundColor(Color(hex: "c6a06a").opacity(0.6))
                                .lineSpacing(5)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 4)
                    }

                    // Danger zone
                    Button {
                        showClearConfirm = true
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "trash")
                                .font(.system(size: 14, weight: .light))
                                .foregroundColor(Color(hex: "e05a4a"))
                            Text("CLEAN ALL HISTORY")
                                .font(.custom("Cinzel-Regular", size: 12))
                                .kerning(2)
                                .foregroundColor(Color(hex: "e05a4a"))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(hex: "050e2a").opacity(0.85))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color(hex: "e05a4a").opacity(0.45), lineWidth: 1)
                                )
                        )
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 100)
                }
            }
        }
        .navigationBarHidden(true)
        .confirmationDialog(
            "Clear all history?",
            isPresented: $showClearConfirm,
            titleVisibility: .visible
        ) {
            Button("Clear Everything", role: .destructive) {
                vm.clearAllHistory()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will delete all readings and saved files. This cannot be undone.")
        }
    }
}

// MARK: - Settings Section Box
struct SettingsSectionBox<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.custom("Cinzel-Regular", size: 11))
                .kerning(3)
                .foregroundColor(Color(hex: "e0b24a").opacity(0.7))

            content
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(hex: "050e2a").opacity(0.80))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(hex: "e0b24a").opacity(0.25), lineWidth: 1)
        )
        .padding(.horizontal, 16)
    }
}

// MARK: - Toggle Row
struct SettingsToggleRow: View {
    let icon: String
    let label: String
    @Binding var value: Bool

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 17))
                .foregroundColor(Color(hex: "e0b24a").opacity(0.8))
                .frame(width: 24)

            Text(label)
                .font(.custom("Cinzel-Regular", size: 13))
                .foregroundColor(Color(hex: "c6a06a"))

            Spacer()

            Toggle("", isOn: $value)
                .tint(Color(hex: "e0b24a"))
                .labelsHidden()
        }
        .padding(.vertical, 4)
    }
}
