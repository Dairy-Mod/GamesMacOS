// Views/Main/MainView.swift
import SwiftUI

struct MainView: View {
    @State private var games: [Game] = []
    @State private var searchText: String = ""
    @EnvironmentObject var session: UserSession

    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 20) {
                HeaderView(searchText: $searchText)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Games")
                        .font(.title2.bold())
                        .foregroundColor(.white)

                    Rectangle()
                        .fill(Color.white.opacity(0.6))
                        .frame(height: 1)
                }
                .padding(.horizontal)

                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 140), spacing: 20)], spacing: 20) {
                        ForEach(filteredGames) { game in
                            NavigationLink(destination: GameDetailView(game: game)) {
                                GameCardView(game: game)
                            }
                            .buttonStyle(.plain)
                        }

                    }
                    .padding(.horizontal)
                }

                Spacer()
            }

        }

        .background(
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.12, green: 0.12, blue: 0.12), Color(red: 0.18, green: 0.0, blue: 0.0)]),
                           startPoint: .top,
                           endPoint: .bottom)
                .ignoresSafeArea()
        )
        .task {
            do {
                self.games = try await GameService.shared.fetchGames()
            } catch {
                print("Failed to load games: \(error)")
            }
        }
    }

    var filteredGames: [Game] {
        if searchText.isEmpty { return games }
        return games.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }
}


