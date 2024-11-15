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
            //背景填充
            Color.white.opacity(0.2).edgesIgnoringSafeArea(.all)
            
            VStack {
                //标题显示
                Text(viewModel.lastTappedContent)
                    .font(.title3)
                    .padding()
                    .multilineTextAlignment(.center)
                    .animation(.easeInOut, value: viewModel.lastTappedContent)
                    .frame(height: 20)
                
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
                OverlayCardView(
                    content: viewModel.overlayContent,
                    onDismiss: {
                        viewModel.dismissOverlay()
                    }
                )
            }
        }
    }
}

#Preview {
    ContentView()
}
