import SwiftUI

struct Card: Identifiable {
    let id = UUID()
    let emoji: String
    var isFaceUp: Bool = false
    var isMatched: Bool = false
}

struct HafizaGameView: View {
    @State private var cards: [Card] = []
    @State private var selectedIndices: [Int] = []

    let emojis = ["🧟‍♂️", "🧬", "🖕🏼", "🗿"]

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.purple, Color.blue]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            VStack(spacing: 20) {
                Text("Hafıza Oyunu")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
                    ForEach(cards.indices, id: \.self) { index in
                        CardView(card: cards[index])
                            .onTapGesture {
                                handleTap(at: index)
                            }
                    }
                }
                .padding()
                
                Button("Yeniden Başlat") {
                    startGame()
                }
                .padding(.top, 20)
                .foregroundColor(.white)
            }
            .padding()
            .background(
                LinearGradient(colors: [Color.purple, Color.blue], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
            )
            .onAppear {
                startGame()
            }
        }
    }
    func startGame() {
       /* var tempCards = (emojis + emojis).shuffled()
        cards = tempCards.map { Card(emoji: $0) }
        selectedIndices = []*/
        let shuffledEmojis = (emojis + emojis).shuffled()
            // Önce tüm kartları açık başlat
            cards = shuffledEmojis.map { Card(emoji: $0, isFaceUp: true, isMatched: false) }
            selectedIndices = []

            // 1.5 saniye sonra kartları kapat
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    cards = cards.map { Card(emoji: $0.emoji, isFaceUp: false, isMatched: false) }
                }

    }

    func handleTap(at index: Int) {
        guard !cards[index].isMatched, !cards[index].isFaceUp, selectedIndices.count < 2 else { return }

        cards[index].isFaceUp = true
        selectedIndices.append(index)

        if selectedIndices.count == 2 {
            let first = selectedIndices[0]
            let second = selectedIndices[1]
            if cards[first].emoji == cards[second].emoji {
                // eşleşti
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    cards[first].isMatched = true
                    cards[second].isMatched = true
                    selectedIndices = []
                }
            } else {
                // eşleşmedi
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    cards[first].isFaceUp = false
                    cards[second].isFaceUp = false
                    selectedIndices = []
                }
            }
        }
    }
}

struct CardView: View {
    let card: Card

    var body: some View {
        ZStack {
            if card.isFaceUp || card.isMatched {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                Text(card.emoji)
                    .font(.largeTitle)
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.blue)
            }
        }
        .frame(width: 60, height: 80)
        .shadow(radius: 4)
        .animation(.easeInOut, value: card.isFaceUp)
    }
}
