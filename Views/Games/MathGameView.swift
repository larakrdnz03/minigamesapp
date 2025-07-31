import SwiftUI

struct MathGameView: View {
    @State private var timeLeft = 30
    @State private var score = 0
    @State private var currentQuestion = ""
    @State private var correctAnswer = 0
    @State private var userAnswer = ""
    @State private var isGameActive = false
    @State private var timer: Timer?
    @FocusState private var isAnswerFieldFocused: Bool

    var body: some View {
        ZStack {
            // ARKA PLAN
            LinearGradient(colors: [Color.purple, Color.blue],
                           startPoint: .top,
                           endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("🧠 Matematik Oyunu")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)

                Text("Süre: \(timeLeft)")
                    .font(.title2)
                    .foregroundColor(.white)

                Text("Skor: \(score)")
                    .font(.title2)
                    .foregroundColor(.white)

                if isGameActive {
                    Text(currentQuestion)
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)

                    TextField("Cevap?", text: $userAnswer)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 50)
                        .keyboardType(.numbersAndPunctuation)
                        .focused($isAnswerFieldFocused)
                        .onSubmit {
                            checkAnswer()
                        }
                        .onChange(of: userAnswer) { newValue in
                            let allowed = "-0123456789"
                            userAnswer = newValue.filter { allowed.contains($0) }
                        }

                    Button("Gönder") {
                        checkAnswer()
                    }
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.blue)
                    .cornerRadius(10)
                }

                Button(isGameActive ? "Sıfırla" : "Oyuna Başla") {
                    startGame()
                }
                .padding()
                .foregroundColor(.white)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    func startGame() {
        score = 0
        timeLeft = 30
        isGameActive = true
        nextQuestion()
        isAnswerFieldFocused = true

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            timeLeft -= 1
            if timeLeft <= 0 {
                timer?.invalidate()
                isGameActive = false
                isAnswerFieldFocused = false
            }
        }
    }

    func nextQuestion() {
        let num1 = Int.random(in: 0...20)
        let num2 = Int.random(in: 0...20)
        let operations = ["+", "-", "*"]
        let operation = operations.randomElement()!

        switch operation {
        case "+":
            correctAnswer = num1 + num2
        case "-":
            correctAnswer = num1 - num2
        case "*":
            correctAnswer = num1 * num2
        default:
            break
        }

        currentQuestion = "\(num1) \(operation) \(num2)"
        userAnswer = ""
        isAnswerFieldFocused = true
    }

    func checkAnswer() {
        guard let userInt = Int(userAnswer) else {
            return
        }

        if userInt == correctAnswer {
            score += 1
        }

        nextQuestion()
    }
}
