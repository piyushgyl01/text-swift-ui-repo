//
//  Multiplicator.swift
//  hws
//
//  Created by piyush ehe on 25/02/25.
//
import SwiftUI

struct Multiplicator: View {
    
    @State private var gameActive = false
    @State private var multiplicationTable = 2
    @State private var numberOfQuestions = 5
    @State private var questionOptions = [5, 10, 20]
    
    @State private var questions: [Question] = []
    @State private var currentQuestionIndex = 0
    @State private var score = 0
    @State private var showingResult = false
    @State private var animatingWrong = false
    
    let backgroundGradient = LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
    var body: some View {
        ZStack {
            backgroundGradient.ignoresSafeArea()
            
            if (gameActive) {
                gameView
            } else {
                settingsView
            }
        }
        .alert("Game Over", isPresented: $showingResult) {
            Button("Play Game", action: resetGame)
        } message: {
            Text("Your final score is \(score) out of \(numberOfQuestions)")
        }
    }
    
    var settingsView: some View {
            VStack(spacing: 30) {
                Spacer()
                
                Text("Multiplication Tables")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                VStack(spacing: 20) {
                    Text("Select multiplication table to practice:")
                        .foregroundColor(.white)
                    
                    HStack {
                        Text("Up to:")
                            .foregroundColor(.white)
                        
                        Stepper("\(multiplicationTable)", value: $multiplicationTable, in: 2...12)
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(10)
                    }
                    
                    Text("Select number of questions:")
                        .foregroundColor(.white)
                    
                    HStack(spacing: 20) {
                        ForEach(questionOptions, id: \.self) { option in
                            Button(action: {
                                numberOfQuestions = option
                            }) {
                                Text("\(option)")
                                    .font(.title2)
                                    .padding()
                                    .frame(width: 70)
                                    .background(numberOfQuestions == option ? Color.green : Color.white.opacity(0.2))
                                    .foregroundColor(numberOfQuestions == option ? .white : .white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(20)
                
                Button {
                    startGame()
                } label: {
                    Text("Start Game")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                        .padding(.horizontal, 40)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Spacer()
                
                // Show cute animal character
                Image(systemName: "star.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.yellow)
                
                Spacer()
            }
            .padding()
        }

    
    var gameView: some View {
        VStack(spacing: 30) {
            HStack {
                Text("Score: \(score)")
                    .font(.title2)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("Question \(currentQuestionIndex + 1)/\(numberOfQuestions)")
                    .font(.title2)
                    .foregroundColor(.white)
            }
            .padding()
            
            Spacer()
            
            if (!questions.isEmpty && currentQuestionIndex < questions.count) {
                VStack(spacing: 20) {
                    Text(questions[currentQuestionIndex].text)
                        .font(.system(size: 44, weight: .bold))
                        .foregroundColor(.white)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(20)
                        .shadow(radius: 5)
                        .modifier(ShakeEffect(animatableData: animatingWrong ? 1 : 0))
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(questions[currentQuestionIndex].options, id: \.self) { option in
                            Button(action: {
                                checkAnswer(option)
                            }) {
                                Text("\(option)")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .frame(minWidth: 100, minHeight: 80)
                                    .background(Color.white.opacity(0.2))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
                .padding()
            }
            
            Spacer()
            
            Button {
                gameActive = false
            } label: {
                Text("Exit Game")
                    .padding()
                    .background(Color.red.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
    
    func startGame() {
        generateQuestions()
        score = 0
        currentQuestionIndex = 0
        gameActive = true
    }
    
    func generateQuestions() {
        questions = []
        
        var usedMultiplications = Set<String>()

        while questions.count < numberOfQuestions {
            let multiplicand = Int.random(in: 1...multiplicationTable)
            let multiplier = Int.random(in: 1...12)
            
            let key = "\(multiplicand)x\(multiplier)"
            if usedMultiplications.contains(key) {
                continue
            }
            
            usedMultiplications.insert(key)
            
            let answer = multiplier * multiplicand
            let questionText = "What is \(multiplicand)x\(multiplier)?"
            
            var options = [answer]
            while options.count < 4 {
                let option = (answer - 10) + Int.random(in: 0...20)
                if option != answer && option > 0 && !options.contains(option) {
                    options.append(option)
                }
            }
            
            options.shuffle()
            
            questions.append(Question(text: questionText, answer: answer, options: options))
        }
    }
    
    func checkAnswer (_ userAnswer: Int) {
        let correctAnser = questions[currentQuestionIndex].answer
        
        if (userAnswer == correctAnser) {
            score += 1
            nextQuestion()
        } else {
            withAnimation(.default) {
                animatingWrong = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                animatingWrong = false
            }
        }
    }
    
    func nextQuestion() {
        if (currentQuestionIndex + 1 < numberOfQuestions) {
            currentQuestionIndex += 1
        } else {
            showingResult = true
        }
    }
    
    func resetGame() {
        gameActive = false
    }
}

struct ShakeEffect: GeometryEffect {
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        let shake = sin(animatableData * .pi * 8) * 5
        return ProjectionTransform(CGAffineTransform(translationX: shake, y: 0))
    }
}


struct MultiplicatorPreviews: PreviewProvider {
    static var previews: some View {
        Multiplicator()
    }
}

