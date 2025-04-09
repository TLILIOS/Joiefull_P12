//
//  ClothingViewModel.swift
//  Joiefull
//
//  Created by TLiLi Hamdi on 08/04/2025.
//

import Foundation
import SwiftUI

class ClothingViewModel: ObservableObject {
    @Published var clothingItems: [ClothingItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var imageCache: [String: UIImage] = [:]
    
    private let apiService = APIService.shared
    
    init() {
        // Commencer avec des données fictives, puis charger les données réelles
        clothingItems = MockDataService.shared.clothingItems
    }
    
    @MainActor
    func fetchClothingItems() async {
        isLoading = true
        errorMessage = nil
        
        do {
            // Récupérer les données de l'API
            let apiItems = try await apiService.fetchClothingItems()
            
            // Convertir les éléments de l'API en modèles locaux
            self.clothingItems = apiItems.map { $0.toLocalModel() }
            
            // Charger toutes les images
            for (index, item) in self.clothingItems.enumerated() {
                if let imageUrl = item.imageUrl {
                    Task {
                        do {
                            let imageData = try await apiService.downloadImage(from: imageUrl)
                            if let uiImage = UIImage(data: imageData) {
                                // Mettre à jour le cache d'images
                                self.imageCache[imageUrl] = uiImage
                            }
                        } catch {
                            print("Erreur lors du téléchargement de l'image \(imageUrl): \(error)")
                        }
                    }
                }
            }
            
            isLoading = false
        } catch {
            errorMessage = "Erreur lors de la récupération des données : \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    // Mettre à jour les favoris
    func toggleFavorite(for item: ClothingItem) {
        if let index = clothingItems.firstIndex(where: { $0.id == item.id }) {
            clothingItems[index].isFavorite.toggle()
            
            if clothingItems[index].isFavorite {
                clothingItems[index].likes += 1
            } else {
                clothingItems[index].likes -= 1
            }
        }
    }
    
    // Méthode pour obtenir l'image à partir du cache ou utiliser un placeholder
    func getImage(for item: ClothingItem) -> Image {
        if let imageUrl = item.imageUrl, let cachedImage = imageCache[imageUrl] {
            return Image(uiImage: cachedImage)
        } else if !item.image.isEmpty {
            // Utiliser l'image locale si disponible
            return Image(item.image)
        } else {
            // Image placeholder par défaut
            return Image(systemName: "photo")
        }
    }
}
