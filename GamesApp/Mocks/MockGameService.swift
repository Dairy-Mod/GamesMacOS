import Foundation

class MockGameService {
    static let shared = MockGameService()

    func fetchGames() async throws -> [Game] {
        let mockGames: [Game] = [
            Game(
                id: UUID(),
                title: "Elder Scrolls VI",
                desc: "An epic fantasy open-world RPG.",
                review: "Highly anticipated sequel.",
                rating: 9.5,
                releaseDate: Date(),
                developer: "Bethesda",
                publisher: "Bethesda Softworks",
                platform: ["PC", "Xbox"],
                genres: ["RPG", "Adventure"],
                image: "image"
            ),
            Game(
                id: UUID(),
                title: "Hollow Knight: Silksong",
                desc: "Explore, fight and survive in a hand-drawn world.",
                review: "Challenging and beautifully crafted.",
                rating: 9.0,
                releaseDate: Date(),
                developer: "Team Cherry",
                publisher: "Team Cherry",
                platform: ["PC", "Switch"],
                genres: ["Metroidvania", "Action"],
                image: "image"
            )
        ]
        
        return mockGames
    }
}

