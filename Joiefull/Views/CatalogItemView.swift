//
//  CatalogItemView.swift
//  Joiefull
//
//  Created by TLiLi Hamdi on 09/04/2025.
//

import SwiftUI

// Vue pour chaque article dans le catalogue
struct CatalogItemView: View {
    var item: ClothingItem
    var onFavoriteToggle: () -> Void
    @ObservedObject var viewModel: ClothingViewModel
    
    var body: some View {
        NavigationLink(destination: ClothingDetailView(item: item, onFavoriteToggle: onFavoriteToggle, viewModel: viewModel)) {
            VStack(alignment: .leading, spacing: 8) {
                // Image avec bouton favoris
                ZStack(alignment: .bottomTrailing) {
                    viewModel.getImage(for: item)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: (UIScreen.main.bounds.width - 45) / 2, height: 180)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    // Bouton cœur avec compteur
                    Button(action: onFavoriteToggle) {
                        HStack(spacing: 4) {
                            Text("\(item.likes)")
                                .font(.caption)
                                .foregroundColor(.white)
                            
                            Image(systemName: item.isFavorite ? "heart.fill" : "heart")
                                .foregroundColor(.white)
                        }
                        .padding(6)
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(15)
                        .padding(8)
                    }
                }
                
                // Infos du produit
                VStack(alignment: .leading, spacing: 3) {
                    // Nom du produit
                    Text(item.name)
                        .font(.caption)
                        .fontWeight(.medium)
                    
                    // Prix
                    HStack(spacing: 5) {
                        if let discountedPrice = item.discountedPrice {
                            Text("\(Int(discountedPrice))€")
                                .font(.caption)
                                .fontWeight(.bold)
                            
                            Text("\(Int(item.originalPrice))€")
                                .font(.caption2)
                                .strikethrough()
                                .foregroundColor(.gray)
                        } else {
                            Text("\(Int(item.originalPrice))€")
                                .font(.caption)
                                .fontWeight(.bold)
                        }
                    }
                    
                    // Notation
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.orange)
                            .font(.system(size: 10))
                        
                        Text(String(format: "%.1f", item.rating))
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
            }
            .frame(width: (UIScreen.main.bounds.width - 45) / 2)
            .background(Color(.systemBackground))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

