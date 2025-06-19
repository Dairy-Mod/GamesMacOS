import Foundation
import Combine

@MainActor
class UserSession: ObservableObject {
    static let shared = UserSession()

    @Published var isLoggedIn: Bool = false
    @Published var currentUser: User? = nil
    @Published var usuarioGames: [UsuarioGame] = []
    @Published var games: [Game] = []
    @Published var errorMessage: String? = nil

    func login(as user: User) {
        self.currentUser = user
        self.isLoggedIn = true

        Task {
            do {
                let allGames = try await GameService.shared.fetchGames()
                let allUsuarioGames = try await UsuarioGameService.shared.fetchAll()

                let userGames = allUsuarioGames.filter { $0.usuarioId == user.id }

                self.games = allGames
                self.usuarioGames = userGames
            } catch {
                print("Error cargando datos del usuario: \(error)")
            }
        }
    }
    
    func cargarDatosUsuario() async {
        guard let user = currentUser else { return }

        do {
            let allGames = try await GameService.shared.fetchGames()
            let allUsuarioGames = try await UsuarioGameService.shared.fetchAll()

            let userGames = allUsuarioGames.filter { $0.usuarioId == user.id }

            self.games = allGames
            self.usuarioGames = userGames
        } catch {
            self.errorMessage = "Error recargando datos del usuario: \(error.localizedDescription)"
        }
    }

    func logout() {
        currentUser = nil
        usuarioGames = []
        games = []
        isLoggedIn = false
    }
}

