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

    private let apiService = APIService.shared

    init() {
        clothingItems = MockDataService.shared.clothingItems
    }

    func fetchClothingItems() async {
        isLoading = true
        errorMessage = nil
        do {
            let apiItems = try await apiService.fetchClothingItems()
            self.clothingItems = apiItems.map { $0.toLocalModel() }
            isLoading = false
        } catch {
            errorMessage = "Erreur lors de la récupération des données : \(error.localizedDescription)"
            isLoading = false
        }
    }
}
