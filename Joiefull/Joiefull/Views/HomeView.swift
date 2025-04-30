//
//  HomeView.swift
//  Joiefull
//
//  Created by TLiLi Hamdi on 08/04/2025.
//

import SwiftUI

struct CategorySectionView: View {
    
    let category: ClothingItem.Category
    let items: [ClothingItem]
    @Binding var selectedItem: ClothingItem?
    let isIpad: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(category.rawValue)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.bottom, 10)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(items) { item in
                        if isIpad {
                            // Version iPad - utilisez un bouton au lieu de NavigationLink
                            ClothingItemView(
                                viewModel: ClothingItemViewModel(item: item),
                                detailViewModel: ClothingDetailViewModel(item: item),
                                isIpad: true,
                                isSelected: selectedItem?.id == item.id,
                                onTap: {
                                    selectedItem = item
                                }
                            )
                        }  else {
                            // Version iPhone - gardez le comportement NavigationLink
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
}

struct HomeView: View {
    
    @StateObject private var viewModel = HomeViewModel()
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @State private var selectedItem: ClothingItem?
    var categories: [ClothingItem.Category] {
        ClothingItem.Category.allCases
    }
    var isIpad: Bool {
        horizontalSizeClass == .regular && UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading) {
                        ForEach(categories, id: \.self) { category in
                            let items = viewModel.clothingItems.filter { $0.category == category }
                            if !items.isEmpty {
                                CategorySectionView(
                                    category: category,
                                    items: items,
                                    selectedItem: $selectedItem,
                                    isIpad: isIpad
                                )
                            }
                        }
                    }
                    .padding()
                }
                
                // Affichage des détails sur iPad (qui apparaît par-dessus)
                if isIpad, let item = selectedItem {
                    HStack {
                        Spacer()
                        ClothingDetailView(viewModel: ClothingDetailViewModel(item: item))
                            .containerRelativeFrame(.horizontal) { size, _ in
                                size * 0.4
                            }
                            .background(Color(.systemBackground))
                            .transition(.move(edge: .trailing))
                        
                    }
                    .padding()
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

#Preview {
    HomeView()
}

