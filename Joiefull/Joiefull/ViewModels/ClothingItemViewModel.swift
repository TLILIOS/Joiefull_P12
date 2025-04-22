//
//  ClothingItemViewModel.swift
//  Joiefull
//
//  Created by TLiLi Hamdi on 09/04/2025.
//

import Foundation
import SwiftUI
@MainActor
class ClothingItemViewModel: ObservableObject {
    @Published var item: ClothingItem
    @Published var image: Image

    let imageCache: [String: UIImage]

    init(item: ClothingItem, imageCache: [String: UIImage]) {
        self.item = item
        self.imageCache = imageCache
        self.image = ClothingItemViewModel.loadImage(for: item, imageCache: imageCache)
    }

    func toggleFavorite() {
        item.isFavorite.toggle()
        if item.isFavorite {
            item.likes += 1
        } else {
            item.likes -= 1
        }
    }

    static func loadImage(for item: ClothingItem, imageCache: [String: UIImage]) -> Image {
        if let imageUrl = item.imageUrl, let cachedImage = imageCache[imageUrl] {
            return Image(uiImage: cachedImage)
        } else if !item.image.isEmpty {
            return Image(item.image)
        } else {
            return Image(systemName: "photo")
        }
    }
}
