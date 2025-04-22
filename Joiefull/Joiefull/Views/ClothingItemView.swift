//
//  CatalogItemView.swift
//  Joiefull
//
//  Created by TLiLi Hamdi on 09/04/2025.
//

import SwiftUI

struct ClothingItemView: View {
    @ObservedObject var viewModel: ClothingItemViewModel
    @ObservedObject var detailViewModel: ClothingDetailViewModel
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    var body: some View {
        NavigationLink(
            destination: ClothingDetailView(
                viewModel: ClothingDetailViewModel(item: viewModel.item, imageCache: viewModel.imageCache)
            )
        ) {
            VStack(alignment: .leading, spacing: 8) {
                // Image avec bouton favoris
                ZStack(alignment: .bottomTrailing) {
                    detailViewModel.getImage()
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 180)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .clipped() // Assure que l'image ne déborde pas

                    // Bouton cœur avec compteur
                    Button(action: {
                        viewModel.toggleFavorite()
                    }) {
                        HStack(spacing: 4) {
                            Text("\(viewModel.item.likes)")
                                .font(.caption)
                                .foregroundColor(.white)

                            Image(systemName: viewModel.item.isFavorite ? "heart.fill" : "heart")
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
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Utilise tout l'espace disponible
            .background(Color(.systemBackground))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ClothingItemView_Previews: PreviewProvider {
    static var previews: some View {
        let mockItem = ClothingItem(
            name: "T-shirt Joiefull",
            originalPrice: 29.99,
            discountedPrice: 19.99,
            rating: 4.5,
            category: .hauts,
            image: "clothes",
            imageUrl: nil,
            description: "Un t-shirt confortable et stylé.",
            likes: 42,
            isFavorite: true
        )
        let mockImageCache: [String: UIImage] = [:]
        let mockViewModel = ClothingItemViewModel(item: mockItem, imageCache: mockImageCache)
        let mockDetailViewModel = ClothingDetailViewModel(item: mockItem, imageCache: mockImageCache)

        ClothingItemView(viewModel: mockViewModel, detailViewModel: mockDetailViewModel)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}


