//
//  JoiefullApp.swift
//  Joiefull
//
//  Created by TLiLi Hamdi on 18/03/2025.
//

import SwiftUI

@main
struct JoiefullApp: App {
    @StateObject private var layoutValues = LayoutValues()
    init() {
            // Configuration du cache pour les images
            URLCache.shared.memoryCapacity = 50_000_000 // ~50 MB
            URLCache.shared.diskCapacity = 1_000_000_000 // ~1GB
        }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(layoutValues)
        }
    }
}
