import SwiftUI

@main
struct GamesAppApp: App {
    @StateObject var session = UserSession.shared

    var body: some Scene {
        WindowGroup {
            // Mostrar directamente MainView para pruebas
            ContentView()
                .environmentObject(session)
        }
    }
}

