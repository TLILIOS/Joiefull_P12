//
//  HomeViewModel.swift
//  Joiefull
//
//  Created by TLiLi Hamdi on 09/04/2025.
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var clothingItems: [ClothingItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var imageCache: [String: UIImage] = [:]
    
    private let apiService = APIService.shared
    
    init() {
        // Commencer avec des données fictives
        clothingItems = MockDataService.shared.clothingItems
    }
    
    var categories: [ClothingItem.Category] {
        return ClothingItem.Category.allCases
    }
    
    // Retourne les articles filtrés par catégorie
    func itemsForCategory(_ category: ClothingItem.Category) -> [ClothingItem] {
        return clothingItems.filter { $0.category == category }
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
            for item in self.clothingItems {
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
    
    // Méthode pour obtenir l'image à partir du cache
    func getImage(for imageUrl: String?, localImage: String) -> Image {
        if let imageUrl = imageUrl, let cachedImage = imageCache[imageUrl] {
            return Image(uiImage: cachedImage)
        } else if !localImage.isEmpty {
            return Image(localImage)
        } else {
            return Image(systemName: "photo")
        }
    }
}
