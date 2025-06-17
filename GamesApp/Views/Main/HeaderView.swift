import SwiftUI

struct HeaderView: View {
    @Binding var searchText: String

    var body: some View {
        ZStack {
            // Imagen de fondo con degradado
            GeometryReader { geometry in
                Image("bannerFinal")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: 200)
                    .clipped()
                    .overlay(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.black.opacity(0.4), Color.clear]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            }
            .frame(height: 200)
            .ignoresSafeArea(edges: .top) // Asegura que no se solape con el safe area

            // Contenido del encabezado
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("BacklogApp")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)

                    Spacer()

                    HStack(spacing: 16) {
                        Button("Login") {
                            // Acción de login
                        }
                        .buttonStyle(.plain)
                        .foregroundColor(.white)

                        Button("Register") {
                            // Acción de registro
                        }
                        .buttonStyle(.plain)
                        .foregroundColor(.white)
                    }
                }

                // Barra de búsqueda
                TextField("Search", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(8)
                    .frame(width: 300, height: 36)
                    .background(Color.gray)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 24)
            .padding(.top, 40)
        }
        .frame(height: 200)
    }
}

