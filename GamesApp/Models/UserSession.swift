import Foundation
import Combine

class UserSession: ObservableObject {
    static let shared = UserSession()

    @Published var isLoggedIn: Bool = false
    @Published var currentUser: User? = nil
    @Published var usuarioGames: [UsuarioGame] = []
    @Published var games: [Game] = []

    func login(as user: User) {
        self.currentUser = user
        self.isLoggedIn = true

        Task { [weak self] in
            guard let self = self else { return }
            do {
                let allGames = try await GameService.shared.fetchGames()
                let allUsuarioGames = try await UsuarioGameService.shared.fetchAll()

                let userGames = allUsuarioGames.filter { $0.usuarioId == user.id }

                DispatchQueue.main.async {
                    self.games = allGames
                    self.usuarioGames = userGames
                }
            } catch {
                print("Error cargando datos del usuario: \(error)")
            }
        }
    }


    func logout() {
        currentUser = nil
        usuarioGames = []
        games = []
        isLoggedIn = false
    }
}

