import SwiftUI

struct ClothingDetailView: View {
    var item: ClothingItem
    var onFavoriteToggle: () -> Void
    @StateObject private var viewModel: ClothingDetailViewModel
    @State private var showingZoomView = false
    @State private var userRating: Int = 0
    @State private var reviewText: String = ""
    @State private var showingShareSheet = false
    @State private var itemInCart = false
    
    init(item: ClothingItem, onFavoriteToggle: @escaping () -> Void) {
        self.item = item
        self.onFavoriteToggle = onFavoriteToggle
        self._viewModel = StateObject(wrappedValue: ClothingDetailViewModel(item: item))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Image with share button and zoom capability
                ZStack(alignment: .topTrailing) {
                    viewModel.getImage()
                        .resizable()
                        .scaledToFill()
                        .frame(maxHeight: 450)
                        .clipped()
                        .onTapGesture {
                            showingZoomView = true
                        }
                    
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
                .fullScreenCover(isPresented: $showingZoomView) {
                    ZoomableImageView(image: item.image, imageUrl: item.imageUrl, viewModel: viewModel, isPresented: $showingZoomView)
                }
                .sheet(isPresented: $showingShareSheet) {
                    ActivityView(activityItems: ["Découvrez \"\(item.name)\" sur Joiefull!", URL(string: "https://joiefull.com/items/\(item.id)")!])
                }
                }
                
                VStack(alignment: .leading, spacing: 15) {
                    // Title and price
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(item.name)
                                .font(.title2)
                                .fontWeight(.bold)
                            
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
                        
                        Spacer()
                        
                        // Rating
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.orange)
                            
                            Text(String(format: "%.1f", item.rating))
                                .fontWeight(.medium)
                        }
                    }
                    
                    Divider()
                    
                    // Description
                    Text(item.description)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    // Favorite and reviews section
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
                        
                        // Favorite button with counter
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
                    
                    // Review section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Votre avis")
                            .font(.headline)
                        
                        TextField("Partagez vos impressions sur cette pièce", text: $reviewText)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        
                        Button(action: {
                            // Submit review functionality
                            reviewText = ""
                        }) {
                            Text("Envoyer")
                                .fontWeight(.medium)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(reviewText.isEmpty ? Color.gray : Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .disabled(reviewText.isEmpty)
                    }
                    
                    // Add to cart button
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
                    .padding(.top, 20)
                }
                .padding()
            }
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarBackButtonHidden(false)
        .navigationBarTitle("", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.blue)
                    
                    Text("Home")
                        .foregroundColor(.blue)
                        .fontWeight(.medium)
                    
                    Spacer()
                }
            }
        }
    }
}

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
