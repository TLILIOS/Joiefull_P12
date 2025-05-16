//
//  FavoriteButton.swift
//  Joiefull
//
//  Created by TLiLi Hamdi on 12/05/2025.
//

import Foundation
import SwiftUI

struct FavoriteButton: View {
    // Propriétés nécessaires
    let isFavorite: Bool
    let likes: Int
    let onToggleFavorite: () -> Void
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                onToggleFavorite()
            }
        }) {
            HStack(spacing: 6) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(isFavorite ? .red : .primary)
                    .font(.system(size: 20, weight: .semibold))
                    .scaleEffect(isFavorite ? 1.1 : 1.0)
                
                Text("\(likes)")
                    .font(.system(size: 16, weight: .medium))
                    .allowsTightening(true)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(isFavorite ?
                          Color(.systemGray6).opacity(0.9) :
                          Color(.systemGray6))
            )
            .overlay(
                Capsule()
                    .stroke(isFavorite ? Color.red.opacity(0.3) : Color.clear, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 1)
        }
        .buttonStyle(ScaleButtonStyle())
        .accessibilityLabel(isFavorite ? "Retirer des favoris" : "Ajouter aux favoris")
        .accessibilityHint("\(likes) mentions J'aime")
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

#Preview {
    VStack(spacing: 20) {
        FavoriteButton(isFavorite: true, likes: 42, onToggleFavorite: {})
        FavoriteButton(isFavorite: false, likes: 21, onToggleFavorite: {})
    }
    .padding()
}
