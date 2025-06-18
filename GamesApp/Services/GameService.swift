import Foundation

class GameService {
    static let shared = GameService()
    private let baseURL = "http://159.223.168.6"

    private init() {}

    // Obtener todos los juegos
    func fetchGames() async throws -> [Game] {
        guard let url = URL(string: "\(baseURL)/games") else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResp = response as? HTTPURLResponse, httpResp.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode([Game].self, from: data)
    }

    // Crear un juego
    func createGame(_ game: Game) async throws {
        guard let url = URL(string: "\(baseURL)/games") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        request.httpBody = try encoder.encode(game)

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResp = response as? HTTPURLResponse, httpResp.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
    }

    // Actualizar un juego
    func updateGame(_ game: Game) async throws {
        guard let id = game.id else {
            throw URLError(.badURL)
        }

        guard let url = URL(string: "\(baseURL)/games/\(id.uuidString)") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        request.httpBody = try encoder.encode(game)

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResp = response as? HTTPURLResponse, httpResp.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
    }

    // Eliminar un juego
    func deleteGame(id: UUID) async throws {
        guard let url = URL(string: "\(baseURL)/games/\(id.uuidString)") else {
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

