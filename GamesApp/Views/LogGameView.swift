import SwiftUI

struct LogGameView: View {
    var game: Game
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var session: UserSession

    @State private var rating: Double = 3
    @State private var review: String = ""
    @State private var status: GameStatus = .backlog
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Rating")) {
                    Slider(value: $rating, in: 0...10, step: 0.5) {
                        Text("Rating")
                    }
                    Text("\(rating, specifier: "%.1f") / 10")
                }

                Section(header: Text("Status")) {
                    Picker("Select status", selection: $status) {
                        ForEach(GameStatus.allCases) { s in
                            Text(s.rawValue).tag(s)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                Section(header: Text("Review")) {
                    TextEditor(text: $review)
                        .frame(height: 100)
                }

                if let error = errorMessage {
                    Section {
                        Text(error)
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Log '\(game.title)'")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        Task {
                            await saveLog()
                        }
                    }
                    .disabled(review.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
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
            errorMessage = "Failed to save: \(error.localizedDescription)"
        }
    }
}
