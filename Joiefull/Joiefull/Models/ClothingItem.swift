//
//  ClothingItem.swift
//  Joiefull
//
//  Created by TLiLi Hamdi on 08/04/2025.
//

import Foundation

struct ClothingItem: Identifiable {
    var id = UUID()
    var name: String
    var originalPrice: Double
    var discountedPrice: Double?
    var rating: Double
    var category: Category
    var image: String // Nom de l'image locale (si disponible)
    var imageUrl: String? // URL de l'image distante (pour l'API)
    var description: String
    var likes: Int
    var isFavorite: Bool = false
    
    enum Category: String, CaseIterable {
        case hauts = "Hauts"
        case bas = "Bas"
        case sacs = "Sacs"
    }
}

