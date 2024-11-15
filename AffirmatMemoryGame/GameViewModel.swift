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
    
    init() {
        startNewGame()
    }
    
    func startNewGame() {
        // 随机选择8个不同的 affirmations
        let selectedAffirmations = Array(Set(affirmations)).prefix(8)
        // 创建配对卡片
        let pairedAffirmations = selectedAffirmations + selectedAffirmations
        // 随机排序
        cards = pairedAffirmations.shuffled().map { Card(content: $0) }
        isGameOver = false
        
        lastTappedContent = "Tap and pair" // 重置为初始状态
    }
    
    func cardTapped(_ card: Card) {
        guard let index = cards.firstIndex(where: { $0.id == card.id }) else { return }
        
        // 如果卡片已经配对或者正面朝上，则忽略点击
        if cards[index].isMatched || cards[index].isFaceUp { return }
        
        // 更新最后点击的卡片内容
                lastTappedContent = card.content
        
        // 显示overlay
        overlayContent = card.content
        isShowingOverlay = true
        
        // 翻转动画
        withAnimation(.easeInOut(duration: 0.5)) {
            cards[index].isFaceUp = true
        }
        
        if let selectedCard = selectedCard {
            // 第二张卡片被选中
            cards[index].isFaceUp = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if selectedCard.content == self.cards[index].content {
                    // 匹配成功
                    if let firstIndex = self.cards.firstIndex(where: { $0.id == selectedCard.id }) {
                        self.cards[firstIndex].isMatched = true
                        self.cards[index].isMatched = true
                    }
                } else {
                    // 匹配失败，翻回背面
                    if let firstIndex = self.cards.firstIndex(where: { $0.id == selectedCard.id }) {
                        self.cards[firstIndex].isFaceUp = false
                        self.cards[index].isFaceUp = false
                    }
                }
                self.selectedCard = nil
                
                // 检查游戏是否结束
                self.checkGameOver()
            }
        } else {
            // 第一张卡片被选中
            cards[index].isFaceUp = true
            selectedCard = cards[index]
        }
    }
    
    func dismissOverlay() {
        isShowingOverlay = false
    }
    
    private func checkGameOver() {
        if cards.allSatisfy({ $0.isMatched }) {
            isGameOver = true
        }
    }
}
