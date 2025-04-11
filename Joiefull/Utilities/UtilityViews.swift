import SwiftUI

// Vue pour l'image zoomable
struct ZoomableImageView: View {
    let image: String
    let imageUrl: String?
    let viewModel: ClothingViewModel
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
                
                // Utilise l'image depuis le ViewModel pour gérer à la fois les images locales et les URL
                viewModel.getImage(for: ClothingItem(
                    name: "",
                    originalPrice: 0,
                    discountedPrice: nil,
                    rating: 0,
                    category: .hauts,
                    image: image,
                    imageUrl: imageUrl,
                    description: "",
                    likes: 0
                ))
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

// Vue pour le partage
struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
