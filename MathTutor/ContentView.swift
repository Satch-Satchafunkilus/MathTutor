//
//  ContentView.swift
//  MathTutor
//
//  Created by Tushar Munge on 6/17/25.
//

import AVFAudio
import SwiftUI

struct ContentView: View {
    private let emojis = [
        "🍕", "🍎", "🍏", "🐵", "👽", "🧠", "🧜🏽‍♀️", "🧙🏿‍♂️", "🥷", "🐶", "🐹", "🐣", "🦄", "🐝",
        "🦉", "🦋", "🦖", "🐙", "🦞", "🐟", "🦔", "🐲", "🌻", "🌍", "🌈", "🍔", "🌮", "🍦",
        "🍩", "🍪",
    ]

    @State private var firstNumber = 0
    @State private var secondNumber = 0
    @State private var firstNumberEmpojis = ""
    @State private var secondNumberEmpojis = ""
    @State private var answer = ""
    @State private var message = ""
    @State private var textFieldIsDisabled = false
    @State private var buttonIsDisabled = false
    @State private var audioPlayer: AVAudioPlayer!

    @FocusState private var textFieldIsFocused: Bool

    var body: some View {
        VStack {
            Group {
                Text("\(firstNumberEmpojis)")

                Text("+")
                    .font(.system(size: 80))

                Text("\(secondNumberEmpojis)")
            }
            .font(.system(size: 80))
            .multilineTextAlignment(.center)
            .minimumScaleFactor(0.5)
            .animation(.default, value: message)

            Spacer()

            Text("\(firstNumber) + \(secondNumber) =")
                .font(.largeTitle)
                .animation(.default, value: message)

            TextField("", text: $answer)
                .font(.largeTitle)
                .frame(width: 60.0)
                .textFieldStyle(.roundedBorder)
                .multilineTextAlignment(.center)
                .overlay {
                    RoundedRectangle(cornerRadius: 5.0)
                        .stroke(Color.gray, lineWidth: 2.0)
                }
                .keyboardType(.numberPad)
                .focused($textFieldIsFocused)
                .disabled(textFieldIsDisabled)

            Button("Guess") {
                // Dismisses the Keyboard when the Button is pressed
                textFieldIsFocused = false

                // Make sure 'answer' is an Integer
                guard let answerInt = Int(answer) else {
                    return
                }

                let soundName =
                    firstNumber + secondNumber == answerInt
                    ? "correct" : "wrong"

                playSound(soundName: soundName)

                message =
                    firstNumber + secondNumber == answerInt
                    ? "Correct!"
                    : "Sorry, the correct answer is \(firstNumber + secondNumber)"

                textFieldIsDisabled = true
                buttonIsDisabled = true
            }
            .buttonStyle(.borderedProminent)
            .disabled(answer.isEmpty || buttonIsDisabled)

            Spacer()

            Text(message)
                .font(.largeTitle)
                .fontWeight(.black)
                .foregroundStyle(
                    firstNumber + secondNumber == Int(answer)
                        ? Color.green : Color.red
                )
                .multilineTextAlignment(.center)
                .animation(.default, value: message)
            
            if !message.isEmpty {
                Button("Play Again?") {
                    resetGame()
                }
                
            }

        }
        .padding()
        .onAppear {
            resetGame()
        }
    }

    func playSound(soundName: String) {
        // Prior to playing a sound, check if it's already playing one.
        // If it is, stop it. This prevents overlapping sounds from
        // playing.
        if audioPlayer != nil && audioPlayer.isPlaying {
            audioPlayer.stop()
        }

        //TODO: - Get the Sound file -
        guard let soundFile = NSDataAsset(name: soundName) else {
            print("😡 ERROR: Could not read file named \(soundName)")

            return
        }

        do {
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer.play()
        } catch {
            print(
                "😡 ERROR: \(error.localizedDescription) creating audioPlayer"
            )
        }
    }
    
    func resetGame() {
        answer = ""
        message = ""
        
        textFieldIsFocused = true
        textFieldIsDisabled = false
        buttonIsDisabled = false
        
        firstNumber = Int.random(in: 1...10)
        secondNumber = Int.random(in: 1...10)

        firstNumberEmpojis = String(
            repeating: emojis.randomElement()!,
            count: firstNumber
        )

        secondNumberEmpojis = String(
            repeating: emojis.randomElement()!,
            count: secondNumber
        )
    }
}

#Preview {
    ContentView()
}
