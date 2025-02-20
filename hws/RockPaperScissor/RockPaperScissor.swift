//
//  RockPaperScissor.swift
//  hws
//
//  Created by piyush ehe on 21/02/25.
//

import SwiftUI

struct RockPaperScissor: View {
    let moves = ["🪨", "📄", "✂️"]
    let winningMoves = ["📄", "✂️", "🪨"]
    
    @State private var appChoice = Int.random(in: 0...2)
    @State private var shouldWin = Bool.random()
    @State private var score = 0
    @State private var questionCount = 0
    @State private var gameOver = false
    
    func moveTapped(_ playerChoice: Int) {
        let correctMove: Int
        if (shouldWin) {
            correctMove = (appChoice + 2) % 3
        } else {
            correctMove = (appChoice + 2) % 3
        }
        
        if (playerChoice == correctMove) {
            score += 1
        } else {
            score -= 1
        }
        
        questionCount += 1
        if (questionCount == 10) {
            gameOver = true
        } else {
            appChoice = Int.random(in: 0...2)
            shouldWin.toggle()
        }
    }
    
    func resetGame() {
        score = 0
        questionCount = 0
        appChoice = Int.random(in: 0...2)
        shouldWin = Bool.random()
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                Text("Score: \(score)")
                    .font(.title)
                    .foregroundColor(.white)
                
                VStack(spacing: 20) {
                    
                    Text("Score: \(score)")
                        .foregroundColor(.white)
                        .font(.headline)
                    
                    Text(moves[appChoice])
                        .font(.system(size: 80))
                    
                    Text(shouldWin ? "Win this round!" : "Lose this round")
                        .foregroundColor(.white)
                        .font(.title)
                        .padding()
                }
                
                HStack(spacing: 20) {
                    ForEach(0..<3) {index in
                        Button {
                            moveTapped(index)
                        } label: {
                            Text(moves[index])
                                .font(.system(size: 60))
                                .padding()
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
        }
        .alert("Game Over", isPresented: $gameOver) {
            Button("Play Again", action: resetGame)
        } message: {
            Text("Your final score is \(score)")
        }
    }
}


struct RockPaperScissor_Previews: PreviewProvider {
    static var previews: some View {
        RockPaperScissor()
    }
}
