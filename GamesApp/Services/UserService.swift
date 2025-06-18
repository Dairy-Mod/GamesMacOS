import Foundation

class UserService {
    static let shared = UserService()
    private let baseURL = "http://159.223.168.6"

    private init() {}

    func fetchUsers() async throws -> [User] {
        guard let url = URL(string: "\(baseURL)/usuarios") else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResp = response as? HTTPURLResponse, httpResp.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode([User].self, from: data)
    }

    func register(user: User) async throws {
        guard let url = URL(string: "\(baseURL)/usuarios") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(user)

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResp = response as? HTTPURLResponse, (200..<300).contains(httpResp.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }
}

