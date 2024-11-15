//
//  CardModel.swift
//  AffirmatMemoryGame
//
//  Created by 樊万松 on 2024/11/15.
//

import Foundation
struct Card: Identifiable, Equatable {
    let id = UUID()
    let content: String
    var isMatched = false
    var isFaceUp = false
}
