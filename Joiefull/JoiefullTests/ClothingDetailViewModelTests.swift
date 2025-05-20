//
//  ClothingDetailViewModelTests.swift
//  JoiefullTests
//
//  Created by TLiLi Hamdi on 19/05/2025.
//

import XCTest
@testable import Joiefull

@MainActor
class ClothingDetailViewModelTests: XCTestCase {
    func testToggleFavorite() {
        // Arrange
        let mockItem = ClothingItem(name: "Test Item",
                                   originalPrice: 20.0,
                                   discountedPrice: nil,
                                   rating: 4.0,
                                   category: .hauts,
                                   image: "",
                                   imageUrl: "test.jpg",
                                   description: "Test description",
                                   likes: 0,
                                   isFavorite: false)
        let viewModel = ClothingDetailViewModel(item: mockItem)
        
        // Initial state
        XCTAssertFalse(viewModel.item.isFavorite)
        XCTAssertEqual(viewModel.item.likes, 0)
        
        // Act & Assert - First toggle
        viewModel.toggleFavorite()
        XCTAssertTrue(viewModel.item.isFavorite)
        XCTAssertEqual(viewModel.item.likes, 1)
        
        // Act & Assert - Second toggle
        viewModel.toggleFavorite()
        XCTAssertFalse(viewModel.item.isFavorite)
        XCTAssertEqual(viewModel.item.likes, 0)
    }
    
    func testToggleMessage() {
        // Arrange
        let mockItem = ClothingItem(name: "Test Item",
                                   originalPrice: 20.0,
                                   discountedPrice: nil,
                                   rating: 4.0,
                                   category: .hauts,
                                   image: "",
                                   imageUrl: "test.jpg",
                                   description: "Test description",
                                   likes: 0,
                                   isFavorite: false)
        let viewModel = ClothingDetailViewModel(item: mockItem)
        
        // Initial state
        XCTAssertFalse(viewModel.messageSent)
        
        // Act & Assert - First toggle
        viewModel.toggleMessage()
        XCTAssertTrue(viewModel.messageSent)
        
        // Act & Assert - Second toggle
        viewModel.toggleMessage()
        XCTAssertFalse(viewModel.messageSent)
    }
    
    func testToggleCart() {
        // Arrange
        let mockItem = ClothingItem(name: "Test Item",
                                   originalPrice: 20.0,
                                   discountedPrice: nil,
                                   rating: 4.0,
                                   category: .hauts,
                                   image: "",
                                   imageUrl: "test.jpg",
                                   description: "Test description",
                                   likes: 0,
                                   isFavorite: false)
        let viewModel = ClothingDetailViewModel(item: mockItem)
        
        // Initial state
        XCTAssertFalse(viewModel.itemInCart)
        
        // Act & Assert - First toggle
        viewModel.toggleCart()
        XCTAssertTrue(viewModel.itemInCart)
        
        // Act & Assert - Second toggle
        viewModel.toggleCart()
        XCTAssertFalse(viewModel.itemInCart)
    }
}

