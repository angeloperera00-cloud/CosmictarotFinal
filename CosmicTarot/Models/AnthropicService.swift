import Foundation

// MARK: - Anthropic API Service
// ⚠️ IMPORTANT: Replace "YOUR_API_KEY_HERE" with your actual Anthropic API key
// Get your key at: https://console.anthropic.com
// For production apps, store this in a secure backend — never ship API keys in client apps.

class AnthropicService {
    static let shared = AnthropicService()

    private let apiKey = "YOUR_API_KEY_HERE"
    private let endpoint = URL(string: "https://api.anthropic.com/v1/messages")!
    private let model = "claude-sonnet-4-20250514"

    private init() {}

    // MARK: - Fetch Tarot Reading
    func fetchReading(cards: [TarotCard], question: String) async throws -> String {
        let cardDescriptions = zip(cards, ["PAST", "PRESENT", "FUTURE"]).map { card, position in
            "- \(position): \(card.name) (\(card.keywords))"
        }.joined(separator: "\n")

        let userPrompt = """
        You are a mystical tarot oracle with deep cosmic wisdom. The seeker\(question.isEmpty ? " seeks general guidance" : " asks: \"\(question)\"").

        The three cards drawn are:
        \(cardDescriptions)

        Give a rich, poetic, mystical tarot reading in 3 flowing paragraphs (one per card position: Past, Present, Future). Speak directly to the seeker using "you". Use evocative, cosmic language full of imagery. Keep each paragraph to 2-3 sentences. Maximum 220 words total. Do not use bullet points or headers.
        """

        let body: [String: Any] = [
            "model": model,
            "max_tokens": 1000,
            "messages": [
                ["role": "user", "content": userPrompt]
            ]
        ]

        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw AnthropicError.badResponse
        }

        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let content = json["content"] as? [[String: Any]],
              let firstBlock = content.first,
              let text = firstBlock["text"] as? String else {
            throw AnthropicError.parseError
        }

        return text
    }

    // MARK: - Offline Fallback
    func offlineReading(cards: [TarotCard], question: String) -> String {
        guard cards.count == 3 else { return "The stars await your cards..." }
        return """
        In the realm of what has passed, \(cards[0].name) reveals itself to you — carrying the essence of \(cards[0].keywords). What once was, has shaped the soul that stands at this crossroads today.

        In the fires of the present moment, \(cards[1].name) illuminates your path with radiant clarity. The energy of \(cards[1].keywords) surrounds you now, inviting you to stand firm in who you are becoming.

        As you gaze into the shimmering future, \(cards[2].name) beckons you forward with the promise of \(cards[2].keywords). Trust the ancient stars that guide your journey home — the cosmos has spoken in your favour.
        """
    }
}

enum AnthropicError: LocalizedError {
    case badResponse
    case parseError
    case noAPIKey

    var errorDescription: String? {
        switch self {
        case .badResponse: return "The oracle could not be reached. Please check your API key."
        case .parseError: return "The oracle's message was unclear. Please try again."
        case .noAPIKey: return "No API key configured."
        }
    }
}
