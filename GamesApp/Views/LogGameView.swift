import SwiftUI

struct LogGameView: View {
    var game: Game
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var session: UserSession

    @State private var rating: Double = 3
    @State private var review: String = ""
    @State private var status: GameStatus = .backlog

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Rating")) {
                    Slider(value: $rating, in: 0...5, step: 0.5) {
                        Text("Rating")
                    }
                    Text("\(rating, specifier: "%.1f") / 5.0")
                }

                Section(header: Text("Status")) {
                    Picker("Select status", selection: $status) {
                        ForEach(GameStatus.allCases) { s in
                            Text(s.rawValue).tag(s)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }

                Section(header: Text("Review")) {
                    TextEditor(text: $review)
                        .frame(height: 100)
                }
            }
            .navigationTitle("Log Game")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        Task {
                            await saveLog()
                        }
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    func saveLog() async {
        guard let user = session.currentUser, let gameId = game.id else { return }

        let log = UsuarioGame(
            id: nil,
            usuarioId: user.id!,
            juegoId: gameId,
            status: status,
            review: review,
            rating: rating,
            fechaAgregado: Date()
        )

        do {
            try await UsuarioGameService.shared.create(log)
            dismiss()
        } catch {
            print("Error saving log: \(error)")
        }
    }
}
