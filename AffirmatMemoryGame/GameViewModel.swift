//
//  GameViewModel.swift
//  AffirmatMemoryGame
//
//  Created by 樊万松 on 2024/11/15.
//

import Foundation
import SwiftUI
// GameViewModel.swift
class GameViewModel: ObservableObject {
    @Published var cards: [Card] = []
    @Published var selectedCard: Card?
    @Published var isShowingOverlay = false
    @Published var overlayContent = ""
    @Published var isGameOver = false
    @Published var lastTappedContent: String = "Tap and pair" // 新添加的状态
    private var pendingCard: Card? = nil // 用于存储等待匹配检查的卡片
    
    init() {
        startNewGame()
    }
    func cardTapped(_ card: Card) {
        guard let index = cards.firstIndex(where: { $0.id == card.id }) else { return }
        
        // 如果卡片已经配对或者正面朝上，则忽略点击
        if cards[index].isMatched || cards[index].isFaceUp { return }
        // 如果正在显示overlay，则忽略点击
        if isShowingOverlay { return }
        
        // 更新最后点击的卡片内容
        lastTappedContent = card.content
        
        // 首先执行翻转动画
        withAnimation(.easeInOut(duration: 0.4)) {
            cards[index].isFaceUp = true
        }
        
        // 等待翻转动画完成后显示overlay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.overlayContent = card.content
            withAnimation(.easeInOut(duration: 0.3)) {
                self.isShowingOverlay = true
            }
        }
        
        if selectedCard != nil {
            // 存储第二张卡片，等待overlay关闭后进行匹配检查
            pendingCard = cards[index]
        } else {
            // 第一张卡片被选中
            selectedCard = cards[index]
        }
    }
    
    func dismissOverlay() {
      //  withAnimation(.easeInOut(duration: 0.2)) {
            isShowingOverlay = false
    //    }
        
        // 等待overlay消失后，如果有待处理的卡片，则进行匹配检查
        if let pending = pendingCard {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.checkMatch(pending)
            }
        }
    }
    
    private func checkMatch(_ secondCard: Card) {
        guard let firstCard = selectedCard,
              let firstIndex = cards.firstIndex(where: { $0.id == firstCard.id }),
              let secondIndex = cards.firstIndex(where: { $0.id == secondCard.id }) else {
            return
        }
        
        if firstCard.content == secondCard.content {
            // 匹配成功
            withAnimation(.easeInOut(duration: 0.5)) {
                cards[firstIndex].isMatched = true
                cards[secondIndex].isMatched = true
              //  lastTappedContent = "Matched: \(secondCard.content)"
            }
        } else {
            // 匹配失败，翻回背面
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    self.cards[firstIndex].isFaceUp = false
                    self.cards[secondIndex].isFaceUp = false
               //     self.lastTappedContent = "Try again!"
                }
            }
        }
        
        // 重置选中状态
        self.selectedCard = nil
        self.pendingCard = nil
        
        // 检查游戏是否结束
        checkGameOver()
    }
    
    private func checkGameOver() {
        if cards.allSatisfy({ $0.isMatched }) {
            isGameOver = true
        }
    }
    
    func startNewGame() {
        let selectedAffirmations = Array(Set(affirmations)).prefix(8)
        let pairedAffirmations = selectedAffirmations + selectedAffirmations
        cards = pairedAffirmations.shuffled().map { Card(content: $0) }
        isGameOver = false
        lastTappedContent = "Tap and pair"
        selectedCard = nil
        pendingCard = nil
    }
}

