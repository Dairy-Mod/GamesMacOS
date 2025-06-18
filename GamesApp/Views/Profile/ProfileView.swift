import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var session: UserSession
    @Environment(\.dismiss) var dismiss
    @Binding var navigateToProfile: Bool
    @State private var selectedFilter: GameStatus? = nil
    @State private var sortByRecent = true

    let filters: [GameStatus?] = [nil, .completed, .playing, .backlog]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Encabezado con botón de volver y título
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.green.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())


                Spacer()
                
                VStack {
                    Text("My Profile")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                    
                    Button(action: {
                        session.logout()
                        navigateToProfile = false
                    }) {
                        Text("Cerrar sesión")
                            .font(.subheadline.bold())
                            .foregroundColor(.red)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.black.opacity(0.1))
                            .cornerRadius(8)
                    }
                    .buttonStyle(.plain)

                }
            
            }
            .padding(.horizontal)


            // Nombre del usuario
            Text(session.currentUser?.username ?? "User")
                .font(.title3.bold())
                .foregroundColor(.blue)
                .padding(.horizontal)
                .bold()

            // Filtros y ordenamiento
            HStack {
                HStack(spacing: 20) {
                    ForEach(filters, id: \.self) { filter in
                        Button(action: {
                            selectedFilter = filter
                        }) {
                            Text(filter?.rawValue ?? "Games")
                                .foregroundColor(.white)
                                .fontWeight(filter == selectedFilter ? .bold : .regular)
                                .padding(.vertical, 4)
                        }
                        .buttonStyle(.plain)
                    }
                }

                Spacer()

                Button(action: {
                    sortByRecent.toggle()
                }) {
                    HStack(spacing: 4) {
                        Text("Sort by:")
                            .foregroundColor(.white)
                        Text(sortByRecent ? "When added" : "Title")
                            .foregroundColor(Color.blue)
                            .underline()
                    }
                    .font(.subheadline)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal)

            Rectangle()
                .fill(Color.white.opacity(0.15))
                .frame(height: 1)
                .padding(.horizontal)

            // Lista de juegos
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 140), spacing: 20)], spacing: 20) {
                    ForEach(filteredGames, id: \.id) { game in
                        GameCardView(game: game)
                    }
                }
                .padding(.horizontal)
            }

            Spacer()
        }
        .padding(.top, 40)
        .background(
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.1, green: 0.1, blue: 0.1), Color(red: 0.18, green: 0.0, blue: 0.0)]),
                           startPoint: .top,
                           endPoint: .bottom)
            .ignoresSafeArea()
        )
        .frame(minWidth: 600, minHeight: 500) // <-- Ajusta tamaño mínimo de la ventana
    }

    var filteredGames: [Game] {
        let userGames = session.usuarioGames
        let filtered = selectedFilter != nil
            ? userGames.filter { $0.status == selectedFilter }
            : userGames

        var sorted = filtered

        if sortByRecent {
            sorted.sort { ($0.fechaAgregado ?? Date()) > ($1.fechaAgregado ?? Date()) }
        } else {
            sorted.sort { a, b in
                let titleA = session.games.first(where: { $0.id == a.juegoId })?.title ?? ""
                let titleB = session.games.first(where: { $0.id == b.juegoId })?.title ?? ""
                return titleA < titleB
            }
        }

        return sorted.compactMap { entry in
            session.games.first { game in
                game.id == entry.juegoId
            }
        }
    }
}

