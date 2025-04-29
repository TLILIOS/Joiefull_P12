//
//  LayoutValues.swift
//  Joiefull
//
//  Created by TLiLi Hamdi on 25/04/2025.
//

import Foundation
import SwiftUI
class LayoutValues: ObservableObject {
    @Published var screenSize: CGSize = UIScreen.main.bounds.size
    @Published var horizontalSizeClass: UserInterfaceSizeClass?
    @Published var verticalSizeClass: UserInterfaceSizeClass?
    
    var itemWidth: CGFloat {
        switch horizontalSizeClass {
        case .compact: // iPhone
            return (UIScreen.main.bounds.width - 36) / 2
        case .regular: // iPad
            return UIScreen.main.bounds.width > 900
            ? (UIScreen.main.bounds.width - 40) / 4
            : (UIScreen.main.bounds.width - 36) / 3
        default:
            return (UIScreen.main.bounds.width - 36) / 2
        }
    }

 

    var sectionHeight: CGFloat {
        switch (horizontalSizeClass, verticalSizeClass) {
        case (.compact, .compact): return 200
        case (.compact, .regular): return 250
        case (.regular, .compact): return 300
        case (.regular, .regular): return 350
        default: return 250
        }
    }
}
