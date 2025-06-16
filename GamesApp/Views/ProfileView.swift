
import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var session: UserSession
    @State private var selectedStatus: GameStatus = .backlog
    @State private var allGames: [Game] = []
    @State private var errorMessage: String? = nil
    @State private var showAlert = false

    var body: some View {
        VStack {
            HStack {
                Text("Welcome, \(session.currentUser?.username ?? "")")
                    .font(.title2)
                    .padding(.leading)
                Spacer()
                Button("Log Out") {
                    session.logout()
                }
                .buttonStyle(.bordered)
                .padding(.trailing)
            }

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
            await loadProfile()
        }
        .alert("Error", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage ?? "Unknown error")
        }
    }

    var filteredGames: [Game] {
        let gameIds = session.usuarioGames
            .filter { $0.status == selectedStatus }
            .map { $0.juegoId }

        return allGames.compactMap { game in
            guard let id = game.id, gameIds.contains(id) else { return nil }
            return game
        }
    }

    func loadProfile() async {
        do {
            let allUsuarioGames = try await UsuarioGameService.shared.fetchAll()
            session.usuarioGames = allUsuarioGames.filter { $0.usuarioId == session.currentUser?.id }

            allGames = try await GameService.shared.fetchGames()
        } catch {
            errorMessage = "Error loading profile: \(error.localizedDescription)"
            showAlert = true
        }
    }
}
