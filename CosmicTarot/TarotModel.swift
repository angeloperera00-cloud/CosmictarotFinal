import Foundation

// MARK: - Tarot Card Model
struct TarotCard: Identifiable, Codable, Equatable {
    let id: UUID
    let name: String
    let imageName: String   // asset name in Assets.xcassets
    let emoji: String       // fallback if image not found
    let keywords: String
    let uprightMeaning: String
    let reversedMeaning: String

    init(name: String, imageName: String, emoji: String, keywords: String, uprightMeaning: String, reversedMeaning: String) {
        self.id = UUID()
        self.name = name
        self.imageName = imageName
        self.emoji = emoji
        self.keywords = keywords
        self.uprightMeaning = uprightMeaning
        self.reversedMeaning = reversedMeaning
    }
}

// MARK: - Reading Model
struct TarotReading: Identifiable, Codable {
    let id: UUID
    let date: Date
    let question: String
    let cards: [TarotCard]
    let interpretation: String
    var isSaved: Bool

    init(question: String, cards: [TarotCard], interpretation: String) {
        self.id = UUID()
        self.date = Date()
        self.question = question
        self.cards = cards
        self.interpretation = interpretation
        self.isSaved = false
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    var shortDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter.string(from: date)
    }
}

// MARK: - App Tab
enum AppTab: Int, CaseIterable {
    case home = 0
    case history
    case downloads
    case settings

    var title: String {
        switch self {
        case .home: return "HOME"
        case .history: return "HISTORY"
        case .downloads: return "DOWNLOADS"
        case .settings: return "SETTINGS"
        }
    }

    var systemImage: String {
        switch self {
        case .home: return "house"
        case .history: return "clock"
        case .downloads: return "tray.and.arrow.down"
        case .settings: return "gearshape"
        }
    }

    var activeImage: String {
        switch self {
        case .home: return "house.fill"
        case .history: return "clock.fill"
        case .downloads: return "tray.and.arrow.down.fill"
        case .settings: return "gearshape.fill"
        }
    }
}

// MARK: - Navigation Flow
enum NavigationRoute: Hashable {
    case pick
    case shake
    case spinReveal
    case reading
}

// MARK: - Full Tarot Deck
struct TarotDeck {
    static let all: [TarotCard] = [
        TarotCard(name: "The Magician", imageName: "The Magician", emoji: "\u{2728}",
                  keywords: "willpower, desire, creation",
                  uprightMeaning: "Willpower, desire, creation, manifestation",
                  reversedMeaning: "Trickery, illusions, out of touch"),
        TarotCard(name: "The High Priestess", imageName: "High_Priestess", emoji: "\u{1F319}",
                  keywords: "intuition, mystery, inner knowledge",
                  uprightMeaning: "Intuition, sacred knowledge, divine feminine",
                  reversedMeaning: "Secrets, disconnected from intuition, withdrawal"),
        TarotCard(name: "The Empress", imageName: "Empress", emoji: "\u{1F33A}",
                  keywords: "fertility, femininity, beauty, nature",
                  uprightMeaning: "Femininity, beauty, nature, abundance, nurturing",
                  reversedMeaning: "Creative block, dependence on others"),
        TarotCard(name: "The Emperor", imageName: "Emperor", emoji: "\u{1F451}",
                  keywords: "authority, structure, control, fatherhood",
                  uprightMeaning: "Authority, establishment, structure, a father figure",
                  reversedMeaning: "Domination, excessive control, rigidity, stubbornness"),
        TarotCard(name: "The Hierophant", imageName: "Hierophant", emoji: "\u{26EA}",
                  keywords: "tradition, conformity, morality",
                  uprightMeaning: "Spiritual wisdom, religious beliefs, conformity, tradition",
                  reversedMeaning: "Personal beliefs, freedom, challenging the status quo"),
        TarotCard(name: "The Lovers", imageName: "Lovers", emoji: "\u{1F49E}",
                  keywords: "love, union, values, choices",
                  uprightMeaning: "Love, harmony, relationships, values alignment",
                  reversedMeaning: "Self-love, disharmony, imbalance, misaligned values"),
        TarotCard(name: "The Chariot", imageName: "Chariot", emoji: "\u{1F3C6}",
                  keywords: "direction, control, willpower",
                  uprightMeaning: "Control, willpower, success, action, determination",
                  reversedMeaning: "Self-discipline, opposition, lack of direction"),
        TarotCard(name: "Strength", imageName: "Strength", emoji: "\u{1F981}",
                  keywords: "strength, courage, patience",
                  uprightMeaning: "Strength, courage, patience, control, compassion",
                  reversedMeaning: "Inner strength, self-doubt, low energy, raw emotion"),
        TarotCard(name: "The Hermit", imageName: "Hermit", emoji: "\u{1F526}",
                  keywords: "inner guidance, solitude, withdrawal",
                  uprightMeaning: "Soul-searching, introspection, being alone, inner guidance",
                  reversedMeaning: "Isolation, loneliness, withdrawal"),
        TarotCard(name: "Wheel of Fortune", imageName: "Wheel_Of_Fortune", emoji: "\u{2638}",
                  keywords: "change, cycles, fate",
                  uprightMeaning: "Good luck, karma, life cycles, destiny, a turning point",
                  reversedMeaning: "Bad luck, resistance to change, breaking cycles"),
        TarotCard(name: "Justice", imageName: "Justice", emoji: "\u{2696}",
                  keywords: "justice, fairness, truth",
                  uprightMeaning: "Justice, fairness, truth, cause and effect, law",
                  reversedMeaning: "Unfairness, lack of accountability, dishonesty"),
        TarotCard(name: "The Hanged Man", imageName: "Hanged_man", emoji: "\u{1F643}",
                  keywords: "suspension, restriction, letting go",
                  uprightMeaning: "Pause, surrender, letting go, new perspectives",
                  reversedMeaning: "Delays, resistance, stalling, indecision"),
        TarotCard(name: "Death", imageName: "Death", emoji: "\u{1F311}",
                  keywords: "endings, beginnings, change, transformation",
                  uprightMeaning: "Endings, change, transformation, transition",
                  reversedMeaning: "Resistance to change, personal transformation, inner purging"),
        TarotCard(name: "The Devil", imageName: "Devil", emoji: "\u{1F517}",
                  keywords: "shadow self, attachment, addiction",
                  uprightMeaning: "Shadow self, attachment, addiction, restriction, sexuality",
                  reversedMeaning: "Releasing limiting beliefs, exploring dark thoughts, detachment"),
        TarotCard(name: "The Tower", imageName: "Tower", emoji: "\u{26A1}",
                  keywords: "sudden change, upheaval, chaos",
                  uprightMeaning: "Sudden change, upheaval, chaos, revelation, awakening",
                  reversedMeaning: "Personal transformation, fear of change, averting disaster"),
        TarotCard(name: "The Star", imageName: "The Star", emoji: "\u{2B50}",
                  keywords: "hope, faith, rejuvenation",
                  uprightMeaning: "Hope, faith, purpose, renewal, spirituality",
                  reversedMeaning: "Lack of faith, despair, self-trust, disconnection"),
        TarotCard(name: "The Moon", imageName: "Moon", emoji: "\u{1F315}",
                  keywords: "illusion, fear, the unconscious",
                  uprightMeaning: "Illusion, fear, the unconscious, intuition, confusion",
                  reversedMeaning: "Release of fear, repressed emotion, inner confusion"),
        TarotCard(name: "The Sun", imageName: "Sun", emoji: "\u{2600}",
                  keywords: "positivity, fun, warmth, success",
                  uprightMeaning: "Positivity, fun, warmth, success, vitality",
                  reversedMeaning: "Inner child, feeling down, overly optimistic"),
        TarotCard(name: "Judgement", imageName: "Judgment", emoji: "\u{1F4EF}",
                  keywords: "reflection, reckoning, awakening",
                  uprightMeaning: "Judgement, rebirth, inner calling, absolution",
                  reversedMeaning: "Self-doubt, inner critic, ignoring the call"),
        TarotCard(name: "The World", imageName: "World", emoji: "\u{1F30D}",
                  keywords: "completion, integration, accomplishment",
                  uprightMeaning: "Completion, integration, accomplishment, travel",
                  reversedMeaning: "Seeking personal closure, short-cuts, delays"),
    ]

    static func shuffled() -> [TarotCard] {
        all.shuffled()
    }

    static func randomThree() -> [TarotCard] {
        Array(all.shuffled().prefix(3))
    }
}
