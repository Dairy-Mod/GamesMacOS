import Foundation

class PlatformService {
    static let shared = PlatformService()
    private let baseURL = "http://159.223.168.6"

    private init() {}

    func fetchPlatforms() async throws -> [Platform] {
        guard let url = URL(string: "\(baseURL)/platforms") else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResp = response as? HTTPURLResponse, httpResp.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode([Platform].self, from: data)
    }
}

