import SwiftUI
import AppKit

struct GameCardView: View {
    let game: Game

    var body: some View {
        VStack(spacing: 8) {
            if let imageName = game.image {
                if imageName.starts(with: "http"), let url = URL(string: imageName) {
                    // Imagen desde URL
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            imageCard(image)
                        default:
                            placeholder
                        }
                    }
                } else {
                    // Imagen desde assets locales
                    if let nsImage = NSImage(named: imageName) {
                        imageCard(Image(nsImage: nsImage))
                    } else {
                        placeholder
                    }
                }
            } else {
                placeholder
            }

            // Título opcional
            Text(game.title)
                .font(.caption)
                .foregroundColor(.white)
                .lineLimit(1)
                .multilineTextAlignment(.center)
        }
        .frame(width: 140, height: 210)
    }

    private func imageCard(_ image: Image) -> some View {
        image
            .resizable()
            .aspectRatio(2/3, contentMode: .fill)
            .frame(width: 140, height: 210)
            .clipped()
            .cornerRadius(12)
            .shadow(radius: 8)
    }

    private var placeholder: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.gray.opacity(0.3))
            .frame(width: 140, height: 210)
            .shadow(radius: 4)
    }
}

