import SwiftUI
import Foundation

struct GameCardView: View {
    var game: Game

    var body: some View {
        VStack(alignment: .leading) {
            if let imageUrl = game.image, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Rectangle().fill(Color.gray.opacity(0.3))
                }
                .frame(height: 140)
                .clipped()
                .cornerRadius(12)
            }

            Text(game.title)
                .font(.headline)
                .lineLimit(1)

            Text(game.developer)
                .font(.subheadline)
                .foregroundColor(.secondary)

            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                Text(String(format: "%.1f", game.rating))
                    .font(.subheadline)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}
