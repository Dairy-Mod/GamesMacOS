import Foundation
import SwiftUI

struct MainView: View {
    @State private var games: [Game] = []
    @State private var searchText: String = ""
    @State private var selectedPlatform: String = "All"
    @State private var sortOption: SortOption = .none
    @State private var isLoading = true

    enum SortOption: String, CaseIterable, Identifiable {
        case none = "No Sorting"
        case titleAsc = "Title A-Z"
        case titleDesc = "Title Z-A"
        case ratingDesc = "Top Rated"

        var id: String { self.rawValue }
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
          
                TextField("Search games...", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                HStack {
                    Picker("Platform", selection: $selectedPlatform) {
                        Text("All").tag("All")
                        ForEach(platforms, id: \.self) { platform in
                            Text(platform).tag(platform)
                        }
                    }

                    Picker("Sort by", selection: $sortOption) {
                        ForEach(SortOption.allCases) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                }
                .padding(.horizontal)

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
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Explore Games")
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

    
    var platforms: [String] {
        Array(Set(games.flatMap { $0.platform })).sorted()
    }

    
    var filteredGames: [Game] {
        var result = games

        if !searchText.isEmpty {
            result = result.filter {
                $0.title.localizedCaseInsensitiveContains(searchText)
            }
        }

        if selectedPlatform != "All" {
            result = result.filter { $0.platform.contains(selectedPlatform) }
        }

        switch sortOption {
        case .titleAsc:
            result.sort { $0.title < $1.title }
        case .titleDesc:
            result.sort { $0.title > $1.title }
        case .ratingDesc:
            result.sort { $0.rating > $1.rating }
        case .none:
            break
        }

        return result
    }
}

