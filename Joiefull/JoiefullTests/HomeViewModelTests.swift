


//
//  HomeViewModelTests.swift
//  JoiefullTests
//
//  Created by TLiLi Hamdi on 19/05/2025.
//

import XCTest
@testable import Joiefull

@MainActor
class HomeViewModelTests: XCTestCase {
    func testFetchClothingItemsSuccess() async {
        // Arrange
        let mockService = MockNetworkService()
        let viewModel = HomeViewModel(apiService: mockService)
        
        // Act
        await viewModel.fetchClothingItems()
        
        // Assert
        XCTAssertEqual(viewModel.clothingItems.count, 2)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testFetchClothingItemsFailure() async {
        // Arrange
        let mockService = MockNetworkService()
        mockService.shouldFail = true
        let viewModel = HomeViewModel(apiService: mockService)
        
        // Act
        await viewModel.fetchClothingItems()
        
        // Assert
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
    }
}

