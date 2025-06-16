import SwiftUI

@main
struct GamesAppApp: App {
    @StateObject var session = UserSession.shared
    
    var body: some Scene {
        WindowGroup {
            if session.isLoggedIn {
                ContentView()
                    .environmentObject(session)
            } else {
                LoginView()
                    .environmentObject(session)
            }
        }
    }
}
