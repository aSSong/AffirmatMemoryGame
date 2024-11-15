
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
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(radius: 4)
                if !card.isMatched {
                    Text(card.content)
                        .multilineTextAlignment(.center)
                        .padding()
                        .foregroundColor(.black)
                }
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.blue)
            }
        }
    }
}
