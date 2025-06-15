import Foundation
import SwiftUI

class GameService {
    static let shared = GameService()
    private let baseURL = URL(string: "http://your-api-url.com")!

    func fetchGames() async throws -> [Game] {
        let url = baseURL.appendingPathComponent("games")
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode([Game].self, from: data)
    }
}
