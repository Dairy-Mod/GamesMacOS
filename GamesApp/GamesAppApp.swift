//
//  GamesAppApp.swift
//  GamesApp
//
//  Created by FAMILIA AMADOR YNFANTE on 14/06/25.
//

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
