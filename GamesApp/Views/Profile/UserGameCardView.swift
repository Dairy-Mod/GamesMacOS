import SwiftUI
import AppKit

struct UserGameCardView: View {
    let game: Game
    let entry: UsuarioGame
    @EnvironmentObject var session: UserSession
    @State private var showConfirmation = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Imagen
            if let imageName = game.image {
                if imageName.starts(with: "http"), let url = URL(string: imageName) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(9/16, contentMode: .fill)
                                .frame(width: 140, height: 180)
                                .clipped()
                                .cornerRadius(12)
                        default:
                            placeholder
                        }
                    }
                } else if let nsImage = NSImage(named: imageName) {
                    Image(nsImage: nsImage)
                        .resizable()
                        .aspectRatio(9/16, contentMode: .fill)
                        .frame(width: 140, height: 180)
                        .clipped()
                        .cornerRadius(12)
                } else {
                    placeholder
                }
            } else {
                placeholder
            }

            // Información del juego
            VStack(alignment: .leading, spacing: 4) {
                Text(game.title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .lineLimit(1)

                if let review = entry.review, !review.isEmpty {
                    Text("💬 \(review)")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }

                if let rating = entry.rating {
                    Text("⭐ \(String(format: "%.1f", rating))/5")
                        .font(.caption)
                        .foregroundColor(.yellow)
                }

                Text("🎮 \(entry.status.rawValue)")
                    .font(.caption2)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(colorForStatus(entry.status))
                    .foregroundColor(.white)
                    .cornerRadius(4)

                Button(role: .destructive) {
                    showConfirmation = true
                } label: {
                    Text("Eliminar")
                        .font(.caption2.bold())
                        .foregroundColor(.red)
                }
                .buttonStyle(.plain)
                .padding(.top, 4)
                .alert("¿Eliminar este juego de tu lista?", isPresented: $showConfirmation) {
                    Button("Eliminar", role: .destructive) {
                        Task {
                            await deleteEntry()
                        }
                    }
                    Button("Cancelar", role: .cancel) {}
                }
            }
            .frame(width: 140, alignment: .leading)
        }
    }

    private var placeholder: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.3))
            .frame(width: 140, height: 180)
            .cornerRadius(12)
    }

    private func colorForStatus(_ status: GameStatus) -> Color {
        switch status {
        case .completed: return .green
        case .playing: return .blue
        case .backlog: return .orange
        }
    }

    private func deleteEntry() async {
        guard let id = entry.id else { return }
        do {
            try await UsuarioGameService.shared.delete(id: id)
            await MainActor.run {
                session.usuarioGames.removeAll { $0.id == id }
            }
        } catch {
            await MainActor.run {
                session.errorMessage = "No se pudo eliminar el juego: \(error.localizedDescription)"
            }
        }
    }
}

