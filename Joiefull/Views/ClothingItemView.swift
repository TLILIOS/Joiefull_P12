import SwiftUI

struct ClothingItemView: View {
    var item: ClothingItem
    var onFavoriteToggle: () -> Void
    @ObservedObject var homeViewModel: HomeViewModel
    
    // Image cache locale pour éviter de recharger l'image à chaque rendu
    @State private var cachedImage: Image? = nil
    
    var body: some View {
        NavigationLink(destination: ClothingDetailView(item: item, onFavoriteToggle: onFavoriteToggle)) {
            VStack(alignment: .leading, spacing: 6) {
                // Image
                ZStack(alignment: .topTrailing) {
                    getItemImage()
                        .resizable()
                        .scaledToFill()
                        .frame(height: 160)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                    
                    // Favorite button with counter
                    Button(action: onFavoriteToggle) {
                        HStack(spacing: 4) {
                            Image(systemName: item.isFavorite ? "heart.fill" : "heart")
                                .foregroundColor(item.isFavorite ? .red : .white)
                            
                            Text("\(item.likes)")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        .padding(6)
                        .background(Color.black.opacity(0.4))
                        .cornerRadius(10)
                    }
                    .padding(8)
                }
                
                // Title
                Text(item.name)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                // Price
                HStack {
                    if let discountedPrice = item.discountedPrice {
                        Text("\(Int(discountedPrice))€")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Text("\(Int(item.originalPrice))€")
                            .font(.system(size: 12))
                            .strikethrough()
                            .foregroundColor(.gray)
                    } else {
                        Text("\(Int(item.originalPrice))€")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.primary)
                    }
                }
                
                // Rating
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.orange)
                        .font(.system(size: 10))
                    
                    Text(String(format: "%.1f", item.rating))
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
            }
            .padding(8)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // Méthode pour obtenir l'image de l'article
    private func getItemImage() -> Image {
        if let cachedImage = cachedImage {
            return cachedImage
        }
        
        if let uiImage = MockDataService.shared.getImage(for: item.imageURL) {
            let swiftUIImage = Image(uiImage: uiImage)
            DispatchQueue.main.async {
                self.cachedImage = swiftUIImage
            }
            return swiftUIImage
        }
        
        return Image(systemName: "photo")
    }
}

#Preview {
    let viewModel = HomeViewModel()
    return ClothingItemView(
        item: MockDataService.shared.clothingItems[0],
        onFavoriteToggle: {},
        homeViewModel: viewModel
    )
    .frame(width: 160, height: 260)
    .previewLayout(.sizeThatFits)
    .padding()
}
