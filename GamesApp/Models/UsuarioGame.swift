import Foundation

struct UsuarioGame: Identifiable, Codable {
    var id: UUID?
    var usuarioId: UUID
    var juegoId: UUID
    var status: GameStatus
    var fechaAgregado: Date?
}
