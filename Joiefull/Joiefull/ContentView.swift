//
//  ContentView.swift
//  Joiefull
//
//  Created by TLiLi Hamdi on 18/03/2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var layoutValues: LayoutValues
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    
    var body: some View {
        HomeView()
            .onAppear {
                layoutValues.horizontalSizeClass = horizontalSizeClass
                layoutValues.verticalSizeClass = verticalSizeClass
            }
            .onChange(of: horizontalSizeClass) {
                layoutValues.horizontalSizeClass = horizontalSizeClass
            }
            .onChange(of: verticalSizeClass) {
                layoutValues.verticalSizeClass = verticalSizeClass
            }
//détecter les changements d'orientation
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                layoutValues.screenSize = UIScreen.main.bounds.size
            }
    }
}


#Preview {
    ContentView()
        .environmentObject(LayoutValues())
}

