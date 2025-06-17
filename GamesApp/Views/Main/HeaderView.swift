import SwiftUI

struct HeaderView: View {
    @Binding var searchText: String
    @Binding var showLogin: Bool
    @Binding var showRegister: Bool
    @Binding var navigateToProfile: Bool
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

            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("BacklogApp")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)

                    Spacer()

                    if session.currentUser == nil {
                        HStack(spacing: 12) {
                            Button(action: { showLogin = true }) {
                                Text("Login")
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                            .buttonStyle(.plain)

                            Button(action: { showRegister = true }) {
                                Text("Register")
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                        }
                    } else {
                        Button(action: {
                            navigateToProfile = true
                        }) {
                            Text("Mi perfil: \(session.currentUser?.username ?? "Usuario")")
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .bold()
                        }
                        .buttonStyle(.plain)
                    }
                }

                // Barra de búsqueda
                TextField("Search", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(8)
                    .frame(width: 300, height: 36, alignment: .leading)
                    .background(Color.gray.opacity(1.0))
                    .cornerRadius(12)
            }
            .padding(.horizontal, 24)
            .padding(.top, 40)
        }
        .frame(height: 200)
    }
}

