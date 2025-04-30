//
//  ClothingDetailView.swift
//  Joiefull
//
//  Created by TLiLi Hamdi on 08/04/2025.
//

import SwiftUI
import CachedAsyncImage

struct ClothingDetailView: View {
    @ObservedObject var viewModel: ClothingDetailViewModel
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                productImageSection
                VStack(alignment: .leading, spacing: 15) {
                    productHeaderSection
                    Divider()
                    productDescriptionSection
                    ratingAndFavoriteSection
                    reviewSection
                    addToCartButton
                }
                .padding()
            }
        }
//        .navigationBarBackButtonHidden(false)
//        .navigationBarTitle("", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                if horizontalSizeClass == .compact {
                    navigationTitleView
                }
                
            }
        }
    }
    
    // MARK: - UI Components
    
    private var productImageSection: some View {
        ZStack(alignment: .topTrailing) {
            detailImageView
                .frame(maxHeight: 450)
                .cornerRadius(15)
                .clipped()
                .onTapGesture {
                    viewModel.showingZoomView = true
                }
            shareButton
        }
        .fullScreenCover(isPresented: $viewModel.showingZoomView) {
            ZoomableImageView(
                viewModel: viewModel,
                isPresented: $viewModel.showingZoomView
            )
        }
    }
    
    private var detailImageView: some View {
        Group {
            if let imageUrl = viewModel.item.imageUrl, let url = URL(string: imageUrl) {
                CachedAsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity)
                            .clipped()
                    case .failure(_):
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                    case .empty:
                        ProgressView()
                    @unknown default:
                        ProgressView()
                    }
                }
            } else if !viewModel.item.image.isEmpty {
                Image(viewModel.item.image)
                    .resizable()
                    .scaledToFill()
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
            }
        }
    }
    
    private var shareButton: some View {
        ShareLink(
            item: URL(string: "https://joiefull.com/items/\(viewModel.item.id)")!,
            subject: Text("Découvrez sur Joiefull"),
            message: Text("Découvrez \"\(viewModel.item.name)\" sur Joiefull!"),
            preview: SharePreview("Joiefull - \(viewModel.item.name)")
        ) {
            Image(systemName: "square.and.arrow.up")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.primary)
                .padding(8)
                .background(Color.white.opacity(0.9))
                .clipShape(Circle())
        }
    }
    
    private var productHeaderSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(viewModel.item.name)
                    .font(.title2)
                    .fontWeight(.bold)
                priceView
            }
            Spacer()
            ratingView
        }
    }
    
    private var priceView: some View {
        HStack {
            if let discountedPrice = viewModel.item.discountedPrice {
                Text("\(Int(discountedPrice))€")
                    .font(.title3)
                    .fontWeight(.bold)
                Text("\(Int(viewModel.item.originalPrice))€")
                    .font(.subheadline)
                    .strikethrough()
                    .foregroundColor(.gray)
            } else {
                Text("\(Int(viewModel.item.originalPrice))€")
                    .font(.title3)
                    .fontWeight(.bold)
            }
        }
    }
    
    private var ratingView: some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .foregroundColor(.orange)
            Text(String(format: "%.1f", viewModel.item.rating))
                .fontWeight(.medium)
        }
    }
    
    private var productDescriptionSection: some View {
        Text(viewModel.item.description)
            .foregroundColor(.secondary)
            .fixedSize(horizontal: false, vertical: true)
    }
    
    private var ratingAndFavoriteSection: some View {
        HStack {
            Image("Profile")
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .foregroundColor(.gray)
            HStack {
                ForEach(1...5, id: \.self) { star in
                    Image(systemName: star <= viewModel.userRating ? "star.fill" : "star")
                        .foregroundColor(.orange)
                        .onTapGesture {
                            viewModel.userRating = star
                        }
                }
            }
            Spacer()
            favoriteButton
        }
    }
    
    private var favoriteButton: some View {
        Button(action: {
            viewModel.toggleFavorite()
        }) {
            HStack(spacing: 6) {
                Image(systemName: viewModel.item.isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(viewModel.item.isFavorite ? .red : .primary)
                    .font(.system(size: 18))
                Text("\(viewModel.item.likes)")
                    .font(.system(size: 16, weight: .medium))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(.systemGray6))
            .cornerRadius(20)
        }
    }
    
    private var reviewSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Votre avis")
                .font(.headline)
            TextField("Partagez vos impressions sur cette pièce", text: $viewModel.reviewText)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(15)
            submitReviewButton
        }
    }
    
    private var submitReviewButton: some View {
        Button(action: {
            viewModel.toggleMessage()
            
        }) {
            HStack {
                Image(systemName: viewModel.messageSent ? "checkmark" : "paperplane.fill")
                    .font(.system(size: 18))
                Text(viewModel.messageSent ? "Envoyé" : "Envoyer")
                    .fontWeight(.bold)
            }
            .frame(width: 100, height: 20)
            .padding(.vertical, 10)
            .padding(.horizontal, 10)
            .background(viewModel.messageSent ? Color.green : Color.orange)
            .background((viewModel.reviewText.isEmpty || viewModel.userRating == 0) ? Color.gray.opacity(0.5) : Color.orange)
            .foregroundColor(.white)
            .cornerRadius(8)
            .scaleEffect((viewModel.reviewText.isEmpty || viewModel.userRating == 0) ? 1.0 : 1.05)
            .animation(.easeInOut(duration: 0.2), value: viewModel.reviewText)
            .animation(.easeInOut(duration: 0.2), value: viewModel.userRating)
            
        }
        .disabled(viewModel.reviewText.isEmpty || viewModel.userRating == 0)
    }
    
    private var addToCartButton: some View {
        Button(action: {
            viewModel.toggleCart()
        }) {
            HStack {
                Image(systemName: viewModel.itemInCart ? "checkmark" : "cart.badge.plus")
                    .font(.system(size: 18))
                Text(viewModel.itemInCart ? "Ajouté au panier" : "Ajouter au panier")
                    .fontWeight(.bold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(viewModel.itemInCart ? Color.green : Color.orange)
            .foregroundColor(.white)
            .cornerRadius(15)
        }
        .padding(.bottom, 20)
    }
    
    private var navigationTitleView: some View {
        HStack {
            Text("Home")
                .foregroundColor(.blue)
                .fontWeight(.medium)
            Spacer()
        }
    }
}

// MARK: - Preview
#Preview {
    let item = MockDataService.shared.clothingItems[1]
    let viewModel = ClothingDetailViewModel(item: item)
    ClothingDetailView(viewModel: viewModel)
}
