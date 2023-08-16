//
//  ContentView.swift
//  Math Tutor
//
//  Created by 陳永承 on 2023/8/15.
//

import SwiftUI
import AVFAudio

struct ContentView: View {
    @FocusState private var textFieldIsFocused: Bool
    @State private var firstNumber = 0
    @State private var secondNumber = 0
    @State private var firstNumberEmojis = ""
    @State private var secondNumberEmojis = ""
    @State private var answer = ""
    @State private var audioPlayer: AVAudioPlayer!
    @State private var textFieldIsDisabled = false
    @State private var guessButtonDisabled = false
    @State private var message = ""
    private let emojis = ["🍕", "🍎", "🍏", "🐵", "👽", "🧠", "🧜🏽‍♀️", "🧙🏿‍♂️", "🥷", "🐶", "🐹", "🐣", "🦄", "🐝", "🦉", "🦋", "🦖", "🐙", "🦞", "🐟", "🦔", "🐲", "🌻", "🌍", "🌈", "🍔", "🌮", "🍦", "🍩", "🍪"]
    
    var body: some View {
        VStack {
            Group{
                Text(firstNumberEmojis)
                    .font(.system(size: 80))
                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.center)

                Text("+")
                    .font(.system(size: 80))
                Text(secondNumberEmojis)
                    .font(.system(size: 80))
                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.center)

            }
            
            
            Spacer()
            
            
            Text("\(firstNumber)+\(secondNumber)")
            .font(.largeTitle)
            TextField("",text: $answer)
                .font(.largeTitle)
                .fontWeight(.black)
                .textFieldStyle(.roundedBorder)
                .frame(width: 60)
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.gray,lineWidth: 2)
                }
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .focused($textFieldIsFocused)
                .disabled(textFieldIsDisabled)
            Button("Guess"){
                textFieldIsFocused = false
                let result = firstNumber + secondNumber
                if let answerValue = Int(answer){
                    if answerValue == result {
                        playSound(soundName: "correct")
                        message = "Correct!"
                    } else {
                        playSound(soundName: "wrong")
                        message = "Sorry, the correct answer is \(firstNumber+secondNumber)"
                    }
                } else {
                    playSound(soundName: "wrong")
                    message = "Sorry, the correct answer is \(firstNumber+secondNumber)"
                }
                textFieldIsDisabled = true
                guessButtonDisabled = true
            }
            .buttonStyle(.borderedProminent)
            .disabled(answer.isEmpty||guessButtonDisabled)
            Spacer()
            Text(message)
                .font(.largeTitle)
                .fontWeight(.black)
                .multilineTextAlignment(.center)
                .foregroundColor(message == "Correct!" ? .green : .red)
            
            if guessButtonDisabled {
                Button("Play Again?") {
                    guessButtonDisabled = false
                    answer = ""
                    textFieldIsDisabled = false
                    message = ""
                    generateNewEquation()
                }
            }
        }
        .padding()
        .onAppear(){
            generateNewEquation()
        }
    }
    
    func generateNewEquation(){
        firstNumber = Int.random(in: 1...10)
        secondNumber = Int.random(in: 1...10)
        firstNumberEmojis = String(repeating: emojis.randomElement()!, count: firstNumber)
        secondNumberEmojis = String(repeating: emojis.randomElement()!, count: secondNumber)
    }
    
    func playSound(soundName:String){
        guard let soundFile = NSDataAsset(name: soundName) else {
            print("😡 ERROR:Could not read file named \(soundName)")
            return
        }
        do{
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer.play()
        } catch {
            print("😡 ERROR: \(error.localizedDescription) playing audioPlayer")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
