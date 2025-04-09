import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = ClothingViewModel()
    
    var categories: [ClothingItem.Category] {
        return ClothingItem.Category.allCases
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(categories, id: \.self) { category in
                        let categoryItems = viewModel.clothingItems.filter { $0.category == category }
                        if !categoryItems.isEmpty {
                            VStack(alignment: .leading, spacing: 0) {
                                // Titre de la catégorie
                                Text(category.rawValue)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .padding(.horizontal)
                                    .padding(.top, 15)
                                    .padding(.bottom, 10)
                                
                                // Articles de la catégorie
                                ScrollView(.horizontal, showsIndicators: false) {
                                    GeometryReader { geometry in
                                        let itemWidth = (geometry.size.width - 45) / 2 // Largeur pour 2 éléments avec espacement
                                        
                                        HStack(spacing: 15) {
                                            ForEach(categoryItems) { item in
                                                CatalogItemView(item: item, onFavoriteToggle: {
                                                    viewModel.toggleFavorite(for: item)
                                                }, viewModel: viewModel)
                                                .frame(width: itemWidth)
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                    .frame(height: 230) // Hauteur fixe pour le conteneur
                                }
                                .padding(.bottom, 5)
                                
                                // Espacement entre les catégories
                                if category != categories.last {
                                    Spacer(minLength: 15)
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                Task {
                    await viewModel.fetchClothingItems()
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    titleText(selectedCategory)
                }
            }
        }
    }
    
    // Détermine quelle catégorie est sélectionnée pour l'affichage du titre
    private var selectedCategory: ClothingItem.Category? {
        if viewModel.clothingItems.isEmpty { return nil }
        return categories.first
    }
    
    // Composant Text qui affiche soit Joiefull, soit le nom de la catégorie
    private func titleText(_ category: ClothingItem.Category?) -> some View {
        Text(category?.rawValue ?? "Joiefull")
            .font(.title3)
            .fontWeight(.bold)
            .foregroundColor(.black)
    }
}

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
                        .frame(width: 140, height: 150)
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
            .frame(width: 140)
            .background(Color(.systemBackground))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    HomeView()
}
