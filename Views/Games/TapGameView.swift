import SwiftUI

struct PlayerScore: Identifiable {
    var id = UUID()
    var name: String
    var score: Int
}

class ScoreboardViewModel: ObservableObject {
    @Published var scores: [PlayerScore] = []

    func addScore(name: String, score: Int) {
        if let index = scores.firstIndex(where: { $0.name == name }) {
            scores[index].score = score
        } else {
            scores.append(PlayerScore(name: name, score: score))
        }
    }

    func resetScores() {
        scores.removeAll()
    }
}

struct TapGameView: View {
    @ObservedObject var scoreboard = ScoreboardViewModel()

    @State private var playerName: String = ""
    @State private var score = 0
    @State private var timeLeft = 10
    @State private var isGameActive = false
    @State private var showScoreboard = false
    @State private var timer: Timer?

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.purple, Color.blue]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            VStack(spacing: 20) {
                if !isGameActive && !showScoreboard {
                    Text("Oyuncu Adı:")
                    TextField("Adınızı girin", text: $playerName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    Button("Oyuna Başla") {
                        startGame()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
                if isGameActive {
                    Text("Süre: \(timeLeft)")
                    Text("Skor: \(score)")
                    
                    Button("Tıkla😠") {
                        score += 1
                    }
                    //.padding()
                    .padding(.vertical, 20)
                    .padding(.horizontal, 40)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
                if showScoreboard {
                    VStack(spacing: 16) {
                        Text("🏆 Skor Tablosu")
                            .font(.title)
                            .bold()
                        
                        List {
                            ForEach(scoreboard.scores.sorted(by: { $0.score > $1.score })) { player in
                                HStack {
                                    Text(player.name)
                                    Spacer()
                                    Text("\(player.score)")
                                }
                            }
                        }
                        .frame(height: 300)
                        
                        Button("Yeni Oyuncu Ekle") {
                            playerName = ""
                            score = 0
                            timeLeft = 10
                            showScoreboard = false
                        }
                        .foregroundColor(.white)
                        
                        Button("Skor Tablosunu Sıfırla") {
                            scoreboard.resetScores()
                        }
                        .foregroundColor(.red)
                    }
                    .padding()
                }
            }
            .padding()
        }
    }
    func startGame() {
        score = 0
        timeLeft = 10
        isGameActive = true

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeLeft > 0 {
                timeLeft -= 1
            } else if timeLeft <= 0 {
                timer?.invalidate()
                isGameActive = false
                showScoreboard = true
                scoreboard.addScore(name: playerName, score: score)
            }
        }
    }
}
