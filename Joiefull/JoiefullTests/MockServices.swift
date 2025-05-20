import Foundation

@testable import Joiefull
class MockNetworkService: NetworkService {
    var shouldFail = false
    
    func fetchClothingItems() async throws -> [ClothingItemAPI] {
        if shouldFail {
            throw NSError(domain: "TestError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch"])
        }
        
        return [
            ClothingItemAPI(id: 1,
                           picture: PictureAPI(url: "url1", description: "desc1"),
                           name: "Item1",
                           category: .tops,
                           likes: 10,
                           price: 20.0,
                           originalPrice: 25.0),
            ClothingItemAPI(id: 2,
                           picture: PictureAPI(url: "url2", description: "desc2"),
                           name: "Item2",
                           category: .bottoms,
                           likes: 5,
                           price: 15.0,
                           originalPrice: 15.0)
        ]
    }
}

