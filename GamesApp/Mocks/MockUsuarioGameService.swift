import Foundation

class MockUsuarioGameService {
    static let shared = MockUsuarioGameService()

    func fetchAll(for userId: UUID) async throws -> [UsuarioGame] {
        return [
            UsuarioGame(
                id: UUID(),
                usuarioId: userId,
                juegoId: UUID(uuidString: "AAAAAAAA-AAAA-AAAA-AAAA-AAAAAAAAAAAA")!,
                status: .playing,
                review: "Absolutely loving it!",
                rating: 9.5,
                fechaAgregado: Date()
            )
        ]
    }
}

