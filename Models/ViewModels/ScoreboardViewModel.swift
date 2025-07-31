/*import Foundation
import SwiftUI

class ScoreboardViewModel: ObservableObject {
    @Published var scores: [PlayerScore] = []

    func addScore(name: String, score: Int) {
        let newScore = PlayerScore(name: name, score: score)
        scores.append(newScore)
        // Skorları büyükten küçüğe sırala
        scores.sort { $0.score > $1.score }
    }
    func resetScores() {
        scores.removeAll()
    }
}
*/

