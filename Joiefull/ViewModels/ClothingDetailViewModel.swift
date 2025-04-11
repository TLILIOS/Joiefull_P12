import Foundation
import SwiftUI
import Combine

class ClothingDetailViewModel: ObservableObject {
    @Published var item: ClothingItem
    @Published var userRating: Int = 0
    @Published var reviewText: String = ""
    @Published var itemInCart: Bool = false
    @Published var quantity: Int = 1
    @Published var relatedItems: [ClothingItem] = []
    @Published var imageCache: UIImage?
    
    private let apiService = APIService.shared
    
    init(item: ClothingItem) {
        self.item = item
        self.loadImage()
        self.fetchRelatedItems()
    }
    
    func loadImage() {
        if let cachedImage = MockDataService.shared.getImage(for: item.imageURL) {
            self.imageCache = cachedImage
        } else {
            // Ici, vous pourriez implémenter le chargement d'image depuis une URL
            Task {
                await loadImageFromURL()
            }
        }
    }
    
    @MainActor
    private func loadImageFromURL() async {
        // Simuler le chargement d'une image depuis une URL
        // Dans une implémentation réelle, vous feriez un appel réseau ici
        self.imageCache = MockDataService.shared.getImage(for: item.imageURL)
    }
    
    func toggleFavorite() {
        item.isFavorite.toggle()
        // Ici, vous pourriez également sauvegarder l'état dans une base de données ou un service
    }
    
    func addToCart() {
        itemInCart = true
        // Ici, vous ajouteriez la logique pour ajouter l'article au panier
    }
    
    func removeFromCart() {
        itemInCart = false
        // Ici, vous ajouteriez la logique pour retirer l'article du panier
    }
    
    func submitReview() {
        // Valider que la note et le texte ne sont pas vides
        guard userRating > 0 && !reviewText.isEmpty else { return }
        
        // Ici, vous implémenteriez la logique pour envoyer l'avis
        // Par exemple, appeler une API ou stocker localement
        
        // Réinitialiser les champs après soumission
        userRating = 0
        reviewText = ""
    }
    
    private func fetchRelatedItems() {
        // Simuler la récupération d'articles connexes basés sur la catégorie
        relatedItems = MockDataService.shared.clothingItems
            .filter { $0.category == item.category && $0.id != item.id }
            .prefix(4)
            .map { $0 }
    }
    
    func getImage() -> Image {
        if let uiImage = imageCache {
            return Image(uiImage: uiImage)
        } else {
            return Image(systemName: "photo")
        }
    }
}
