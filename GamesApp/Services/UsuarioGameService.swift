import Foundation

class UsuarioGameService {
    static let shared = UsuarioGameService()
    private let baseURL = "http://159.223.168.6"

    private init() {}

    func fetchAll() async throws -> [UsuarioGame] {
        guard let url = URL(string: "\(baseURL)/usuarioGames") else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResp = response as? HTTPURLResponse, httpResp.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode([UsuarioGame].self, from: data)
    }

    func create(_ entry: UsuarioGame) async throws {
        guard let url = URL(string: "\(baseURL)/usuarioGames") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(entry)

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResp = response as? HTTPURLResponse, (200..<300).contains(httpResp.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }

    func update(_ entry: UsuarioGame) async throws {
        guard let url = URL(string: "\(baseURL)/usuarioGames") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(entry)

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResp = response as? HTTPURLResponse, (200..<300).contains(httpResp.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }

    func delete(id: UUID) async throws {
        guard let url = URL(string: "\(baseURL)/usuarioGames/\(id.uuidString)") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResp = response as? HTTPURLResponse, httpResp.statusCode == 204 else {
            throw URLError(.badServerResponse)
        }
    }
}

