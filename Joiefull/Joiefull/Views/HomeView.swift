//
//  HomeView.swift
//  Joiefull
//
//  Created by TLiLi Hamdi on 08/04/2025.
//
import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = ClothingViewModel()
    
    var categories: [ClothingItem.Category] {
        return ClothingItem.Category.allCases
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(categories, id: \.self) { category in
                        let categoryItems = viewModel.clothingItems.filter { $0.category == category }
                        if !categoryItems.isEmpty {
                            VStack(alignment: .leading, spacing: 0) {
                                // Titre de la catégorie
                                Text(category.rawValue)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .padding(.horizontal)
                                    .padding(.top, 15)
                                    .padding(.bottom, 10)
                                
                                // Articles de la catégorie
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 15) {
                                        //all items
                                        ForEach(0..<categoryItems.count, id: \.self) { index in
                                            if index % 2 == 0 {
                                                HStack(spacing: 15) {
                                                    CatalogItemView(item: categoryItems[index], onFavoriteToggle: {
                                                        viewModel.toggleFavorite(for: categoryItems[index])
                                                    }, viewModel: viewModel)
                                                    
                                                    if index + 1 < categoryItems.count {
                                                        CatalogItemView(item: categoryItems[index + 1], onFavoriteToggle: {
                                                            viewModel.toggleFavorite(for: categoryItems[index + 1])
                                                        }, viewModel: viewModel)
                                                    }
                                                }
                                                .frame(width: UIScreen.main.bounds.width - 30)
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                                .frame(height: 250)
                                
                                // Espacement entre les catégories
                                if category != categories.last {
                                    Spacer(minLength: 15)
                                }
                            }
                        }
                    }
                }
                .navigationTitle("TOTO")
            }
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                Task {
                    await viewModel.fetchClothingItems()
                }
            }
        }
    }
    
    // Détermine quelle catégorie est sélectionnée pour l'affichage du titre
    private var selectedCategory: ClothingItem.Category? {
        if viewModel.clothingItems.isEmpty { return nil }
        return categories.first
    }
    
}



#Preview {
    HomeView()
}
