//
//  SplashScreenView.swift
//  Joiefull
//
//  Created by TLiLi Hamdi on 19/05/2025.
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        Image("JoieFull")
            .resizable()
            .scaledToFit()
            .ignoresSafeArea()
    }
}


#Preview {
    SplashScreenView()
}
