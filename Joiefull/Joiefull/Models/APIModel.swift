//
//  APIModel.swift
//  Joiefull
//
//  Created by TLiLi Hamdi on 08/04/2025.
//


import Foundation

struct ClothingItemAPI: Decodable, Identifiable {
    let id: Int
    let picture: PictureAPI
    let name: String
    let category: CategoryAPI
    let likes: Int
    let price: Double
    let originalPrice: Double
}

struct PictureAPI: Codable {
    let url: String
    let description: String
}

enum CategoryAPI: String, Decodable, CaseIterable {
    case tops = "TOPS"
    case bottoms = "BOTTOMS"
    case shoes = "SHOES"
    case accessories = "ACCESSORIES"
    
    // Pour convertir entre l'API et notre modèle local
    var toLocalCategory: ClothingItem.Category {
        switch self {
        case .tops:
            return .hauts
        case .bottoms:
            return .bas
        case .accessories:
            return .sacs
        case .shoes:
            // Si nous n'avons pas cette catégorie localement, mappons-la aux sacs
            return .sacs
        }
    }
}

// Extension pour convertir le modèle API en modèle local
extension ClothingItemAPI {
    func toLocalModel() -> ClothingItem {
        // Si le prix original est différent du prix actuel, c'est un article soldé
        let discountedPrice: Double? = price != originalPrice ? price : nil
        
        return ClothingItem(
            name: name,
            originalPrice: originalPrice,
            discountedPrice: discountedPrice,
            rating: 4.0, // Valeur par défaut car l'API ne fournit pas de notation
            category: category.toLocalCategory,
            image: "",  // Laissé vide car nous utiliserons l'URL pour charger l'image
            imageUrl: picture.url,
            description: picture.description,
            likes: likes,
            isFavorite: false
        )
    }
}
