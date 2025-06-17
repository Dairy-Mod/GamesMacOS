import SwiftUI

struct HeaderView: View {
    @Binding var searchText: String
    @EnvironmentObject var session: UserSession

    var body: some View {
        ZStack {
            // Imagen de fondo con degradado
            GeometryReader { geometry in
                Image("bannerFinal")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: 200)
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

            // Contenido sobre la imagen
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("BacklogApp")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)

                    Spacer()

                    // Login/Register o Nombre de Usuario
                    if let username = session.currentUser?.username {
                        Text(username)
                            .foregroundColor(.white)
                            .font(.subheadline.bold())
                    } else {
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
                }

                // Barra de búsqueda alineada a la izquierda
                TextField("Search", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(8)
                    .frame(width: 300, height: 36, alignment: .leading)
                    .background(Color.gray.opacity(0.9))
                    .cornerRadius(12)
            }
            .padding(.horizontal, 24)
            .padding(.top, 40)
        }
        .frame(height: 200)
    }
}

