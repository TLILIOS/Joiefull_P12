import Foundation
import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    @Published var clothingItems: [ClothingItem] = []
    @Published var filteredItems: [ClothingItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText: String = ""
    @Published var selectedCategory: ClothingItem.Category?
    
    private let apiService = APIService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Commencer avec des données fictives, puis charger les données réelles
        clothingItems = MockDataService.shared.clothingItems
        filteredItems = clothingItems
        
        // Observer les changements de texte de recherche
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] searchText in
                self?.filterItems()
            }
            .store(in: &cancellables)
        
        // Observer les changements de catégorie
        $selectedCategory
            .sink { [weak self] _ in
                self?.filterItems()
            }
            .store(in: &cancellables)
    }
    
    private func filterItems() {
        guard !clothingItems.isEmpty else { return }
        
        var filtered = clothingItems
        
        // Filtrer par catégorie si sélectionnée
        if let category = selectedCategory {
            filtered = filtered.filter { $0.category == category }
        }
        
        // Filtrer par texte de recherche
        if !searchText.isEmpty {
            filtered = filtered.filter { item in
                item.name.localizedCaseInsensitiveContains(searchText) ||
                item.description.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        filteredItems = filtered
    }
    
    @MainActor
    func fetchClothingItems() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let items = try await apiService.fetchClothingItems()
            clothingItems = items
            filterItems()
            isLoading = false
        } catch {
            errorMessage = "Erreur de chargement: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    func toggleFavorite(for item: ClothingItem) {
        if let index = clothingItems.firstIndex(where: { $0.id == item.id }) {
            clothingItems[index].isFavorite.toggle()
            filterItems()
        }
    }
}
