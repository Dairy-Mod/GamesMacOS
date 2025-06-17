import SwiftUI

struct ContentView: View {
    var body: some View {
        let mockGame = Game(
            id: UUID(),
            title: "Xenoblade Chronicles 3",
            desc: "In the war-torn world of Aionios...",
            review: "",
            rating: 9.0,
            releaseDate: Date(),
            developer: "Monolith Soft",
            publisher: "Nintendo",
            platform: ["Nintendo Switch"],
            genres: ["RPG", "Adventure"],
            image: "image"
        )

        GameDetailView(game: mockGame)
            .environmentObject(UserSession.shared)
    }
}





#Preview {
    ContentView()
        .environmentObject(UserSession.shared)
}

