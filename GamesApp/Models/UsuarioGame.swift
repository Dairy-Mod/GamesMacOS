import Foundation

struct UsuarioGame: Identifiable, Codable {
    var id: UUID?
    var usuarioId: UUID
    var juegoId: UUID
    var status: GameStatus
    var review: String?
    var rating: Double?
    var fechaAgregado: Date?
}
