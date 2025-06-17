import Foundation

class MockUserService {
    static let shared = MockUserService()
    
    func fetchUsers() async throws -> [User] {
        return [
            User(id: UUID(), username: "Tester", email: "test@example.com", password: "12345", image: nil)
        ]
    }
}

