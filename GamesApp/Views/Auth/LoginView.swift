import SwiftUI

struct LoginView: View {
    @EnvironmentObject var session: UserSession
    @State private var username: String = ""
    @State private var password: String = ""

    var body: some View {
        ZStack {
            // Fondo degradado
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.2, green: 0.2, blue: 0.5),
                    Color(red: 0.7, green: 0.4, blue: 0.4)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                // TÍTULO
                Text("Log In")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .padding(.bottom, 8)

                // Avatar
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.bottom, 8)

                // Campo de usuario
                HStack {
                    Image(systemName: "person")
                        .foregroundColor(.gray)
                    TextField("Username", text: $username)
                        .textFieldStyle(PlainTextFieldStyle())
                        .foregroundColor(.white)
                }
                .padding()
                .frame(width: 300)
                .background(Color.white.opacity(0.15))
                .cornerRadius(8)

                // Campo de contraseña
                HStack {
                    Image(systemName: "lock")
                        .foregroundColor(.gray)
                    SecureField("Password", text: $password)
                        .textFieldStyle(PlainTextFieldStyle())
                        .foregroundColor(.white)
                }
                .padding()
                .frame(width: 300)
                .background(Color.white.opacity(0.15))
                .cornerRadius(8)

                // Botón LOGIN
                Button(action: {
                    let dummyUser = User(
                        id: UUID(),
                        username: username,
                        email: "",
                        password: "",
                        image: nil
                    )
                    session.login(as: dummyUser)
                }) {
                    Text("LOGIN")
                        .fontWeight(.semibold)
                        .padding()
                        .frame(width: 300)
                        .background(Color.green)
                        .cornerRadius(8)
                        .foregroundColor(.white)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

