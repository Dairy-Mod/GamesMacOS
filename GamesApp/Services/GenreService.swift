import Foundation

class GenreService {
    static let shared = GenreService()
    private let baseURL = "http://159.223.168.6"

    private init() {}

    func fetchGenres() async throws -> [Genre] {
        guard let url = URL(string: "\(baseURL)/genres") else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResp = response as? HTTPURLResponse, httpResp.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode([Genre].self, from: data)
    }
}

