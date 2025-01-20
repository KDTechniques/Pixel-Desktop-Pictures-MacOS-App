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
    let item: Recent
    
    // MARK: - ASSIGNED PROPERTIES
    @State private var imageQualitiesURLStrings: UnsplashImageResolution?
    let vGridValues = VGridValuesModel.self
    
    // MARK: - INITIALIZER
    init(item: Recent) {
        self.item = item
    }
    
    // MARK: - BODY
    var body: some View {
        WebImage(
            url: .init(string: imageQualitiesURLStrings?.small ?? ""),
            options: [.highPriority, .retryFailed, .scaleDownLargeImages]
        )
        .placeholder { placeholder }
        .resizable()
        .scaledToFill()
        .frame(width: vGridValues.width, height: vGridValues.height)
        .clipped()
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
}
