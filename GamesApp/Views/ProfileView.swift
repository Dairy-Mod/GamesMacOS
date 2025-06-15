
import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var session: UserSession
    @State private var selectedStatus: GameStatus = .backlog
    @State private var allGames: [Game] = []

    var body: some View {
        VStack {
            Picker("Status", selection: $selectedStatus) {
                ForEach(GameStatus.allCases) { status in
                    Text(status.rawValue).tag(status)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            List(filteredGames) { game in
                GameCardView(game: game)
            }
        }
        .navigationTitle("My Games")
        .task {
            do {
                session.usuarioGames = try await UsuarioGameService.shared.fetchAll().filter { $0.usuarioId == session.currentUser?.id }
                allGames = try await GameService.shared.fetchGames()
            } catch {
                print("Error loading profile: \(error)")
            }
        }
    }

    var filteredGames: [Game] {
        let gameIds = session.usuarioGames.filter { $0.status == selectedStatus }.map { $0.juegoId }
        return allGames.filter { gameIds.contains($0.id ?? UUID()) }
    }
}
