//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by William Koonz on 3/16/24.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var userScore = 0
    @State private var questionCount = 0
    
    @State private var selectedFlag = -1
    @State private var rotateAnimation = 0.0
    @State private var opacityAnimation = 1.0
    @State private var scaleAnimation = 1.0
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
            .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .font(.subheadline.weight(.heavy))
                            .foregroundStyle(.secondary)
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                                                    withAnimation {
                                                        selectedFlag = number
                                                        rotateAnimation += 360
                                                        opacityAnimation = 0.25
                                                        scaleAnimation = 0.8
                                                    }
                                                    
                                                    flagTapped(number)
                                                } label: {
                                                    Image(countries[number])
                                                        .clipShape(.capsule)
                                                        .shadow(radius: 5)
                                                        .rotation3DEffect(.degrees(selectedFlag == number ? rotateAnimation : 0), axis: (x: 0, y: 1, z: 0))
                                                        .opacity(selectedFlag == -1 || selectedFlag == number ? 1 : opacityAnimation)
                                                        .scaleEffect(selectedFlag == -1 || selectedFlag == number ? 1 : scaleAnimation)
                                                }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.ultraThinMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(userScore)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
            
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(userScore)")
        }
    }
    
    func flagTapped(_ number: Int) {
        questionCount += 1
        
        if number == correctAnswer {
            scoreTitle = "Correct"
            userScore += 1
        } else {
            scoreTitle = "Wrong! That's the flag of \(countries[number])"
        }
        
        if questionCount == 8 {
            scoreTitle = "Game Over"
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        if questionCount == 8 {
            questionCount = 0
            userScore = 0
        }
        
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
