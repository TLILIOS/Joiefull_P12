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
                .font(.title2).fontWeight(.bold)
                .padding(.bottom, 10)
                .accessibilityAddTraits(.isHeader)
                .accessibilityLabel("Catégorie : \(category.rawValue)")
                .allowsTightening(true)
            
            ScrollView(.horizontal, showsIndicators: false) {
                
                HStack {
                    ForEach(items) { item in
                        if isIpad {
                            ClothingItemView(
                                viewModel: ClothingItemViewModel(item: item),
                                detailViewModel: ClothingDetailViewModel(item: item),
                                isIpad: true,
                                isSelected: selectedItem?.id == item.id,
                                onTap: { selectedItem = item }
                            )
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("\(item.name), prix \(Int(item.discountedPrice ?? item.originalPrice)) euros")
                        } else {
                            ClothingItemView(
                                viewModel: ClothingItemViewModel(item: item),
                                detailViewModel: ClothingDetailViewModel(item: item)
                            )
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("\(item.name), prix \(Int(item.discountedPrice ?? item.originalPrice)) euros")
                        }
                    }
                    if isIpad && selectedItem != nil {
                        // Ajoute une vue vide de la largeur du panneau détail
                        Color.clear
                            .containerRelativeFrame(.horizontal) { length, _ in
                                length * 0.4
                            }
                    }
                }
                .padding()
            }
            .accessibilityLabel("\(category.rawValue), \(items.count) articles")
            .accessibilityHint("Balayez horizontalement pour parcourir")
        }
    }
}

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @State private var selectedItem: ClothingItem?
    
    private var isIpad: Bool {
        horizontalSizeClass == .regular && UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .trailing) {
                // Main content
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading) {
                        ForEach(ClothingItem.Category.allCases, id: \.self) { category in
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
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if isIpad && selectedItem != nil {
                        selectedItem = nil
                    }
                }
                
                // Detail view pour iPad
                if isIpad, let item = selectedItem {
                    ClothingDetailView(viewModel: ClothingDetailViewModel(item: item))
                        .containerRelativeFrame([.horizontal, .vertical]) { length, axis in
                            if axis == .horizontal {
                                return length * 0.4
                            } else {
                                return length
                            }
                        }
                        .background(Color(.systemBackground))
                        .transition(.move(edge: .trailing))
                        .accessibilityAddTraits(.isModal)
                        .accessibilityLabel("Détails du produit \(item.name)")
                        .accessibilityHint("Balayez vers le bas ou à trois doigts vers la gauche pour fermer")
                        .accessibilityAction(.escape) {
                            selectedItem = nil
                        }
                        .zIndex(1) // Assurez-vous que cette vue est au-dessus
                        .allowsHitTesting(true)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .task { await viewModel.fetchClothingItems() }
        }
    }
}

#Preview {
    HomeView()
}


