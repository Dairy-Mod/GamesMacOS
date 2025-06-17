import SwiftUI
import AppKit

struct GameCardView: View {
    let game: Game

    var body: some View {
        VStack {
            if let imageName = game.image {
                if imageName.starts(with: "http"),
                   let url = URL(string: imageName) {
                    // Imagen desde una URL
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            imageCard(image)
                        case .failure(_), .empty:
                            placeholder
                        @unknown default:
                            placeholder
                        }
                    }
                } else {
                    // Imagen desde assets
                    if let nsImage = NSImage(named: imageName) {
                        imageCard(Image(nsImage: nsImage))
                    } else {
                        placeholder
                    }
                }
            } else {
                placeholder
            }
        }
        .frame(width: 140, height: 210)
    }

    private func imageCard(_ image: Image) -> some View {
        image
            .resizable()
            .aspectRatio(16/9, contentMode: .fill)
            .frame(width: 140, height: 90) // Rectángulo horizontal
            .cornerRadius(12)
            .shadow(radius: 8)
            .clipped()
    }


    private var placeholder: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.3))
            .cornerRadius(12)
            .shadow(radius: 4)
    }
}


