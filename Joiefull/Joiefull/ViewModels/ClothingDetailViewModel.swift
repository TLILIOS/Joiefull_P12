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

    func toggleMessage() {
        messageSent.toggle()
    }
    
    func toggleCart() {
        itemInCart.toggle()
    }
}
