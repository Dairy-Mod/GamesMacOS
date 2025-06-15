import Foundation

class UsuarioGameService {
    static let shared = UsuarioGameService()
    private let baseURL = URL(string: "http://your-api-url.com")!

    func fetchAll() async throws -> [UsuarioGame] {
        let url = baseURL.appendingPathComponent("usuarioGames")
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode([UsuarioGame].self, from: data)
    }

    func create(_ entry: UsuarioGame) async throws {
        var request = URLRequest(url: baseURL.appendingPathComponent("usuarioGames"))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(entry)
        _ = try await URLSession.shared.data(for: request)
    }

    func update(_ entry: UsuarioGame) async throws {
        var request = URLRequest(url: baseURL.appendingPathComponent("usuarioGames"))
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(entry)
        _ = try await URLSession.shared.data(for: request)
    }

    func delete(id: UUID) async throws {
        var request = URLRequest(url: baseURL.appendingPathComponent("usuarioGames/\(id.uuidString)"))
        request.httpMethod = "DELETE"
        _ = try await URLSession.shared.data(for: request)
    }
}
