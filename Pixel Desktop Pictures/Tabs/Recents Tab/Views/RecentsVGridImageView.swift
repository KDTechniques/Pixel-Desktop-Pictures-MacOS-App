//
//  RecentsVGridImageView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-19.
//

import SwiftUI
import SDWebImageSwiftUI

struct RecentsVGridImageView: View {
    // MARK: - INJECTED PROPETIES
    @Environment(RecentsTabViewModel.self) private var recentsTabVM
    @Environment(MainTabViewModel.self) private var mainTabVM
    let item: Recent
    
    // MARK: - INITIALIZER
    init(item: Recent) {
        self.item = item
    }
    
    // MARK: - ASSIGNED PROPERTIES
    @State private var imageQualitiesURLStrings: UnsplashImageResolution?
    private let vGridValues = VGridValues.self
    
    // MARK: - BODY
    var body: some View {
        Button {
            handleTap()
        } label: {
            WebImage(
                url: .init(string: imageQualitiesURLStrings?.small ?? ""),
                options: [.highPriority, .retryFailed, .scaleDownLargeImages]
            )
            .placeholder { placeholder }
            .resizable()
            .scaledToFill()
            .frame(width: vGridValues.width, height: vGridValues.height)
            .clipped()
        }
        .buttonStyle(.plain)
        .onFirstTaskViewModifier { await handleOnFirstTaskModifier() }
    }
}

// MARK: - PREVIEWS
#Preview("Recents VGrid Image View") {
    RecentsVGridImageView(item: .init(imageEncoded: .init()))
        .previewModifier
}

// MARK: - EXTENSIONS
extension RecentsVGridImageView {
    private var placeholder: some View {
        BlurPlaceholderView(blurRadius: 30)
            .frame(width: vGridValues.width, height: vGridValues.height)
    }
    
    // MARK: - FUNCTIONS
    
    private func handleOnFirstTaskModifier() async {
        imageQualitiesURLStrings = try? await recentsTabVM
            .recentManager
            .getImageURLs(from: item)
    }
    
    private func handleTap() {
        // Decode image data to set the current image
        let decodedImage: UnsplashImage? = try? JSONDecoder().decode(UnsplashImage.self, from: item.imageEncoded)
        Task { await mainTabVM.setNSaveCurrentImageToUserDefaults(decodedImage) }
    }
}
