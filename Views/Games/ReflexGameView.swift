import SwiftUI

struct ReflexGameView: View {
    @ObservedObject var scoreboard = ScoreboardViewModel()
    
    @State private var playerName: String = ""
    @State private var showPrompt = false
    @State private var gameStarted = false
    @State private var resultText = ""
    @State private var startTime: Date?
    @State private var canTap = false
    @State private var showScoreboard = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.purple, Color.blue]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                if !gameStarted && !showScoreboard {
                    Text("Refleks Oyunu")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)

                    TextField("Adınızı girin", text: $playerName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    Button("Oyuna Başla") {
                        startGame()
                    }
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.blue)
                    .cornerRadius(10)
                }

                if gameStarted {
                    Text(showPrompt ? "ŞİMDİ TIKLA!" : "Hazır ol...")
                        .font(.title)
                        .foregroundColor(.white)
                        .onTapGesture {
                            handleTap()
                        }

                    Text(resultText)
                        .foregroundColor(.white)
                }

                if showScoreboard {
                    VStack(spacing: 16) {
                        Text("🏆 Skor Tablosu")
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)

                        List {
                            ForEach(scoreboard.scores.sorted(by: { $0.score < $1.score })) { player in
                                HStack {
                                    Text(player.name)
                                    Spacer()
                                    Text("\(player.score) ms")
                                }
                            }
                        }
                        .frame(height: 300)

                        Button("Yeni Oyuncu Ekle") {
                            resetGame()
                        }
                        .foregroundColor(.white)

                        Button("Skorları Sıfırla") {
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
        resultText = ""
        gameStarted = true
        showPrompt = false
        canTap = true

        let delay = Double.random(in: 1.5...5.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            if gameStarted {
                showPrompt = true
                startTime = Date()
            }
        }
    }

    func handleTap() {
        guard gameStarted else { return }

        if !showPrompt {
            // Erken tıkladı
            resultText = "Çok erken! 🙃"
            gameStarted = false
            canTap = false
        } else if let start = startTime {
            let reactionTime = Int(Date().timeIntervalSince(start) * 1000)
            resultText = "Refleks Süresi: \(reactionTime) ms"
            gameStarted = false
            showScoreboard = true
            scoreboard.addScore(name: playerName, score: reactionTime)
        }
    }

    func resetGame() {
        playerName = ""
        resultText = ""
        showPrompt = false
        showScoreboard = false
    }
}
