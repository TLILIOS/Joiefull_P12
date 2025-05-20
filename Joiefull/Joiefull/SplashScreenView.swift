//
//  SplashScreenView.swift
//  Joiefull
//
//  Created by TLiLi Hamdi on 19/05/2025.
//

import SwiftUI

struct SplashScreenView: View {
    var imageName: String {
            UIDevice.current.userInterfaceIdiom == .pad ? "Ecran de démarrage" : "IphoneEcran de démarrage"
        }
    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }
}


#Preview {
    SplashScreenView()
}
