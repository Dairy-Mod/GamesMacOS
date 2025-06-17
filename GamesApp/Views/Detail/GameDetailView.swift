import SwiftUI

struct GameDetailView: View {
    let game: Game
    @EnvironmentObject var session: UserSession

    @State private var userReview: String = ""
    @State private var userRating: Int = 0
    @State private var status: GameStatus = .backlog

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                ZStack(alignment: .topLeading) {
                    // Fondo con imagen borrosa
                    if let imageName = game.image,
                       let nsImage = NSImage(named: imageName) {
                        Image(nsImage: nsImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipped()
                            .blur(radius: 30)
                            .overlay(Color.black.opacity(0.5))
                            .ignoresSafeArea()
                    }

                    VStack(alignment: .leading, spacing: 20) {
                        // Header
                        HStack {
                            Text("BacklogApp")
                                .font(.title.bold())
                                .foregroundColor(.white)
                                .padding(.top,50)

                            Spacer()

                            Text(session.currentUser?.username ?? "")
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(.horizontal)

                        // Info del juego
                        HStack(alignment: .top, spacing: 24) {
                            if let imageName = game.image,
                               let nsImage = NSImage(named: imageName) {
                                Image(nsImage: nsImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 150)
                                    .cornerRadius(12)
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
                        HStack(spacing: 16) {
                            Button(action: {
                                // Acción
                            }) {
                                Text("Log Game")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 6)
                                    .background(Color.blue.opacity(0.8))
                                    .cornerRadius(6)
                                    .shadow(radius: 2)
                            }
                            .buttonStyle(.plain)


                            HStack(spacing: 4) {
                                ForEach(1...5, id: \.self) { index in
                                    Image(systemName: index <= userRating ? "star.fill" : "star")
                                        .foregroundColor(.yellow)
                                        .onTapGesture {
                                            userRating = index
                                        }
                                }
                            }
                        }
                        .padding(.horizontal)

                        // Review
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Review:")
                                .foregroundColor(.white.opacity(0.7))

                            ZStack(alignment: .leading) {
                                if userReview.isEmpty {
                                    Text("Write your review...")
                                        .foregroundColor(.white.opacity(0.5))
                                        .padding(10)
                                }

                                TextField("", text: $userReview)
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                                    .textFieldStyle(PlainTextFieldStyle())
                            }

                            // Botón para enviar la reseña
                            Button(action: {
                                // Acción: aquí podrías enviar la reseña a una API en el futuro
                                print("Review guardada: \(userReview) con rating: \(userRating)")
                                userReview = "" // Limpia el campo tras enviar
                            }) {
                                Text("Submit Review")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 6)
                                    .background(Color.green.opacity(0.8))
                                    .cornerRadius(6)
                                    .shadow(radius: 2)
                            }
                            .buttonStyle(.plain)
                            .padding(.top, 16)
                        }
                        .padding(.horizontal)

                        Spacer()
                    }
                    .padding(.top, 40)
                }
                .frame(minHeight: geometry.size.height)
            }
            .ignoresSafeArea()
        }
    }

    func formattedDate(_ date: Date?) -> String {
        guard let date = date else { return "Unknown" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

