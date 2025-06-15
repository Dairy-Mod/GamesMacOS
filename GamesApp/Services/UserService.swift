import Foundation
import SwiftUI

class UserService {
    static let shared = UserService()
    private let baseURL = URL(string: "http://your-api-url.com")!

    func fetchUsers() async throws -> [User] {
        let url = baseURL.appendingPathComponent("usuarios")
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([User].self, from: data)
    }

    func register(user: User) async throws {
        var request = URLRequest(url: baseURL.appendingPathComponent("usuarios"))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(user)
        _ = try await URLSession.shared.data(for: request)
    }
}
