import Foundation
import Combine

class UserSession: ObservableObject {
    static let shared = UserSession()

    @Published var isLoggedIn: Bool = false
    @Published var currentUser: User? = nil
    @Published var usuarioGames: [UsuarioGame] = []

    func login(as user: User) {
        self.currentUser = user
        self.isLoggedIn = true
    }

    func logout() {
        self.currentUser = nil
        self.usuarioGames = []
        self.isLoggedIn = false
    }
}
