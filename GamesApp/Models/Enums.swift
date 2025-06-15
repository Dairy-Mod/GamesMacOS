import Foundation
import SwiftUI

enum GameStatus: String, CaseIterable, Codable, Identifiable {
    case completed = "Completed"
    case playing = "Playing"
    case backlog = "Backlog"

    var id: String { self.rawValue }
}
