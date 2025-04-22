//
//  ClothingDetailViewModel.swift
//  Joiefull
//
//  Created by TLiLi Hamdi on 09/04/2025.
//

import Foundation
import SwiftUI
@MainActor
class ClothingDetailViewModel: ObservableObject {
    @Published var item: ClothingItem
    @Published var userRating: Int = 0
    @Published var reviewText: String = ""
    @Published var itemInCart: Bool = false
    @Published var messageSent: Bool = false
    @Published var showingZoomView: Bool = false

    private let imageCache: [String: UIImage]

    init(item: ClothingItem, imageCache: [String: UIImage] = [:]) {
        self.item = item
        self.imageCache = imageCache
    }

    func getImage() -> Image {
        if let imageUrl = item.imageUrl, let cachedImage = imageCache[imageUrl] {
            return Image(uiImage: cachedImage)
        } else if !item.image.isEmpty {
            return Image(item.image)
        } else {
            return Image(systemName: "photo")
        }
    }

    func toggleFavorite() {
        item.isFavorite.toggle()
        if item.isFavorite {
            item.likes += 1
        } else {
            item.likes -= 1
        }
    }

    func submitReview() async {
        // Appel réseau ou logique d'envoi d'avis
        reviewText = ""
        userRating = 0
    }
func toggleMessage() {
    messageSent.toggle()
    }
    func toggleCart() {
        itemInCart.toggle()
    }
}
