//
//  ContentView.swift
//  AffirmatMemoryGame
//
//  Created by 樊万松 on 2024/11/15.
//

import SwiftUI

// CardModel.swift
struct Card: Identifiable, Equatable {
    let id = UUID()
    let content: String
    var isMatched = false
    var isFaceUp = false
}

// AffirmationData.swift
let affirmations = [
    "I am worthy of love and respect",
    "I choose to be happy and confident",
    "I deserve to take care of myself",
    "I am enough just as I am",
    "I trust in my own abilities",
    "I radiate positive energy",
    "I deserve peace and tranquility",
    "I am strong and resilient",
    "I choose to think positive thoughts",
    "I am in charge of my own happiness",
    // ... 继续添加更多 affirmations 直到100条
]

// GameViewModel.swift
class GameViewModel: ObservableObject {
    @Published var cards: [Card] = []
    @Published var selectedCard: Card?
    @Published var isShowingOverlay = false
    @Published var overlayContent = ""
    @Published var isGameOver = false
    
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
    }
    
    func cardTapped(_ card: Card) {
        guard let index = cards.firstIndex(where: { $0.id == card.id }) else { return }
        
        // 如果卡片已经配对或者正面朝上，则忽略点击
        if cards[index].isMatched || cards[index].isFaceUp { return }
        
        // 显示overlay
        overlayContent = card.content
        isShowingOverlay = true
        
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

// OverlayCardView.swift
struct OverlayCardView: View {
    let content: String
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
            
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .frame(width: 300, height: 400)
                .overlay(
                    Text(content)
                        .multilineTextAlignment(.center)
                        .padding()
                        .foregroundColor(.black)
                )
        }
    }
}

// ContentView.swift
struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()
    
    let columns = Array(repeating: GridItem(.flexible()), count: 4)
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.2).edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Self-Care Memory Game")
                    .font(.title)
                    .padding()
                
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.cards) { card in
                        CardView(card: card)
                            .aspectRatio(2/3, contentMode: .fit)
                            .onTapGesture {
                                viewModel.cardTapped(card)
                            }
                    }
                }
                .padding()
                
                if viewModel.isGameOver {
                    Button(action: {
                        viewModel.startNewGame()
                    }) {
                        Text("Play Again")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding()
                }
            }
            
            if viewModel.isShowingOverlay {
                OverlayCardView(content: viewModel.overlayContent)
                    .onTapGesture {
                        viewModel.dismissOverlay()
                    }
            }
        }
    }
}

#Preview {
    ContentView()
}
