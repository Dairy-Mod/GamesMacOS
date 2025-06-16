import SwiftUI

struct LoginView: View {
    @EnvironmentObject var session: UserSession
    @State private var users: [User] = []
    @State private var selectedUser: User?

    var body: some View {
        VStack(spacing: 20) {
            Text("Log In")
                .font(.largeTitle).bold()

            if users.isEmpty {
                ProgressView("Loading users...")
            } else {
                Picker("Select an user", selection: $selectedUser) {
                    ForEach(users) { user in
                        Text(user.username).tag(Optional(user))
                    }
                }
                .pickerStyle(.menu)
                .frame(height: 150)

                Button("Enter") {
                    if let user = selectedUser {
                        session.login(as: user)
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(selectedUser == nil)
            }
        }
        .padding()
        .frame(width: 400, height: 300)
        .onAppear {
            Task {
                do {
                    users = try await UserService.shared.fetchUsers()
                } catch {
                    print("Failed to fetch userss: \(error)")
                }
            }
        }
    }
}
