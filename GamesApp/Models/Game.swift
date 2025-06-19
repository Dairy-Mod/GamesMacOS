import Foundation

struct Game: Identifiable, Codable, Hashable {
    var id: UUID?
    var title: String
    var desc: String
    var releaseDate: Date
    var developer: String
    var publisher: String
    var platform: [String]
    var genres: [String]
    var image: String?
}

