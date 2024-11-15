//
//  OverlayCardView.swift
//  AffirmatMemoryGame
//
//  Created by 樊万松 on 2024/11/15.
//
import SwiftUI
import Foundation

// OverlayCardView.swift
struct OverlayCardView: View {
    let content: String
    
    var body: some View {
        ZStack {
            //半透黑色遮罩
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
            
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .frame(width: 300, height: 450)
                .overlay(
                    Text(content)
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .padding()
                        .foregroundColor(.black)
                )
        }
    }
}
