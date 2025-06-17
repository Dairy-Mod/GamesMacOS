import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var session: UserSession
    @State private var selectedFilter: GameStatus? = nil
    @State private var sortByRecent = true

    let filters: [GameStatus?] = [nil, .completed, .playing, .backlog]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Encabezado con título y nombre de usuario
            VStack(alignment: .leading, spacing: 40) {
                Text("BacklogApp")
                    .font(.title.bold())
                    .foregroundColor(.white)
                    

                Text(session.currentUser?.username ?? "User")
                    .font(.title3.bold())
                    .foregroundColor(.white)
            }
            .padding(.horizontal)

            // Filtros + ordenamiento
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

                // Botón de ordenamiento visualmente separado
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

            // Línea divisoria
            Rectangle()
                .fill(Color.white.opacity(0.15))
                .frame(height: 1)
                .padding(.horizontal)

            // Grid de juegos
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

