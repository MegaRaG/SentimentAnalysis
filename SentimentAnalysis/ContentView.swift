//
//  ContentView.swift
//  SentimentAnalysis
//
//  Created by Ahmed OMEROVIC on 1/26/24.
//

import SwiftUI

enum Sentiment: String {
    case positive = "POSITIVE"
    case negative = "NEGATIVE"
    case mixed = "MIXED"
    case neutral = "NEUTRAL"
    
    func emoticonForSentiment() -> String {
        switch self {
        case .positive:
            return "😃"
        case .negative:
            return "😞"
        case .mixed, .neutral:
            return "😐"
        }
    }
    
    func colorForSentiment() -> Color {
        switch self {
        case .positive:
            return .green
        case .negative:
            return .red
        case .mixed:
            return .yellow
        case .neutral:
            return .gray
        }
    }
}


struct ContentView: View {
    @State private var modelInput: String = ""
    @State private var modelOutput: Sentiment?
    
    func classify() {
        do {
            let model = try SentimentAnalyse_1(configuration: .init())
            let prediction = try model.prediction(text: modelInput)
            modelOutput = Sentiment(rawValue: prediction.label)
        } catch {
            print("Something went wrong")
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    Text("Ecrivez un texte, l'IA va essayer de devier votre sentiment")
                            .foregroundColor(.white)
                    
                    TextEditor(text: $modelInput)
                        .padding()
                        .background(
                            LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .cornerRadius(18)
                        .frame(height: 100)
                        .padding()
                    
                    Button(action: {
                        classify()
                    }) {
                        Text("Tester l'interface")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
            .background(Color.purple)
            .cornerRadius(18)
            .padding()
            .navigationBarTitle("🧠 IA du Turfu")
            
            if let unwrappedOutput = modelOutput {
                EmotionView(sentiment: unwrappedOutput, backgroundColor: unwrappedOutput.colorForSentiment(), emoticon: unwrappedOutput.emoticonForSentiment())
            }
        }
        .padding()
    }
}
    struct EmotionView: View {
        var sentiment: Sentiment
        var backgroundColor: Color
        var emoticon: String
        
        var body: some View {
            VStack {
                Text(sentiment.rawValue)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(emoticon)
                    .font(.system(size: 50))
                
            }
            .frame(width: 300, height: 100)
            .background(backgroundColor)
            .cornerRadius(10)
            .padding()
        }
    }
    
