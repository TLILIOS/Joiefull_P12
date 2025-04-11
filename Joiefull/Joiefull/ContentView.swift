//
//  ContentView.swift
//  Joiefull
//
//  Created by TLiLi Hamdi on 18/03/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HomeView()
//            .accentColor(Color("AccentColor"))
            .onAppear {
                // Configure l'apparence globale de l'application
//                let appearance = UINavigationBarAppearance()
//                appearance.configureWithOpaqueBackground()
//                appearance.backgroundColor = .white
//                appearance.titleTextAttributes = [.foregroundColor: UIColor.orange]
//                
//                UINavigationBar.appearance().standardAppearance = appearance
//                UINavigationBar.appearance().compactAppearance = appearance
//                UINavigationBar.appearance().scrollEdgeAppearance = appearance
            }
    }
}

#Preview {
    ContentView()
}

