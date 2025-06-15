import Foundation
import SwiftUI

class GenreService {
    static let shared = GenreService()
    private let baseURL = URL(string: "http://your-api-url.com")!

    func fetchGenres() async throws -> [Genre] {
        let url = baseURL.appendingPathComponent("genres")
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([Genre].self, from: data)
    }
}
