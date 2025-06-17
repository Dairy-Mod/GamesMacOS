import SwiftUI
import Foundation

struct GameDetailView: View {
    var game: Game
    @State private var showingLogSheet = false
    @EnvironmentObject var session: UserSession

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let imageUrl = game.image, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { image in
                        image.resizable().scaledToFit()
                    } placeholder: {
                        Rectangle().fill(Color.gray.opacity(0.3))
                    }
                    .frame(height: 200)
                    .cornerRadius(12)
                }

                Text(game.title)
                    .font(.largeTitle).bold()

                Text("by \(game.developer)")
                    .font(.title3).foregroundColor(.secondary)

                Text(game.desc)
                    .font(.body)

                Divider()

                VStack(alignment: .leading, spacing: 8) {
                    Text("Genres:")
                        .font(.headline)
                    WrapHStack(tags: game.genres)

                    Text("Platforms:")
                        .font(.headline)
                    WrapHStack(tags: game.platform)
                }

                Divider()

                Text("Review")
                    .font(.headline)
                Text(game.review)

                if let userId = session.currentUser?.id {
                    NavigationLink("Add to My Games") {
                        UsuarioGameFormView(game: game, onSave: {
                            Task {
                                session.usuarioGames = try await MockUsuarioGameService.shared.fetchAll(for: session.currentUser?.id ?? UUID())
                                    .filter { $0.usuarioId == userId }
                            }
                        })
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top)
                }
            }
            .padding()
        }
        .navigationTitle(game.title)
        .sheet(isPresented: $showingLogSheet) {
            LogGameView(game: game)
        }
    }
}

