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
    
    // MARK: - ASSIGNED PROPERTIES
    let imageHeight: CGFloat = 225
    @State private var isImageLoaded = false
    
    // MARK: - BODY
    var body: some View {
        let imageURLString: String = mainTabVM.currentImage?.imageQualityURLStrings.regular ?? ""
        
        WebImage(
            url: .init(string: imageURLString),
            options: [.retryFailed, .continueInBackground, .highPriority, .scaleDownLargeImages]
        )
        .onSuccess { _, _, _ in handleOnSuccess() }
        .onProgress { _, _ in handleOnProgress() }
        .resizable()
        .scaledToFill()
        .frame(maxWidth: .infinity)
        .frame(height: imageHeight)
        .clipped()
        .opacity(isImageLoaded ? 1 : 0)
        .overlay { placeholder.opacity(isImageLoaded ? 0 : 1) }
        .animation(.default, value: isImageLoaded)
        .overlay(centerButton)
        .overlay(alignment: .bottomLeading) { locationText }
    }
}

// MARK: - PREVIEWS
#Preview("Image Preview Image Container View") {
    ImageContainerView()
        .previewModifier
}

// MARK: EXTENSIONS
extension ImageContainerView {
    private var centerButton: some View {
        ImageContainerOverlayCenterView(centerItem: mainTabVM.centerItem) {
            guard mainTabVM.centerItem == .retryIcon else { return }
            await mainTabVM.setNextImage()
        }
    }
    
    private var placeholder: some View {
        BlurPlaceholderView(blurRadius: 100)
            .frame(maxWidth: .infinity)
            .frame(height: imageHeight)
            .clipped()
    }
    
    @ViewBuilder
    private var locationText: some View {
        if let location: String = mainTabVM.currentImage?.location?.name {
            Label(location, systemImage: "location.fill")
                .foregroundStyle(.white)
                .font(.subheadline)
                .padding()
        }
    }
    
    // MARK: - FUNCTIONS
    private func handleOnSuccess() {
        isImageLoaded = true
        mainTabVM.setCenterItem(.retryIcon)
    }
    
    private func handleOnProgress() {
        isImageLoaded = false
    }
}
