import SwiftUI

struct SettingsView: View {
    @ObservedObject var vm: TarotViewModel
    @State private var showClearConfirm = false

    var body: some View {
        ZStack {
            Color(hex: "0a1428").ignoresSafeArea()
            StarfieldView().ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    Text("PREFERENCES")
                        .font(.custom("Cinzel-Bold", size: 22))
                        .kerning(4)
                        .foregroundColor(Color(hex: "f0c040"))
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
                                .foregroundColor(Color(hex: "c9a227"))

                            Text("For entertainment purposes only.\nTarot readings are for creative and reflective purposes and are not a substitute for professional advice.")
                                .font(.custom("CrimsonText-Italic", size: 14))
                                .foregroundColor(Color(hex: "a08060"))
                                .lineSpacing(4)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 4)
                    }

                    // Stats
                    SettingsSectionBox(title: "READING STATS") {
                        HStack(spacing: 0) {
                            StatBox(value: "\(vm.history.count)", label: "Total Readings")
                            Divider().background(Color(hex: "c9a227").opacity(0.2))
                            StatBox(value: "\(vm.downloads.count)", label: "Saved Files")
                        }
                    }

                    // Danger zone
                    Button {
                        showClearConfirm = true
                    } label: {
                        Text("CLEAN ALL HISTORY")
                            .font(.custom("Cinzel-Regular", size: 13))
                            .kerning(2)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color(hex: "c0392b"))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 16)

                    Button {
                        vm.selectedTab = .home
                        vm.navigationPath = []
                    } label: {
                        Text("HOME")
                            .font(.custom("Cinzel-Regular", size: 13))
                            .kerning(2)
                            .foregroundColor(Color(hex: "c9a227"))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(hex: "c9a227"), lineWidth: 1)
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
                .font(.custom("Cinzel-Regular", size: 13))
                .kerning(3)
                .foregroundColor(Color(hex: "f0c040"))

            content
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(hex: "0b163c").opacity(0.85))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(hex: "c9a227").opacity(0.4), lineWidth: 1)
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
                .foregroundColor(Color(hex: "c9a227"))
                .frame(width: 24)

            Text(label)
                .font(.custom("CrimsonText-Regular", size: 16))
                .foregroundColor(Color(hex: "d4b483"))

            Spacer()

            Toggle("", isOn: $value)
                .tint(Color(hex: "c9a227"))
                .labelsHidden()
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Stat Box
struct StatBox: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 6) {
            Text(value)
                .font(.custom("Cinzel-Bold", size: 28))
                .foregroundColor(Color(hex: "f0c040"))
            Text(label)
                .font(.custom("CrimsonText-Italic", size: 13))
                .foregroundColor(Color(hex: "a08060"))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }
}
