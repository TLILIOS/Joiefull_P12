////
////  ContentView.swift
////  Joiefull
////
////  Created by TLiLi Hamdi on 18/03/2025.
////
//
//import SwiftUI
//
//struct ContentView: View {
//    @State private var showSplash = true
//    @EnvironmentObject private var layoutValues: LayoutValues
//    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
//    @Environment(\.verticalSizeClass) private var verticalSizeClass
//    
//    var body: some View {
//        ZStack {
//            if showSplash {
//                SplashScreenView()
//                    .transition(.opacity)
//            } else {
//                HomeView()
//                    .onAppear {
//                        layoutValues.horizontalSizeClass = horizontalSizeClass
//                        layoutValues.verticalSizeClass = verticalSizeClass
//                    }
//                    .onChange(of: horizontalSizeClass) {
//                        layoutValues.horizontalSizeClass = horizontalSizeClass
//                    }
//                    .onChange(of: verticalSizeClass) {
//                        layoutValues.verticalSizeClass = verticalSizeClass
//                    }
//                //détecter les changements d'orientation
//                    .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
//                        layoutValues.screenSize = UIScreen.main.bounds.size
//                    }
//            }
//        }
//    }
//}
//
//#Preview {
//    ContentView()
//        .environmentObject(LayoutValues())
//}
//
import SwiftUI

struct ContentView: View {
    @State private var showSplash = true
    @EnvironmentObject private var layoutValues: LayoutValues
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    
    var body: some View {
        ZStack {
            if showSplash {
                SplashScreenView()
                    .transition(.opacity)
            } else {
                HomeView()
                    .onAppear {
                        layoutValues.horizontalSizeClass = horizontalSizeClass
                        layoutValues.verticalSizeClass = verticalSizeClass
                    }
                    .onChange(of: horizontalSizeClass) { newValue in
                        layoutValues.horizontalSizeClass = newValue
                    }
                    .onChange(of: verticalSizeClass) { newValue in
                        layoutValues.verticalSizeClass = newValue
                    }
                    // Détecter les changements d'orientation
                    .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                        layoutValues.screenSize = UIScreen.main.bounds.size
                    }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    showSplash = false
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(LayoutValues())
}
