import SwiftUI

struct GameSelectionView: View {
    var body: some View {
        ZStack {
            // Tam ekran gradient arka plan
            LinearGradient(
                colors: [Color.blue, Color.purple],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("Bir Oyun Seç")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 60)

                // Mini oyunlar
                NavigationLink(destination: TapGameView()) {
                    GameButton(title: "Tıklama Oyunu")
                }

                NavigationLink(destination: HafizaGameView()) {
                    GameButton(title: "Hafıza Oyunu")
                }

                NavigationLink(destination: MathGameView()) {
                    GameButton(title: "Matematik Oyunu")
                }
                NavigationLink(destination: ReflexGameView()) {
                    GameButton(title: "Refleks Oyunu")
                }
                NavigationLink(destination: OddEmojiGameView()) {
                    GameButton(title: "Bul ve Tıkla")
                }

                Spacer() // Altta boşluk bırakır
            }
            .padding()
        }
    }
}

struct GameButton: View {
    var title: String

    var body: some View {
        Text(title)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(12)
            .shadow(radius: 5)
    }
}

