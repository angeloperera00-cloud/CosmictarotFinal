import SwiftUI
import Combine

@MainActor
class TarotViewModel: ObservableObject {

    // MARK: - Navigation
    @Published var selectedTab: AppTab = .home
    @Published var navigationPath: [NavigationRoute] = []

    // MARK: - Current Session
    @Published var selectedCardIndices: Set<Int> = []
    @Published var question: String = ""
    @Published var chosenCards: [TarotCard] = []
    @Published var currentInterpretation: String = ""
    @Published var isLoadingReading: Bool = false

    // MARK: - Persisted Data
    @Published var history: [TarotReading] = []
    @Published var downloads: [TarotReading] = []

    // MARK: - Settings
    @AppStorage("shakeFeedback") var shakeFeedback: Bool = true
    @AppStorage("musicEnabled") var musicEnabled: Bool = true
    @AppStorage("notificationsEnabled") var notificationsEnabled: Bool = false

    // MARK: - Deck for pick screen (shuffled once per session)
    @Published var deckCards: [TarotCard] = TarotDeck.shuffled()

    private let historyKey = "ct_history_v2"
    private let downloadsKey = "ct_downloads_v2"

    init() {
        loadHistory()
        loadDownloads()
    }

    // MARK: - Navigation helpers
    func startReading() {
        selectedCardIndices = []
        question = ""
        chosenCards = []
        currentInterpretation = ""
        deckCards = TarotDeck.shuffled()
        navigationPath = [.pick]
    }

    func autoChoose() {
        chosenCards = TarotDeck.randomThree()
        question = ""
        navigationPath = [.pick, .shake]
    }

    func proceedToShake() {
        navigationPath = [.pick, .shake]
    }

    func revealCards() {
        // If cards were hand-picked, use those indices; otherwise random
        if selectedCardIndices.count == 3 {
            let indices = Array(selectedCardIndices).sorted()
            chosenCards = indices.map { deckCards[$0 % deckCards.count] }
        } else {
            chosenCards = TarotDeck.randomThree()
        }
        navigationPath = [.pick, .shake, .reading]
        fetchReading()
    }

    // MARK: - Card Selection
    func toggleCard(index: Int) {
        if selectedCardIndices.contains(index) {
            selectedCardIndices.remove(index)
        } else if selectedCardIndices.count < 3 {
            selectedCardIndices.insert(index)
        }
    }

    var canProceed: Bool { selectedCardIndices.count == 3 }

    // MARK: - AI Reading
    func fetchReading() {
        guard !chosenCards.isEmpty else { return }
        isLoadingReading = true
        currentInterpretation = ""

        Task {
            do {
                let text = try await AnthropicService.shared.fetchReading(
                    cards: chosenCards,
                    question: question
                )
                self.currentInterpretation = text
            } catch {
                self.currentInterpretation = AnthropicService.shared.offlineReading(
                    cards: self.chosenCards,
                    question: self.question
                )
            }
            self.isLoadingReading = false
            self.saveToHistory()
        }
    }

    // MARK: - Save / History
    func saveToHistory() {
        guard !chosenCards.isEmpty else { return }
        let reading = TarotReading(
            question: question.isEmpty ? "General Reading" : question,
            cards: chosenCards,
            interpretation: currentInterpretation
        )
        history.insert(reading, at: 0)
        if history.count > 100 { history = Array(history.prefix(100)) }
        persistHistory()
    }

    func saveCurrentReading() {
        guard let latest = history.first else { return }
        var saved = latest
        saved.isSaved = true  // mark it
        if !downloads.contains(where: { $0.id == latest.id }) {
            downloads.insert(latest, at: 0)
            persistDownloads()
        }
    }

    func clearAllHistory() {
        history = []
        downloads = []
        persistHistory()
        persistDownloads()
    }

    func loadReading(_ reading: TarotReading) {
        chosenCards = reading.cards
        question = reading.question
        currentInterpretation = reading.interpretation
        isLoadingReading = false
        navigationPath = [.pick, .shake, .reading]
    }

    // MARK: - Persistence
    private func persistHistory() {
        if let data = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(data, forKey: historyKey)
        }
    }

    private func loadHistory() {
        if let data = UserDefaults.standard.data(forKey: historyKey),
           let decoded = try? JSONDecoder().decode([TarotReading].self, from: data) {
            history = decoded
        }
    }

    private func persistDownloads() {
        if let data = try? JSONEncoder().encode(downloads) {
            UserDefaults.standard.set(data, forKey: downloadsKey)
        }
    }

    private func loadDownloads() {
        if let data = UserDefaults.standard.data(forKey: downloadsKey),
           let decoded = try? JSONDecoder().decode([TarotReading].self, from: data) {
            downloads = decoded
        }
    }
}
