import Foundation

// MARK: - AI Reading Service (Gemini Free API)
class AnthropicService {
    static let shared = AnthropicService()

    // Get your free key at: aistudio.google.com
    private let apiKey = "AIzaSyDILfYxMQKpxM2nJgs08xlOkUasstlbvHo"
    private let model = "gemini-2.0-flash"

    private var endpoint: URL {
        URL(string: "https://generativelanguage.googleapis.com/v1beta/models/\(model):generateContent?key=\(apiKey)")!
    }

    private init() {}

    // MARK: - Fetch Reading
    func fetchReading(cards: [TarotCard], question: String) async throws -> String {
        print("FETCH READING - question: \(question) - cards: \(cards.map { $0.name })")
        let cardDescriptions = cards.map { "- \($0.name): \($0.keywords)" }.joined(separator: "\n")

        let questionContext = question.trimmingCharacters(in: .whitespaces).isEmpty
            ? "The seeker seeks general guidance from the universe."
            : "The seeker asks: \"\(question)\""

        let prompt = """
        You are a mystical tarot oracle with deep cosmic wisdom.

        \(questionContext)

        The three cards drawn are:
        \(cardDescriptions)

        Read all three cards together as one unified answer to the seeker's question. Weave the energy and meaning of all three cards into a single flowing, poetic response that directly answers what they are asking. Speak directly using "you". Use mystical, cosmic language. Write 3 short paragraphs, maximum 200 words. No bullet points, headers, or card name labels.
        """

        let body: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        ["text": prompt]
                    ]
                ]
            ],
            "generationConfig": [
                "maxOutputTokens": 400,
                "temperature": 0.95
            ]
        ]

        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else { throw AnthropicError.badResponse }
        if httpResponse.statusCode != 200 {
            let errorBody = String(data: data, encoding: .utf8) ?? "unknown"
            print("Gemini API error \(httpResponse.statusCode): \(errorBody)")
            throw AnthropicError.badResponse
        }

        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let candidates = json["candidates"] as? [[String: Any]],
              let first = candidates.first,
              let content = first["content"] as? [String: Any],
              let parts = content["parts"] as? [[String: Any]],
              let text = parts.first?["text"] as? String else {
            throw AnthropicError.parseError
        }

        return text
    }

    // MARK: - Offline Fallback
    func offlineReading(cards: [TarotCard], question: String) -> String {
        guard cards.count == 3 else { return "The stars await your cards..." }

        let hasQuestion = !question.trimmingCharacters(in: .whitespaces).isEmpty
        let opener = hasQuestion
            ? "The cosmos has heard your question and drawn three sacred cards to illuminate your path."
            : "The universe has drawn three sacred cards to speak its truth to you."

        let p1 = "\(opener) The energy of \(cards[0].uprightMeaning.lowercased()) flows through this reading, awakening what you may not yet see. You stand at a threshold, and the stars have aligned to guide your next step."

        let p2 = "The forces of \(cards[1].uprightMeaning.lowercased()) surround you now, weaving themselves into the fabric of your reality. Trust the signs that appear — nothing is coincidence when the cosmos speaks. The universe rarely shouts; it whispers through the cards you are drawn to."

        let p3 = "Finally, \(cards[2].uprightMeaning.lowercased()) seals this reading with its wisdom. \(hasQuestion ? "The answer to what you seek lies not outside of you, but within — the cards are merely the mirror." : "Let this truth settle into your heart and guide your choices in the days ahead.") The cosmos has spoken in your favour."

        return "\(p1)\n\n\(p2)\n\n\(p3)"
    }
}

enum AnthropicError: LocalizedError {
    case badResponse
    case parseError

    var errorDescription: String? {
        switch self {
        case .badResponse: return "The oracle could not be reached."
        case .parseError: return "The oracle's message was unclear. Please try again."
        }
    }
}
