//
//  ClothingItemViewModel.swift
//  Joiefull
//
//  Created by TLiLi Hamdi on 09/04/2025.
//


import Foundation
import SwiftUI

class ClothingItemViewModel: ObservableObject {
    @Published var item: ClothingItem
    @Published var isFavorite: Bool
    
    init(item: ClothingItem) {
        self.item = item
        self.isFavorite = item.isFavorite
    }
    
    func toggleFavorite() {
        isFavorite.toggle()
        item.isFavorite = isFavorite
        
        // Mettre à jour le compteur de likes
        if isFavorite {
            item.likes += 1
        } else {
            item.likes -= 1
        }
    }
    
    // Obtenir l'image depuis le cache ou utiliser une image locale
//    func getImage() -> Image {
//        if let imageUrl = item.imageUrl, let cachedImage = ImageCacheService.shared.getImage(for: imageUrl) {
//            return Image(uiImage: cachedImage)
//        } else if !item.image.isEmpty {
//            return Image(item.image)
//        } else {
//            return Image(systemName: "photo")
//        }
//    }
    
    // Propriétés calculées pour faciliter l'accès aux données
    var name: String {
        return item.name
    }
    
    var originalPrice: Double {
        return item.originalPrice
    }
    
    var discountedPrice: Double? {
        return item.discountedPrice
    }
    
    var rating: Double {
        return item.rating
    }
    
    var likes: Int {
        return item.likes
    }
}
