import SwiftUI

struct OddEmojiGameView: View {
    @ObservedObject var scoreboard = ScoreboardViewModel()

    @State private var emojis = Array(repeating: "🐶", count: 49)
    @State private var oddEmoji = "🐱"
    @State private var oddIndex = Int.random(in: 0..<49)
    
    @State private var score = 0
    @State private var startTime = Date()
    @State private var showScoreboard = false
    @State private var playerName: String = ""
    @State private var gameStarted = false
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]),
                           startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                
                if !gameStarted && !showScoreboard {
                    Text("👀 Bul ve Tıkla")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                    
                    TextField("Oyuncu Adı", text: $playerName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    Button("Oyuna Başla") {
                        startNewRound()
                        gameStarted = true
                    }
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.blue)
                    .cornerRadius(10)
                }

                if gameStarted {
                    Text("Skor: \(score)")
                        .font(.title2)
                        .foregroundColor(.white)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                        ForEach(0..<emojis.count, id: \.self) { index in
                            Button(action: {
                                emojiTapped(at: index)
                            }) {
                                Text(emojis[index])
                                    .font(.system(size: 28))
                                    .frame(width: 42, height: 42)
                                    .background(Color.white.opacity(0.3))
                                    .cornerRadius(6)
                            }
                        }
                    }
                    .padding()
                }

                if showScoreboard {
                    VStack(spacing: 16) {
                        Text("🏆 Skor Tablosu")
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)

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
        }
    }

    func emojiTapped(at index: Int) {
        if index == oddIndex {
            let reactionTime = Date().timeIntervalSince(startTime)
            let roundScore = max(10 - Int(reactionTime * 2), 1)
            score += roundScore
            startNewRound()
        } else {
            // yanlış tıkladıysa skor cezası
            score = max(score - 2, 0)
        }
    }

    func startNewRound() {
        // seçilecek yeni farklı emoji
        let allEmojis = ["🐶", "🐱", "🐭", "🦊", "🐻", "🐸", "🐵"]
        let baseEmoji = allEmojis.randomElement()!
        var differentEmoji = allEmojis.randomElement()!
        while differentEmoji == baseEmoji {
            differentEmoji = allEmojis.randomElement()!
        }

        oddIndex = Int.random(in: 0..<49)
        emojis = Array(repeating: baseEmoji, count: 49)
        emojis[oddIndex] = differentEmoji
        startTime = Date()

        if score >= 100 { // örnek: oyun 50 puanda bitsin
            gameStarted = false
            showScoreboard = true
            scoreboard.addScore(name: playerName, score: score)
        }
    }

    func resetGame() {
        playerName = ""
        score = 0
        showScoreboard = false
    }
}
