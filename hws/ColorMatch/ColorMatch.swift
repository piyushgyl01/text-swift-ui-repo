//
//  ColorMatch.swift
//  hws
//
//  Created by piyush ehe on 10/03/25.
//

import SwiftUI

struct ColorMatch: View {
    let colors = ["Red", "Blue", "Green", "Yellow"]

    @State private var colorWord = "Red"
    @State private var displayColor = "Blue"
    @State private var shouldMatch = true
    @State private var score = 0
    @State private var questionCount = 1
    @State private var gameOver = false
    @State private var timeRemaining = 30
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    let colorMappings = [
        "Red": Color.red,
        "Blue": Color.blue,
        "Green": Color.green,
        "Yellow": Color.yellow
    ]

    func setupGame() {
        chooseNewChallenge()
        score = 0
        questionCount = 1
        timeRemaining = 30
        gameOver = false
    }
    
    func resetGame() {
        setupGame()
    }
    
    func chooseNewChallenge() {
        colorWord = colors.randomElement()!
        
        shouldMatch = Bool.random()
        
        if shouldMatch {
            displayColor = colorWord
        } else {
            let otherColors = colors.filter {$0 != colorWord}
            displayColor = otherColors.randomElement()!
        }
    }
    
    func makeChoice(choice: String) {
        let correctAnswer: Bool
        
        if shouldMatch {
            correctAnswer = (choice == colorWord && choice == displayColor)
        } else {
            correctAnswer = (choice == colorWord && choice != displayColor)
        }
        
        if correctAnswer {
            score += 1
        } else {
            score = max(0, score - 1)
        }
        
        if questionCount == 10 {
            gameOver = true
        } else {
            questionCount += 1
            chooseNewChallenge()
        }
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.white, .gray]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            if gameOver {
                VStack(spacing: 20) {
                    Text("Game Over")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Your final score: \(score)")
                        .font(.title)
                    
                    Button("Play Again") {
                        resetGame()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            } else {
                VStack(spacing: 30) {
                    VStack {
                        Text("Score: \(score)")
                            .font(.headline)
                        Text("Question: \(questionCount)/10")
                            .font(.headline)
                        Text("Time: \(timeRemaining)")
                            .font(.headline)
                            .foregroundColor(timeRemaining <= 10 ? .red : .primary)
                    }
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    Text(colorWord)
                        .font(.system(size: 80))
                        .fontWeight(.bold)
                        .foregroundColor(colorMappings[displayColor])
                        .padding()
                    
                    Text(shouldMatch ? "Match Color and Word!" : "Find the Mismatch!")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding()
                        .background(shouldMatch ? Color.green.opacity(0.8) : Color.orange.opacity(0.8))
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                    
                    Spacer()
                    
                    VStack(spacing: 20) {
                        HStack(spacing: 20) {
                            ColorButton(color: "Red", action: {makeChoice(choice: "Red")})
                            ColorButton(color: "Blue", action: {makeChoice(choice: "Blue")})
                        }
                        
                        HStack(spacing: 20) {
                            ColorButton(color: "Green", action: {makeChoice(choice: "Green")})
                            ColorButton(color: "Yellow", action: {makeChoice(choice: "Yellow")})
                        }
                    }
                    Spacer()
                }
                .padding()
                .onReceive(timer) { _ in
                    if timeRemaining > 0 {
                        timeRemaining -= 1
                    } else {
                        gameOver = true
                    }
                }
            }
        }
        .onAppear(perform: setupGame)
    }
}

struct ColorButton: View {
    let color: String
    let action: () -> Void
    
    let colorMappings = [
        "Red": Color.red,
        "Blue": Color.blue,
        "Green": Color.green,
        "Yellow": Color.yellow
    ]
    
    var body: some View {
        Button(action: action) {
            Text(color)
                .font(.title)
                .fontWeight(.bold)
                .frame(width: 150, height: 60)
                .background(colorMappings[color])
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

struct ColorMatch_Previews: PreviewProvider {
    static var previews: some View {
        ColorMatch()
    }
}
