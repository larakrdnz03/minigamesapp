import SwiftUI

struct MainMenuView: View {
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(colors: [Color.blue, Color.purple], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()

                VStack(spacing: 30) {
                    Text("Mini Oyunlar")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    NavigationLink(destination: GameSelectionView()) {
                        Text("Başla")
                            .font(.title2)
                            .padding()
                            .frame(width: 200)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                    }
                }
            }
        }
    }
}

#Preview {
    MainMenuView()
}
