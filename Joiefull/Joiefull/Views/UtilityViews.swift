//
//  UtilityViews.swift
//  Joiefull
//
//  Created by TLiLi Hamdi on 08/04/2025.
//

import SwiftUI

struct ZoomableImageView: View {
    @ObservedObject var viewModel: ClothingDetailViewModel
    @Binding var isPresented: Bool
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        isPresented = false
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .padding()
                    }
                }

                Spacer()

                viewModel.getImage()
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(scale)
                    .offset(offset)
                    .gesture(
                        MagnificationGesture()
                            .onChanged { value in
                                let delta = value / lastScale
                                lastScale = value
                                scale = min(max(scale * delta, 1), 4)
                            }
                            .onEnded { _ in
                                lastScale = 1.0
                            }
                    )
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                offset = CGSize(
                                    width: lastOffset.width + value.translation.width,
                                    height: lastOffset.height + value.translation.height
                                )
                            }
                            .onEnded { _ in
                                lastOffset = offset
                            }
                    )
                    .onTapGesture(count: 2) {
                        withAnimation {
                            scale = scale > 1 ? 1 : 2
                            if scale == 1 {
                                offset = .zero
                                lastOffset = .zero
                            }
                        }
                    }

                Spacer()
            }
        }
    }
}
