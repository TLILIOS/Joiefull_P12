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
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    ForEach(categories, id: \.self) { category in
                        let items = viewModel.clothingItems.filter { $0.category == category }
                        if !items.isEmpty {
                            CategorySectionView(category: category, items: items)
                        }
                        
                    }
                }
                .padding()
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
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(category.rawValue)
                .font(.title2)
                .fontWeight(.bold)
                .padding()
                .padding(.top, 15)
                .padding(.bottom, 10)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(items) { item in
                        ClothingItemView(
                            viewModel: ClothingItemViewModel(item: item),
                            detailViewModel: ClothingDetailViewModel(item: item)
                        )
                    }
                }
                
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(LayoutValues())
}
