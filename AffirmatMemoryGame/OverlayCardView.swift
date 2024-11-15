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
