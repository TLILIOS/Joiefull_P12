//
//  HomeView.swift
//  Joiefull
//
//  Created by TLiLi Hamdi on 08/04/2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()

    var categories: [ClothingItem.Category] {
        ClothingItem.Category.allCases
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(categories, id: \.self) { category in
                        let items = viewModel.clothingItems.filter { $0.category == category }
                        if !items.isEmpty {
                            CategorySectionView(category: category, items: items, imageCache: viewModel.imageCache)
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                Task {
                    await viewModel.fetchClothingItems()
                }
            }
        }
    }
}

struct CategorySectionView: View {
    let category: ClothingItem.Category
    let items: [ClothingItem]
    let imageCache: [String: UIImage]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(category.rawValue)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
                .padding(.top, 15)
                .padding(.bottom, 10)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(pairedItems(items: items), id: \.0.id) { first, second in
                        CatalogPairView(first: first, second: second, imageCache: imageCache)
                            .frame(width: UIScreen.main.bounds.width - 30)
                    }
                }
                .padding(.horizontal)
            }
            .frame(height: 250)

            Spacer(minLength: 15)
        }
    }

    // Fonction pour diviser la liste en paires
    private func pairedItems(items: [ClothingItem]) -> [(ClothingItem, ClothingItem?)] {
        var result: [(ClothingItem, ClothingItem?)] = []
        var index = 0
        while index < items.count {
            let first = items[index]
            let second = index + 1 < items.count ? items[index + 1] : nil
            result.append((first, second))
            index += 2
        }
        return result
    }
}

struct CatalogPairView: View {
    let first: ClothingItem
    let second: ClothingItem?
    let imageCache: [String: UIImage]

    var body: some View {
        HStack(spacing: 15) {
            ClothingItemView(
                viewModel: ClothingItemViewModel(item: first, imageCache: imageCache),
                detailViewModel: ClothingDetailViewModel(item: first, imageCache: imageCache)
            )
            if let second = second {
                ClothingItemView(
                    viewModel: ClothingItemViewModel(item: second, imageCache: imageCache),
                    detailViewModel: ClothingDetailViewModel(item: second, imageCache: imageCache)
                )
            }
        }
    }
}

#Preview {
    HomeView()
}
