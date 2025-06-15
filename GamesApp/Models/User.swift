import Foundation
import SwiftUI

struct User: Identifiable, Codable {
    var id: UUID?
    var username: String
    var email: String
    var password: String
    var image: String?
}
