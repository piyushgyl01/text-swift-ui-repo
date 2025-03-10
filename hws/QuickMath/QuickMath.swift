import SwiftUI

struct QuickMath: View {

    let operations = ["+", "-", "×", "÷"]
    
    @State private var firstNumber = 0
    @State private var secondNumber = 0
    @State private var operationIndex = 0
    @State private var shownAnswer = 0
    @State private var isCorrectAnswer = false
    @State private var score = 0
    @State private var timeRemaining = 30
    @State private var timer: Timer?
    @State private var gameOver = false
    @State private var streak = 0
    @State private var difficulty = 1
    
    // Computed property for correct answer
    var correctAnswer: Int {
        switch operations[operationIndex] {
        case "+":
            return firstNumber + secondNumber
        case "-":
            return firstNumber - secondNumber
        case "×":
            return firstNumber * secondNumber
        case "÷":
            return firstNumber / secondNumber
        default:
            return 0
        }
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.orange, .purple]),
                         startPoint: .topLeading,
                         endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack(spacing: 25) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Score: \(score)")
                            .font(.title2)
                        Text("Streak: \(streak)")
                            .font(.title3)
                    }
                    .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("\(timeRemaining)s")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                }
                .padding(.horizontal)
                
                Spacer()
                
                VStack(spacing: 20) {
                    HStack(spacing: 15) {
                        Text("\(firstNumber)")
                        Text(operations[operationIndex])
                        Text("\(secondNumber)")
                        Text("=")
                        Text("\(shownAnswer)")
                    }
                    .font(.system(size: 50, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    
                    Text("Level \(difficulty)")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                }
                
                Spacer()
                
                HStack(spacing: 20) {
                    Button {
                        checkAnswer(true)
                    } label: {
                        Text("✓ Correct")
                            .font(.title)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.green.opacity(0.8))
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                    }
                    
                    Button {
                        checkAnswer(false)
                    } label: {
                        Text("✗ Wrong")
                            .font(.title)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.red.opacity(0.8))
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .onAppear(perform: startGame)
        }
        .alert("Game Over!", isPresented: $gameOver) {
            Button("Play Again", action: resetGame)
        } message: {
            Text("Final Score: \(score)\nBest Streak: \(streak)")
        }
    }
    
    func startGame() {
        generateNewProblem()
        startTimer()
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer?.invalidate()
                gameOver = true
            }
        }
    }
    
    func generateNewProblem() {
        let range = switch difficulty {
            case 1: 1...10
            case 2: 1...20
            case 3: 1...50
            default: 1...100
        }
        
        operationIndex = Int.random(in: 0..<operations.count)
        
        if operations[operationIndex] == "÷" {
            secondNumber = Int.random(in: 1...10)
            firstNumber = secondNumber * Int.random(in: 1...10)
        } else {
            firstNumber = Int.random(in: range)
            secondNumber = Int.random(in: range)
        }
        
        let actualAnswer = correctAnswer
        isCorrectAnswer = Bool.random()
        
        if isCorrectAnswer {
            shownAnswer = actualAnswer
        } else {
            let variation = max(actualAnswer / 4, 1)
            repeat {
                shownAnswer = actualAnswer + Int.random(in: -variation...variation)
            } while shownAnswer == actualAnswer
        }
    }
    
    func checkAnswer(_ playerSaysCorrect: Bool) {
        if playerSaysCorrect == isCorrectAnswer {
            score += difficulty * 10
            streak += 1
            timeRemaining = min(timeRemaining + 2, 30)
            
            if streak % 5 == 0 && difficulty < 4 {
                difficulty += 1
            }
        } else {
            score = max(0, score - 5)
            streak = 0
            difficulty = 1
        }
        
        generateNewProblem()
    }
    
    func resetGame() {
        score = 0
        streak = 0
        timeRemaining = 30
        difficulty = 1
        generateNewProblem()
        startTimer()
    }
}

struct QuickMath_Previews: PreviewProvider {
    static var previews: some View {
        QuickMath()
    }
}
