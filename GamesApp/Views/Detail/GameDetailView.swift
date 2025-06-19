import SwiftUI

struct GameDetailView: View {
    let game: Game
    @EnvironmentObject var session: UserSession

    @State private var status: GameStatus = .backlog

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                ZStack(alignment: .topLeading) {
                    // Imagen de fondo
                    if let imageName = game.image,
                       let url = URL(string: imageName) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: geometry.size.width, height: geometry.size.height)
                                    .clipped()
                                    .blur(radius: 30)
                                    .overlay(Color.black.opacity(0.5))
                            default:
                                EmptyView()
                            }
                        }
                        .ignoresSafeArea()
                    }

                    VStack(alignment: .leading, spacing: 20) {
                        // Encabezado
                        HStack {
                            Text("BacklogApp")
                                .font(.title.bold())
                                .foregroundColor(.white)
                                .padding(.top, 50)

                            Spacer()

                            Text(session.currentUser?.username ?? "")
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(.horizontal)

                        // Información del juego
                        HStack(alignment: .top, spacing: 24) {
                            if let imageName = game.image,
                               let url = URL(string: imageName) {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 150)
                                            .cornerRadius(12)
                                    default:
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.gray.opacity(0.4))
                                            .frame(width: 150, height: 220)
                                    }
                                }
                            }

                            VStack(alignment: .leading, spacing: 8) {
                                Text(game.title)
                                    .font(.title2.bold())
                                    .foregroundColor(.white)

                                Text("Released on \(formattedDate(game.releaseDate)) by \(game.developer), \(game.publisher)")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.7))

                                Text(game.desc)
                                    .font(.body)
                                    .foregroundColor(.white)

                                // Plataformas
                                HStack {
                                    Text("Platforms:")
                                        .foregroundColor(.white.opacity(0.7))
                                    ForEach(game.platform, id: \.self) { platform in
                                        Text(platform)
                                            .font(.caption)
                                            .padding(5)
                                            .background(Color.white.opacity(0.2))
                                            .cornerRadius(6)
                                            .foregroundColor(.white)
                                    }
                                }

                                // Géneros
                                HStack {
                                    Text("Genres:")
                                        .foregroundColor(.white.opacity(0.7))
                                    ForEach(game.genres, id: \.self) { genre in
                                        Text(genre)
                                            .font(.caption)
                                            .padding(5)
                                            .background(Color.white.opacity(0.2))
                                            .cornerRadius(6)
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top)

                        // Log Game
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Your Status:")
                                .foregroundColor(.white.opacity(0.7))

                            Picker("Status", selection: $status) {
                                Text("Backlog").tag(GameStatus.backlog)
                                Text("Playing").tag(GameStatus.playing)
                                Text("Completed").tag(GameStatus.completed)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding(.bottom, 8)

                            Button(action: {
                                logGame()
                            }) {
                                Text("Log Game")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 6)
                                    .background(Color.green.opacity(0.8))
                                    .cornerRadius(6)
                                    .shadow(radius: 2)
                            }
                            .padding(.top, 8)
                        }
                        .padding(.horizontal)

                        Spacer()
                    }
                    .padding(.top, 40)
                }
                .frame(minHeight: geometry.size.height)
            }
        }
    }

    func formattedDate(_ date: Date?) -> String {
        guard let date = date else { return "Unknown" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    func logGame() {
        guard let userId = session.currentUser?.id else {
            print("Falta ID de usuario")
            return
        }

        guard let gameId = game.id else {
            print("Falta ID del juego")
            return
        }

        let nuevoLog = UsuarioGame(
            id: UUID(),
            usuarioId: userId,
            juegoId: gameId,
            status: status,
            fechaAgregado: Date()
        )

        Task {
            do {
                try await UsuarioGameService.shared.create(nuevoLog)
                session.usuarioGames.append(nuevoLog)
                print("Juego registrado correctamente")
            } catch {
                print("Error al registrar juego: \(error)")
            }
        }
    }
}

