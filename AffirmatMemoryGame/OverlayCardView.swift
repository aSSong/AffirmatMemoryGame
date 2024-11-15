//
//  OverlayCardView.swift
//  AffirmatMemoryGame
//
//  Created by 樊万松 on 2024/11/15.
//
import SwiftUI
import Foundation

struct OverlayCardView: View {
    let content: String
    let onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            // 背景层 - 不参与动画
            Color.black
                .opacity(0.5)
                .edgesIgnoringSafeArea(.all)
                
//                .transaction { transaction in
//                    transaction.animation = nil  // 禁用此视图的动画
//                }
            HStack{
                // 内容层 - 保留动画效果
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .frame(width: 300, height: 450)
                    .overlay(
                        Text(content)
                            .font(.largeTitle)
                            .multilineTextAlignment(.center)
                            .padding()
                            .foregroundColor(.black)
                           // .shadow(radius: 4)
                    )
            }
            // .shadow(radius: 8)
         //   .transition(.scale.combined(with: .opacity))
            .transition(.opacity)
        }
        .onTapGesture {
            onDismiss()
        }

    }
}
