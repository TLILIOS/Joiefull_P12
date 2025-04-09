//
//  MockDataService.swift
//  Joiefull
//
//  Created by TLiLi Hamdi on 08/04/2025.
//


import Foundation

class MockDataService {
    static let shared = MockDataService()
    
    var clothingItems: [ClothingItem] = [
        // Hauts
        ClothingItem(name: "Veste urbaine", originalPrice: 120, discountedPrice: 89, rating: 4.3, category: .hauts, image: "veste_urbaine", description: "Veste urbaine élégante et confortable", likes: 24, isFavorite: false),
        ClothingItem(name: "Pull torsadé", originalPrice: 95, discountedPrice: 69, rating: 4.6, category: .hauts, image: "pull_torsade", description: "Pull vert forêt à motif torsadé élégant, tricot finement travaillé avec manches bouffantes et col montant, doux et chaleureux.", likes: 56, isFavorite: false),
        
        // Bas
        ClothingItem(name: "Jean slim", originalPrice: 65, discountedPrice: 49, rating: 4.4, category: .bas, image: "jean_slim", description: "Jean slim confortable et tendance", likes: 40, isFavorite: false),
        ClothingItem(name: "Pantalon large", originalPrice: 70, discountedPrice: 54, rating: 4.2, category: .bas, image: "pantalon_large", description: "Pantalon large et confortable pour toutes occasions", likes: 35, isFavorite: false),
        
        // Sacs
        ClothingItem(name: "Sac à dos tendance", originalPrice: 85, discountedPrice: 75, rating: 4.5, category: .sacs, image: "sac_dos", description: "Sac à dos tendance et pratique pour un usage quotidien", likes: 42, isFavorite: false),
        ClothingItem(name: "Sac bandoulière", originalPrice: 95, discountedPrice: 80, rating: 4.7, category: .sacs, image: "sac_bandouliere", description: "Sac bandoulière élégant en cuir véritable", likes: 38, isFavorite: false)
    ]
}
