import SwiftUI
import Speech

struct PickCardsView: View {
    @ObservedObject var vm: TarotViewModel
    @State private var isListening = false
    @FocusState private var questionFocused: Bool

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(hex: "0a1428").ignoresSafeArea()
            StarfieldView().ignoresSafeArea()

            VStack(spacing: 0) {
                // Title
                VStack(spacing: 6) {
                    Text("PICK 3 CARDS")
                        .font(.custom("Cinzel-Bold", size: 22))
                        .kerning(4)
                        .foregroundColor(Color(hex: "f0c040"))

                    Text("Choose your card, feel the connection")
                        .font(.custom("CrimsonText-Italic", size: 16))
                        .foregroundColor(Color(hex: "a08060"))
                }
                .padding(.top, 56)

                // Question input
                HStack(spacing: 0) {
                    TextField("Ask your question...", text: $vm.question)
                        .font(.custom("CrimsonText-Italic", size: 16))
                        .foregroundColor(Color(hex: "d4b483"))
                        .tint(Color(hex: "f0c040"))
                        .focused($questionFocused)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)

                    Button {
                        questionFocused = false
                        startVoiceInput()
                    } label: {
                        Image(systemName: isListening ? "mic.fill" : "mic")
                            .font(.system(size: 20))
                            .foregroundColor(isListening ? Color(hex: "f0c040") : Color(hex: "a08060"))
                            .frame(width: 54, height: 54)
                            .background(Color(hex: "1e2d5a").opacity(0.8))
                    }
                }
                .background(Color(hex: "0b163c").opacity(0.75))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(hex: "c9a227").opacity(0.35), lineWidth: 1)
                )
                .padding(.horizontal, 16)
                .padding(.top, 16)

                // Card fan
                CardFanView(vm: vm)
                    .frame(maxWidth: .infinity)
                    .frame(height: UIScreen.main.bounds.height * 0.38)
                    .clipped()

                Spacer()
            }

            // Bottom bar
            VStack(spacing: 8) {
                // Status
                Group {
                    let n = vm.selectedCardIndices.count
                    if n == 3 {
                        HStack(spacing: 4) {
                            Text("3 cards chosen ✦").foregroundColor(Color(hex: "f0c040"))
                            Text("Proceed when ready").foregroundColor(Color(hex: "a08060"))
                        }
                    } else if n == 0 {
                        Text("Tap cards to choose your 3")
                            .foregroundColor(Color(hex: "a08060"))
                    } else {
                        Text("\(n) card\(n > 1 ? "s" : "") chosen — pick \(3 - n) more")
                            .foregroundColor(Color(hex: "a08060"))
                    }
                }
                .font(.custom("CrimsonText-Italic", size: 15))

                Button {
                    vm.proceedToShake()
                } label: {
                    Text("PROCEED TO REVEAL ✦")
                        .font(.custom("Cinzel-Regular", size: 13))
                        .kerning(3)
                        .foregroundColor(Color(hex: "f0c040"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 17)
                        .background(
                            LinearGradient(
                                colors: [Color(hex: "1e2f6a"), Color(hex: "2d4090")],
                                startPoint: .leading, endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(hex: "c9a227").opacity(vm.canProceed ? 0.6 : 0.2), lineWidth: 1.5)
                        )
                        .opacity(vm.canProceed ? 1 : 0.4)
                }
                .disabled(!vm.canProceed)
                .padding(.horizontal, 16)
            }
            .padding(.bottom, 90)
            .background(
                LinearGradient(
                    colors: [Color.clear, Color(hex: "060e20")],
                    startPoint: .top, endPoint: .bottom
                )
                .padding(.top, -30)
            )
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
        .toolbar {
            ToolbarItem(placement: .principal) {
                EmptyView()
            }
        }
        .onTapGesture { questionFocused = false }
    }

    // MARK: - Voice Input
    func startVoiceInput() {
        SFSpeechRecognizer.requestAuthorization { status in
            guard status == .authorized else { return }
        }

        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try? audioSession.setActive(true, options: .notifyOthersOnDeactivation)

        isListening = true
        // After 3 seconds simulate end
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            isListening = false
        }
        // NOTE: Full AVAudioEngine speech-to-text implementation can be added here
        // For now, the mic button activates listening state visually
    }
}

// Needed imports for voice
import AVFoundation
