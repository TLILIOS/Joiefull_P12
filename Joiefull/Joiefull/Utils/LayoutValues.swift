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

}
