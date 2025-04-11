//
//  ClothingDetailViewModel.swift
//  Joiefull
//
//  Created by TLiLi Hamdi on 09/04/2025.
//

import Foundation
import SwiftUI

class ClothingDetailViewModel: ObservableObject {
    @Published var item: ClothingItem
    @Published var userRating: Int = 0
    @Published var reviewText: String = ""
    @Published var itemInCart: Bool = false
    @Published var showingZoomView: Bool = false
    @Published var showingShareSheet: Bool = false
    
    private let homeViewModel: HomeViewModel
    
    init(item: ClothingItem, homeViewModel: HomeViewModel) {
        self.item = item
        self.homeViewModel = homeViewModel
    }
    
    // Basculer l'état favori
    func toggleFavorite() {
        item.isFavorite.toggle()
        
        if item.isFavorite {
            item.likes += 1
        } else {
            item.likes -= 1
        }
    }
    
    // Ajouter ou retirer du panier
    func toggleCart() {
        itemInCart.toggle()
        // Ici, logique pour ajouter/retirer l'article du panier
    }
    
    // Soumettre une évaluation
    func submitReview() {
        guard !reviewText.isEmpty && userRating > 0 else { return }
        
        // Logique pour envoyer l'évaluation au serveur
        print("Évaluation soumise: \(userRating) étoiles, commentaire: \(reviewText)")
        
        // Réinitialiser les champs
        reviewText = ""
        userRating = 0
    }
    
    // Obtenir l'image de l'article
    func getImage() -> Image {
        return homeViewModel.getImage(for: item.imageUrl, localImage: item.image)
    }
    
    // Partager l'article
    func shareItem() {
        showingShareSheet = true
    }
    
    // Vérifier si l'évaluation peut être soumise
    var canSubmitReview: Bool {
        return !reviewText.isEmpty && userRating > 0
    }
    
    // Items à partager
    var shareItems: [Any] {
        return [
            "Découvrez \"\(item.name)\" sur Joiefull!",
            URL(string: "https://joiefull.com/items/\(item.id)")!
        ]
    }
}
