//
//  ContentView.swift
//  AffirmatMemoryGame
//
//  Created by 樊万松 on 2024/11/15.
//

import SwiftUI

// ContentView.swift
struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()
    
    let columns = Array(repeating: GridItem(.flexible()), count: 4)
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.2).edgesIgnoringSafeArea(.all)
            
            VStack {
                Text(viewModel.lastTappedContent)
                                    .font(.title2)
                                    .padding()
                                    .multilineTextAlignment(.center)
                                    .animation(.easeInOut, value: viewModel.lastTappedContent)
                                    .frame(height: 100) // 固定高度以防止布局跳动
                
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.cards) { card in
                        CardView(card: card)
                            .aspectRatio(2/3, contentMode: .fit)
                            .onTapGesture {
                                withAnimation(){
                                    viewModel.cardTapped(card)
                                }
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
                withAnimation{
                OverlayCardView(content: viewModel.overlayContent)
                    .onTapGesture {
                       
                            viewModel.dismissOverlay()
                        }
                    }
            }
        }
    }
}

#Preview {
    ContentView()
}
