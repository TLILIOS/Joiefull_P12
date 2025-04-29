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

    init(item: ClothingItem) {
        self.item = item
    }

    func toggleFavorite() {
        item.isFavorite.toggle()
        if item.isFavorite {
            item.likes += 1
        } else {
            item.likes -= 1
        }
    }
}
