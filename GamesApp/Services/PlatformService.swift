import Foundation
import SwiftUI

class PlatformService {
    static let shared = PlatformService()
    private let baseURL = URL(string: "http://your-api-url.com")!

    func fetchPlatforms() async throws -> [Platform] {
        let url = baseURL.appendingPathComponent("platforms")
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([Platform].self, from: data)
    }
}
