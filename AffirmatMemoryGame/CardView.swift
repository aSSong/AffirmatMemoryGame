
//
//  CardView.swift
//  AffirmatMemoryGame
//
//  Created by 樊万松 on 2024/11/15.
//
import SwiftUI
import Foundation

// CardView.swift
struct CardView: View {
    let card: Card

    var body: some View {
        ZStack {
            if card.isFaceUp || card.isMatched {
                if !card.isMatched {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .shadow(radius: 4)
                Text(card.content)
                    .font(.caption2)
                    .multilineTextAlignment(.center)
                    .padding()
                    .foregroundColor(.black)
                }
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.blue)
                    .shadow(color:.black,radius: 3)
            }
        }
        
        .rotation3DEffect(
            .degrees(card.isFaceUp ? 0 : 180),
            axis: (x: 0.0, y: 0.5, z: 0.0),anchor: .center,
            perspective: 0.5
        )
        .animation(.easeInOut(duration: 0.5), value: card.isFaceUp)
        .opacity(card.isMatched ? 0 : 1)
        .animation(.easeInOut(duration: 0.5), value: card.isMatched)
    }
}
