//
//  ImageContainerView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-24.
//

import SwiftUI
import SDWebImageSwiftUI

struct ImageContainerView: View {
    // MARK: - INJECTED PROPERTIES
    @Environment(MainTabViewModel.self) private var mainTabVM
    let imageURLString: String
    let location: String?
    
    // MARK: - ASSIGNED PROPERTIES
    let imageHeight: CGFloat = 225
    
    // MARK: - INITIALIZER
    init(imageURLString: String, location: String?) {
        self.imageURLString = imageURLString
        self.location = location
    }
    
    // MARK: - BODY
    var body: some View {
        Group {
            WebImage(
                url: .init(string: imageURLString),
                options: [.retryFailed, .continueInBackground, .highPriority, .scaleDownLargeImages]
            )
            .placeholder { placeholder }
            .resizable()
            .scaledToFill()
            .frame(maxWidth: .infinity)
            .frame(height: imageHeight)
            .clipped()
            .id(imageURLString)
            .transition(.opacity.animation(.default))
        }
        .overlay(centerButton)
        .overlay(alignment: .bottomLeading) { locationText }
    }
}

// MARK: - PREVIEWS
#Preview("Image Preview Image Container View") {
    @Previewable @State var thumbImageURLString: String = ""
    @Previewable @State var regularImageURLString: String = ""
    
    ImageContainerView(
        imageURLString: regularImageURLString,
        location: "Colombo, Sri Lanka"
    ) // change this later with a view model property model
    .task {
        thumbImageURLString = "https://images.unsplash.com/photo-1473448912268-2022ce9509d8?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2ODg0NDh8MHwxfHNlYXJjaHw5Mnx8TmF0dXJlfGVufDB8MHx8fDE3MzYzNDk4MjJ8MA&ixlib=rb-4.0.3&q=80&w=400"
        regularImageURLString = "https://images.unsplash.com/photo-1473448912268-2022ce9509d8?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2ODg0NDh8MHwxfHNlYXJjaHw5Mnx8TmF0dXJlfGVufDB8MHx8fDE3MzYzNDk4MjJ8MA&ixlib=rb-4.0.3&q=80&w=400"
    }
    .previewModifier
}

// MARK: EXTENSIONS
extension ImageContainerView {
    // MARK: - Center Item
    @ViewBuilder
    private var centerButton: some View {
        if let centerItem: ImageContainerCenterItemsModel = mainTabVM.centerItem {
            ImageContainerOverlayCenterView(centerItem: centerItem) {
                guard mainTabVM.centerItem == .retryIcon else { return }
//                await mainTabVM.getNextImage()
            }
        }
    }
    
    // MARK: - thumbnail
    private var placeholder: some View {
        BlurPlaceholderView(blurRadius: 100)
            .frame(maxWidth: .infinity)
            .frame(height: imageHeight)
            .clipped()
    }
    
    // MARK: - Location Text
    @ViewBuilder
    private var locationText: some View {
        if let location {
            Label(location, systemImage: "location.fill")
                .foregroundStyle(.white)
                .font(.subheadline)
                .padding()
        }
    }
}
