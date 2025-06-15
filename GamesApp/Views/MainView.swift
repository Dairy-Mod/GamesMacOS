import Foundation
import SwiftUI

struct MainView: View {
    @State private var games: [Game] = []
    @State private var searchText: String = ""
    @State private var isLoading = true

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                TextField("Search games...", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                if isLoading {
                    ProgressView("Loading games...")
                        .padding()
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 200), spacing: 16)], spacing: 16) {
                            ForEach(filteredGames) { game in
                                NavigationLink(destination: GameDetailView(game: game)) {
                                    GameCardView(game: game)
                                }
                            }
                        }.padding()
                    }
                }
            }
            .navigationTitle("BacklogApp")
        }
        .task {
            do {
                games = try await GameService.shared.fetchGames()
            } catch {
                print("Failed to fetch games: \(error)")
            }
            isLoading = false
        }
    }

    var filteredGames: [Game] {
        if searchText.isEmpty { return games }
        return games.filter { $0.title.lowercased().contains(searchText.lowercased()) }
    }
}
