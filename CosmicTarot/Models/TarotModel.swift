import Foundation

// MARK: - Tarot Card Model
struct TarotCard: Identifiable, Codable, Equatable {
    let id: UUID
    let name: String
    let emoji: String
    let keywords: String
    let uprightMeaning: String
    let reversedMeaning: String

    init(name: String, emoji: String, keywords: String, uprightMeaning: String, reversedMeaning: String) {
        self.id = UUID()
        self.name = name
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
        case .downloads: return "arrow.down.to.line"
        case .settings: return "gearshape"
        }
    }
}

// MARK: - Navigation Flow
enum NavigationRoute: Hashable {
    case pick
    case shake
    case reading
}

// MARK: - Full Tarot Deck
struct TarotDeck {
    static let all: [TarotCard] = [
        TarotCard(name: "The Fool", emoji: "🌟", keywords: "beginnings, innocence, spontaneity",
                  uprightMeaning: "New beginnings, optimism, trust in life",
                  reversedMeaning: "Recklessness, taken advantage of, inconsideration"),
        TarotCard(name: "The Magician", emoji: "✨", keywords: "willpower, desire, creation",
                  uprightMeaning: "Willpower, desire, creation, manifestation",
                  reversedMeaning: "Trickery, illusions, out of touch"),
        TarotCard(name: "The High Priestess", emoji: "🌙", keywords: "intuition, mystery, inner knowledge",
                  uprightMeaning: "Intuition, sacred knowledge, divine feminine",
                  reversedMeaning: "Secrets, disconnected from intuition, withdrawal"),
        TarotCard(name: "The Empress", emoji: "🌺", keywords: "fertility, femininity, beauty, nature",
                  uprightMeaning: "Femininity, beauty, nature, abundance, nurturing",
                  reversedMeaning: "Creative block, dependence on others"),
        TarotCard(name: "The Emperor", emoji: "👑", keywords: "authority, structure, control, fatherhood",
                  uprightMeaning: "Authority, establishment, structure, a father figure",
                  reversedMeaning: "Domination, excessive control, rigidity, stubbornness"),
        TarotCard(name: "The Hierophant", emoji: "⛪", keywords: "tradition, conformity, morality",
                  uprightMeaning: "Spiritual wisdom, religious beliefs, conformity, tradition",
                  reversedMeaning: "Personal beliefs, freedom, challenging the status quo"),
        TarotCard(name: "The Lovers", emoji: "💞", keywords: "love, union, values, choices",
                  uprightMeaning: "Love, harmony, relationships, values alignment",
                  reversedMeaning: "Self-love, disharmony, imbalance, misaligned values"),
        TarotCard(name: "The Chariot", emoji: "🏆", keywords: "direction, control, willpower",
                  uprightMeaning: "Control, willpower, success, action, determination",
                  reversedMeaning: "Self-discipline, opposition, lack of direction"),
        TarotCard(name: "Strength", emoji: "🦁", keywords: "strength, courage, patience",
                  uprightMeaning: "Strength, courage, patience, control, compassion",
                  reversedMeaning: "Inner strength, self-doubt, low energy, raw emotion"),
        TarotCard(name: "The Hermit", emoji: "🏮", keywords: "inner guidance, solitude, withdrawal",
                  uprightMeaning: "Soul-searching, introspection, being alone, inner guidance",
                  reversedMeaning: "Isolation, loneliness, withdrawal"),
        TarotCard(name: "Wheel of Fortune", emoji: "☸️", keywords: "change, cycles, fate",
                  uprightMeaning: "Good luck, karma, life cycles, destiny, a turning point",
                  reversedMeaning: "Bad luck, resistance to change, breaking cycles"),
        TarotCard(name: "Justice", emoji: "⚖️", keywords: "justice, fairness, truth",
                  uprightMeaning: "Justice, fairness, truth, cause and effect, law",
                  reversedMeaning: "Unfairness, lack of accountability, dishonesty"),
        TarotCard(name: "The Hanged Man", emoji: "🙃", keywords: "suspension, restriction, letting go",
                  uprightMeaning: "Pause, surrender, letting go, new perspectives",
                  reversedMeaning: "Delays, resistance, stalling, indecision"),
        TarotCard(name: "Death", emoji: "🌑", keywords: "endings, beginnings, change, transformation",
                  uprightMeaning: "Endings, change, transformation, transition",
                  reversedMeaning: "Resistance to change, personal transformation, inner purging"),
        TarotCard(name: "Temperance", emoji: "⚗️", keywords: "balance, moderation, patience",
                  uprightMeaning: "Balance, moderation, patience, purpose, meaning",
                  reversedMeaning: "Imbalance, excess, self-healing, re-alignment"),
        TarotCard(name: "The Devil", emoji: "🔗", keywords: "shadow self, attachment, addiction",
                  uprightMeaning: "Shadow self, attachment, addiction, restriction, sexuality",
                  reversedMeaning: "Releasing limiting beliefs, exploring dark thoughts, detachment"),
        TarotCard(name: "The Tower", emoji: "⚡", keywords: "sudden change, upheaval, chaos",
                  uprightMeaning: "Sudden change, upheaval, chaos, revelation, awakening",
                  reversedMeaning: "Personal transformation, fear of change, averting disaster"),
        TarotCard(name: "The Star", emoji: "⭐", keywords: "hope, faith, rejuvenation",
                  uprightMeaning: "Hope, faith, purpose, renewal, spirituality",
                  reversedMeaning: "Lack of faith, despair, self-trust, disconnection"),
        TarotCard(name: "The Moon", emoji: "🌕", keywords: "illusion, fear, the unconscious",
                  uprightMeaning: "Illusion, fear, the unconscious, intuition, confusion",
                  reversedMeaning: "Release of fear, repressed emotion, inner confusion"),
        TarotCard(name: "The Sun", emoji: "☀️", keywords: "positivity, fun, warmth, success",
                  uprightMeaning: "Positivity, fun, warmth, success, vitality",
                  reversedMeaning: "Inner child, feeling down, overly optimistic"),
        TarotCard(name: "Judgement", emoji: "📯", keywords: "reflection, reckoning, awakening",
                  uprightMeaning: "Judgement, rebirth, inner calling, absolution",
                  reversedMeaning: "Self-doubt, inner critic, ignoring the call"),
        TarotCard(name: "The World", emoji: "🌍", keywords: "completion, integration, accomplishment",
                  uprightMeaning: "Completion, integration, accomplishment, travel",
                  reversedMeaning: "Seeking personal closure, short-cuts, delays"),
        TarotCard(name: "Ace of Wands", emoji: "🔥", keywords: "inspiration, potential, new initiative",
                  uprightMeaning: "Inspiration, new opportunities, growth, potential",
                  reversedMeaning: "An emerging idea, lack of direction, distractions"),
        TarotCard(name: "Ace of Cups", emoji: "💧", keywords: "intuition, love, new feelings",
                  uprightMeaning: "Love, new relationships, compassion, creativity",
                  reversedMeaning: "Self-love, intuition, repressed emotions"),
        TarotCard(name: "Ace of Swords", emoji: "⚔️", keywords: "clarity, truth, new ideas",
                  uprightMeaning: "Breakthroughs, new ideas, mental clarity, success",
                  reversedMeaning: "Inner clarity, re-thinking an idea, clouded judgement"),
        TarotCard(name: "Ace of Pentacles", emoji: "🪙", keywords: "abundance, opportunity, prosperity",
                  uprightMeaning: "A new financial or career opportunity, manifestation, abundance",
                  reversedMeaning: "Lost opportunity, missed chance, bad investment"),
        TarotCard(name: "King of Wands", emoji: "🧙", keywords: "natural born leader, vision, entrepreneur",
                  uprightMeaning: "Natural-born leader, vision, entrepreneur, honour",
                  reversedMeaning: "Impulsiveness, haste, ruthless, high expectations"),
        TarotCard(name: "Queen of Cups", emoji: "🌊", keywords: "compassion, calm, comfort",
                  uprightMeaning: "Compassionate, caring, emotionally stable, intuitive",
                  reversedMeaning: "Inner feelings, self-care, self-love, co-dependency"),
        TarotCard(name: "Knight of Swords", emoji: "🗡️", keywords: "ambition, action, fast-thinking",
                  uprightMeaning: "Ambitious, action-oriented, driven to succeed, fast-thinking",
                  reversedMeaning: "Restless, unfocused, impulsive, burn-out"),
        TarotCard(name: "Ten of Pentacles", emoji: "💎", keywords: "wealth, legacy, inheritance",
                  uprightMeaning: "Wealth, financial security, family, long-term success",
                  reversedMeaning: "The dark side of wealth, financial failure or loss"),
    ]

    static func shuffled() -> [TarotCard] {
        all.shuffled()
    }

    static func randomThree() -> [TarotCard] {
        Array(all.shuffled().prefix(3))
    }
}
