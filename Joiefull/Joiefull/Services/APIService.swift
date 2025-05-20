//
//  APIService.swift
//  Joiefull
//
//  Created by TLiLi Hamdi on 08/04/2025.
//

import Foundation
protocol NetworkService {
    func fetchClothingItems() async throws -> [ClothingItemAPI]
}
class APIService: NetworkService {
    static let shared = APIService()
    private let clothesURL = "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/api/clothes.json"
    
    private init() {}
    
    func fetchClothingItems() async throws -> [ClothingItemAPI] {
        guard let url = URL(string: clothesURL) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode([ClothingItemAPI].self, from: data)
    }
    
    // Pour les images, nous allons utiliser une fonction pour télécharger l'image à partir de l'URL
    func downloadImage(from urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        return data
    }
}
