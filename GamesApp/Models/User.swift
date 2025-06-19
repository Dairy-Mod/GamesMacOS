import Foundation

struct User: Identifiable, Codable, Hashable {
    var id: UUID
    var username: String
    var email: String
    var password: String
    var image: String?
}

