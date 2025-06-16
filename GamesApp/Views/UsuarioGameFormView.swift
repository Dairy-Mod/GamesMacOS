import SwiftUI

struct UsuarioGameFormView: View {
    @Environment(\.dismiss) var dismiss

    var game: Game
    var existing: UsuarioGame? = nil

    @State private var status: GameStatus = .backlog
    @State private var review: String = ""
    @State private var rating: Double = 0
    @State private var errorMessage: String?

    var onSave: (() -> Void)?

    var body: some View {
        Form {
            Section(header: Text("Status")) {
                Picker("Status", selection: $status) {
                    ForEach(GameStatus.allCases) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .pickerStyle(.segmented)
            }

            Section(header: Text("Rating")) {
                Stepper(value: $rating, in: 0...10, step: 0.5) {
                    Text("\(rating, specifier: "%.1f") / 10")
                }
            }

            Section(header: Text("Review")) {
                TextEditor(text: $review)
                    .frame(height: 100)
            }

            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }

            Button(existing == nil ? "Add Game" : "Update Game") {
                Task {
                    do {
                        guard let userId = UserSession.shared.currentUser?.id else { return }

                        let usuarioGame = UsuarioGame(
                            id: existing?.id,
                            usuarioId: userId,
                            juegoId: game.id!,
                            status: status,
                            review: review,
                            rating: rating,
                            fechaAgregado: Date()
                        )

                        if existing == nil {
                            try await UsuarioGameService.shared.create(usuarioGame)
                        } else {
                            try await UsuarioGameService.shared.update(usuarioGame)
                        }

                        onSave?()
                        dismiss()
                    } catch {
                        errorMessage = "Failed to save: \(error.localizedDescription)"
                    }
                }
            }
        }
        .navigationTitle(existing == nil ? "Add Game" : "Edit Game")
        .onAppear {
            if let existing = existing {
                self.status = existing.status
                self.review = existing.review ?? ""
                self.rating = existing.rating ?? 0
            }
        }
    }
}
