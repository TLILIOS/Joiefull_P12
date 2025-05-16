
//
//  CatalogItemView.swift
//  Joiefull
//
//  Created by TLiLi Hamdi on 09/04/2025.
//

import SwiftUI
import CachedAsyncImage

struct ClothingItemView: View {
    @ObservedObject var viewModel: ClothingItemViewModel
    @ObservedObject var detailViewModel: ClothingDetailViewModel
    
    // Propriétés pour le mode iPad
    var isIpad: Bool = false
    var isSelected: Bool = false
    var onTap: (() -> Void)? = nil
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    private var horizontalCount: Int {
        if horizontalSizeClass == .compact {
            return 2 // iPhone en mode portrait
        } else if horizontalSizeClass == .regular && verticalSizeClass == .regular || horizontalSizeClass == .regular && verticalSizeClass == .compact {
            return 5 // iPad & iPhone en mode paysage et iPad en mode portrait
        } else {
            return 3 // Par défaut
        }
    }

    var body: some View {
        Group {
            if isIpad {
                // Version iPad - sans NavigationLink
                itemContent
                    .onTapGesture {
                        onTap?()
                    }
//                    .background(isSelected ? Color.gray.opacity(0.2) : Color.clear)
                    .cornerRadius(15)
            } else {
                // Version iPhone - avec NavigationLink
                NavigationLink(
                    destination: ClothingDetailView(
                        viewModel: ClothingDetailViewModel(item: viewModel.item)
                    )
                ) {
                    itemContent
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    // Contenu commun pour les deux versions
    private var itemContent: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Image avec bouton favoris
            ZStack(alignment: .bottomTrailing) {
                imageView
                    .containerRelativeFrame(.horizontal, count: horizontalCount, spacing: 10)
                    .clipped()
                    .cornerRadius(15)
                
                FavoriteButton(
                    isFavorite: viewModel.item.isFavorite,
                    likes: viewModel.item.likes,
                    onToggleFavorite: { viewModel.toggleFavorite() }
                )
                .scaleEffect(0.8)  
                .padding(8)
            }
            VStack(alignment: .leading, spacing: 3) {
                // Nom du produit
                Text(viewModel.item.name)
                    .font(.caption)
                    .fontWeight(.medium)

                // Prix
                HStack(spacing: 5) {
                    if let discountedPrice = viewModel.item.discountedPrice {
                        Text("\(Int(discountedPrice))€")
                            .font(.caption)
                            .fontWeight(.bold)

                        Text("\(Int(viewModel.item.originalPrice))€")
                            .font(.caption2)
                            .strikethrough()
                            .foregroundColor(.gray)
                    } else {
                        Text("\(Int(viewModel.item.originalPrice))€")
                            .font(.caption)
                            .fontWeight(.bold)
                    }
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Prix: \(Int(viewModel.item.discountedPrice ?? viewModel.item.originalPrice)) euros\(viewModel.item.discountedPrice != nil ? ", prix initial \(Int(viewModel.item.originalPrice)) euros" : "")")

                // Notation
                HStack(spacing: 2) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.orange)
                        .font(.system(size: 10))

                    Text(String(format: "%.1f", viewModel.item.rating))
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
    }
    
    private var imageView: some View {
        Group {
            if let imageUrl = viewModel.item.imageUrl, let url = URL(string: imageUrl) {
                CachedAsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(1, contentMode: .fill)
                    case .failure(_):
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .accessibilityHidden(true)
                    case .empty:
                        ProgressView()
                    @unknown default:
                        ProgressView()
                    }
                }
            } else if !viewModel.item.image.isEmpty {
                Image(viewModel.item.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .accessibilityHidden(true)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}
