import SwiftUI

struct SuccessAlert: Identifiable {
    var id: String { message }
    let message: String
}

struct ProfileView: View {
    @EnvironmentObject var session: UserSession
    @State private var selectedStatus: GameStatus = .backlog
    @State private var allGames: [Game] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var successMessage: SuccessAlert?

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

            if isLoading {
                ProgressView("Loading...")
                    .padding()
            } else {
                List {
                    ForEach(filteredGames) { game in
                        VStack(alignment: .leading) {
                            GameCardView(game: game)

                            HStack {
                                Spacer()
                                Button(role: .destructive) {
                                    Task {
                                        await deleteGame(game)
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                .buttonStyle(.borderedProminent)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }

            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .navigationTitle("My Games")
        .task {
            do {
                let allUsuarioGames = try await UsuarioGameService.shared.fetchAll()
                if let userId = session.currentUser?.id {
                    session.usuarioGames = allUsuarioGames.filter { $0.usuarioId == userId }
                }
                allGames = try await GameService.shared.fetchGames()
            } catch {
                errorMessage = "Failed to load data: \(error.localizedDescription)"
            }
            isLoading = false
        }
        .alert(item: $successMessage) { message in
            Alert(title: Text(message.message))
        }

    }

    var filteredGames: [Game] {
        let gameIds = session.usuarioGames
            .filter { $0.status == selectedStatus }
            .map { $0.juegoId }

        return allGames.filter { gameIds.contains($0.id ?? UUID()) }
    }

    func deleteGame(_ game: Game) async {
        guard let userId = session.currentUser?.id else { return }

        if let toDelete = session.usuarioGames.first(where: {
            $0.juegoId == game.id && $0.usuarioId == userId
        }), let id = toDelete.id {
            do {
                try await UsuarioGameService.shared.delete(id: id)
                session.usuarioGames.removeAll { $0.id == id }
                successMessage = SuccessAlert(message: "Game deleted successfuly")
            } catch {
                errorMessage = "Error deleting game: \(error.localizedDescription)"
            }
        }
    }
}


