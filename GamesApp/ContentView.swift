//
//  ContentView.swift
//  GamesApp
//
//  Created by FAMILIA AMADOR YNFANTE on 14/06/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var session: UserSession
    @State private var selection: SidebarItem? = .explore

    enum SidebarItem: Hashable {
        case explore
        case profile
    }

    var body: some View {
        NavigationSplitView {
            List(selection: $selection) {
                NavigationLink(value: SidebarItem.explore) {
                    Label("Explorar", systemImage: "gamecontroller")
                }
                NavigationLink(value: SidebarItem.profile) {
                    Label("Mi Perfil", systemImage: "person.circle")
                }
            }
            .navigationTitle("BacklogApp")
        } detail: {
            switch selection {
            case .explore, .none:
                MainView()
                    .environmentObject(session)
            case .profile:
                ProfileView()
                    .environmentObject(session)
            }
        }
    }
}
