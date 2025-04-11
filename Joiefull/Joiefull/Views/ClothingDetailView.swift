//
//  ClothingDetailView.swift
//  Joiefull
//
//  Created by TLiLi Hamdi on 08/04/2025.
//
import SwiftUI

struct ClothingDetailView: View {
    // MARK: - Properties
    var item: ClothingItem
    var onFavoriteToggle: () -> Void
    @ObservedObject var viewModel: ClothingViewModel
    
    // MARK: - State
    @State private var showingZoomView = false
    @State private var userRating: Int = 0
    @State private var reviewText: String = ""
    @State private var showingShareSheet = false
    @State private var itemInCart = false
    
    // MARK: - Body
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
                .padding(.bottom, 60)
            }
        }
         
        
        .navigationBarBackButtonHidden(false)
        .navigationBarTitle("", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                navigationTitleView
            }
        }
    }
    
    // MARK: - UI Components
    
    private var productImageSection: some View {
        ZStack(alignment: .topTrailing) {
            viewModel.getImage(for: item)
                .resizable()
                .scaledToFill()
                .frame(maxHeight: 450)
                .clipped()
                .onTapGesture {
                    showingZoomView = true
                }
            
            shareButton
        }
        .fullScreenCover(isPresented: $showingZoomView) {
            ZoomableImageView(
                image: item.image,
                imageUrl: item.imageUrl,
                viewModel: viewModel,
                isPresented: $showingZoomView
            )
        }
        .sheet(isPresented: $showingShareSheet) {
            ActivityView(activityItems: [
                "Découvrez \"\(item.name)\" sur Joiefull!",
                URL(string: "https://joiefull.com/items/\(item.id)")!
            ])
        }
    }
    
    private var shareButton: some View {
        Button(action: {
            showingShareSheet = true
        }) {
            Image(systemName: "square.and.arrow.up")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.primary)
                .padding(8)
                .background(Color.white.opacity(0.9))
                .clipShape(Circle())
        }
        .padding()
    }
    
    private var productHeaderSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(item.name)
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
            if let discountedPrice = item.discountedPrice {
                Text("\(Int(discountedPrice))€")
                    .font(.title3)
                    .fontWeight(.bold)
                
                Text("\(Int(item.originalPrice))€")
                    .font(.subheadline)
                    .strikethrough()
                    .foregroundColor(.gray)
            } else {
                Text("\(Int(item.originalPrice))€")
                    .font(.title3)
                    .fontWeight(.bold)
            }
        }
    }
    
    private var ratingView: some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .foregroundColor(.orange)
            
            Text(String(format: "%.1f", item.rating))
                .fontWeight(.medium)
        }
    }
    
    private var productDescriptionSection: some View {
        Text(item.description)
            .foregroundColor(.secondary)
            .fixedSize(horizontal: false, vertical: true)
    }
    
    private var ratingAndFavoriteSection: some View {
        HStack {
            // User avatar placeholder
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.gray)
            
            // Star rating options
            HStack {
                ForEach(1...5, id: \.self) { star in
                    Image(systemName: "star")
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            favoriteButton
        }
    }
    
    private var favoriteButton: some View {
        Button(action: onFavoriteToggle) {
            HStack(spacing: 6) {
                Image(systemName: item.isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(item.isFavorite ? .red : .primary)
                    .font(.system(size: 18))
                
                Text("\(item.likes)")
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
            
            TextField("Partagez vos impressions sur cette pièce", text: $reviewText)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            
            submitReviewButton
        }
    }
    
    private var submitReviewButton: some View {
        Button(action: {
            // Submit review and rating functionality
            print("Submitted rating: \(userRating) and review: \(reviewText)")
            // Ici, vous pourriez appeler une méthode dans votre viewModel pour envoyer la note et l'avis
            reviewText = ""
            userRating = 0  // Reset rating after submission
        }) {
            Text("Envoyer")
                .fontWeight(.medium)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background((reviewText.isEmpty || userRating == 0) ? Color.gray : Color.orange)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        .disabled(reviewText.isEmpty || userRating == 0)
    }

    private var addToCartButton: some View {
        Button(action: {
            itemInCart.toggle()
        }) {
            HStack {
                Image(systemName: itemInCart ? "checkmark" : "cart.badge.plus")
                    .font(.system(size: 18))
                
                Text(itemInCart ? "Ajouté au panier" : "Ajouter au panier")
                    .fontWeight(.bold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(itemInCart ? Color.green : Color.orange)
            .foregroundColor(.white)
            .cornerRadius(10)
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
    NavigationView {
        let viewModel = ClothingViewModel()
        return ClothingDetailView(
            item: MockDataService.shared.clothingItems[1],
            onFavoriteToggle: {},
            viewModel: viewModel
        )
    }
}
