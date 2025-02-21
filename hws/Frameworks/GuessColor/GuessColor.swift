//
//  GuessColor.swift
//  hws
//
//  Created by piyush ehe on 22/02/25.
//

import SwiftUI

struct GuessColor: View {
    
    let colorNames = ["Red", "Blue", "Green", "Yellow", "Purple", "Orange"]
    let colors: [Color] = [.red, .blue, .green, .yellow, .purple, .orange]

    @State private var displayedColorIndex = Int.random(in: 0...5)
    @State private var displayedNameIndex = Int.random(in: 0...5)
    @State private var shouldMatchName = Bool.random()
    @State private var score = 0
    @State private var questionCount = 0
    @State private var gameOver = false
    @State private var timeRemaning = 30
    @State private var timer: Timer?
    
    func startGame() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if (timeRemaning > 0) {
                timeRemaning -= 1
            } else {
                timer?.invalidate()
                gameOver = true
            }
        }
    }
    
    func buttonTapped(_ playerChoice: Int) {
        let correctChoice: Int
        
        if (shouldMatchName) {
            correctChoice = displayedNameIndex
        } else {
            correctChoice = displayedColorIndex
        }
        
        if (playerChoice == correctChoice) {
            score += 1
            timeRemaning = min(timeRemaning + 2, 30)
        } else {
            score = max(0, score - 1)
        }
        
        questionCount += 1
        
        setupNextChallenge()
    }
    
    func setupNextChallenge() {
        let newColorIndex = Int.random(in: 0...5)
        var newNameIndex = Int.random(in: 0...5)
        
        if (Bool.random() && newNameIndex == newColorIndex) {
            newNameIndex = (newNameIndex + 1) % 6
        }
        
        displayedColorIndex = newColorIndex
        displayedNameIndex = newNameIndex
        shouldMatchName.toggle()
    }
    
    func resetGame() {
        score = 0
        questionCount = 0
        timeRemaning = 30
        setupNextChallenge()
        startGame()
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.mint, .indigo]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack(spacing: 25) {
                Spacer()
                
                HStack {
                    Text("Score \(score)")
                        .font(.title)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("Time: \(timeRemaning)")
                        .font(.title)
                        .foregroundColor(.white)
                }
                .padding(.horizontal)
                
                VStack(spacing: 20) {
                    Text(colorNames[displayedNameIndex])
                        .font(.system(size: 60, weight: .bold, design: .rounded))
                        .foregroundColor(colors[displayedColorIndex])
                        .padding()
                    
                    Text(shouldMatchName ? "Match the COLOR name!" : "Match the TEXT color!")
                        .foregroundColor(.white)
                        .font(.title)
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 15) {
                    ForEach(0..<6) { index in
                        Button {
                            buttonTapped(index)
                        } label: {
                            if (shouldMatchName) {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(colors[index])
                                    .frame(height: 80)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(.white, lineWidth: 2)
                                    )
                            } else {
                                Text(colorNames[index])
                                    .font(.title)
                                    .bold()
                                    .frame(height: 80)
                                    .frame(maxWidth: .infinity)
                                    .background(.ultraThinMaterial)
                                    .foregroundColor(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                            }
                        }
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
            Text("Your final score is \(score)")
        }
    }
}

struct GuessColor_Previews: PreviewProvider {
    static var previews: some View {
        GuessColor()
    }
}
