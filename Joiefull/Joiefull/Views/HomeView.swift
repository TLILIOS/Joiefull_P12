//
//  HomeView.swift
//  Joiefull
//
//  Created by TLiLi Hamdi on 08/04/2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
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
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass

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
                    ForEach(items) { item in
                        ClothingItemView(
                            viewModel: ClothingItemViewModel(item: item, imageCache: imageCache),
                            detailViewModel: ClothingDetailViewModel(item: item, imageCache: imageCache)
                        )
                        .frame(width: itemWidth)
                    }
                }
                .padding(.horizontal)
            }
            .frame(height: sectionHeight)

            Spacer(minLength: 15)
        }
    }

    private var itemWidth: CGFloat {
        switch horizontalSizeClass {
        case .compact: // iPhone
            return (UIScreen.main.bounds.width - 45) / 2
        case .regular: // iPad
            return (UIScreen.main.bounds.width - 60) / 3 // Affiche 3 éléments sur iPad
        @unknown default:
            return (UIScreen.main.bounds.width - 45) / 2
        }
    }
    
    private var sectionHeight: CGFloat {
        switch (horizontalSizeClass, verticalSizeClass) {
        case (.compact, .compact): // iPhone en mode paysage
            return 200
        case (.compact, .regular): // iPhone en mode portrait
            return 250
        case (.regular, .compact): // iPad en mode paysage
            return 300
        case (.regular, .regular): // iPad en mode portrait
            return 350
        @unknown default:
            return 250
        }
    }
}

#Preview {
    HomeView()
}
