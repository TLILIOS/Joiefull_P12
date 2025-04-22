//
//  HomeViewModel.swift
//  Joiefull
//
//  Created by TLiLi Hamdi on 09/04/2025.

import Foundation
import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    @Published var clothingItems: [ClothingItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var imageCache: [String: UIImage] = [:]

    private let apiService = APIService.shared

    init() {
        clothingItems = MockDataService.shared.clothingItems
    }
    func itemViewModel(for item: ClothingItem) -> ClothingItemViewModel {
        ClothingItemViewModel(item: item, imageCache: imageCache)
    }

    func fetchClothingItems() async {
        isLoading = true
        errorMessage = nil
        do {
            let apiItems = try await apiService.fetchClothingItems()
            self.clothingItems = apiItems.map { $0.toLocalModel() }
            await cacheImages(for: self.clothingItems)
            isLoading = false
        } catch {
            errorMessage = "Erreur lors de la récupération des données : \(error.localizedDescription)"
            isLoading = false
        }
    }

    private func cacheImages(for items: [ClothingItem]) async {
        for item in items {
            if let imageUrl = item.imageUrl {
                do {
                    let imageData = try await apiService.downloadImage(from: imageUrl)
                    if let uiImage = UIImage(data: imageData) {
                        self.imageCache[imageUrl] = uiImage
                    }
                } catch {
                    print("Erreur lors du téléchargement de l'image \(imageUrl): \(error)")
                }
            }
        }
    }

    func getImage(for item: ClothingItem) -> Image {
        if let imageUrl = item.imageUrl, let cachedImage = imageCache[imageUrl] {
            return Image(uiImage: cachedImage)
        } else if !item.image.isEmpty {
            return Image(item.image)
        } else {
            return Image(systemName: "photo")
        }
    }
}
