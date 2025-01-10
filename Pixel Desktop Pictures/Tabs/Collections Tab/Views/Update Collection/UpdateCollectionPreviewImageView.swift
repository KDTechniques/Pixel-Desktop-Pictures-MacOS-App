//
//  UpdateCollectionPreviewImageView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-10.
//

import SwiftUI
import SDWebImageSwiftUI

struct UpdateCollectionPreviewImageView: View {
    //MARK: - INJECTED PROPERTIES
    let imageURLs: UnsplashImageURLsModel
    let collectionName: String
    
    // MARK: - ASSIGNED PROPERTIES
    @Environment(CollectionsViewModel.self) private var collectionsVM
    let vGridValues = VGridValuesModel.self
    
    // MARK: - INITIALIZER
    init(imageURLs: UnsplashImageURLsModel, collectionName: String) {
        self.imageURLs = imageURLs
        self.collectionName = collectionName
    }
    
    // MARK: - BODY
    var body: some View {
        WebImage(
            url: .init(string: imageURLs.small),
            options: [.retryFailed, .highPriority]
        )
        .resizable()
        .scaledToFill()
        .frame(width: vGridValues.width, height: vGridValues.height)
        .clipped()
        .overlay(vGridValues.overlayColor)
        .overlay(CollectionNameOverlayView(collectionName: imageOverlayText()))
    }
}

// MARK: - PREVIEWS
#Preview("UpdateCollectionPreviewImageView") {
    UpdateCollectionPreviewImageView(
        imageURLs: try! CollectionItemModel.defaultCollectionsArray[1].getImageURLs(),
        collectionName: "Nature"
    )
    .border(Color.red)
    .padding()
    .previewModifier
}

// MARK: - EXTENSIONS
extension UpdateCollectionPreviewImageView {
    private func imageOverlayText() -> String {
        return collectionsVM.collectionRenameTextfieldText.isEmpty
        ? collectionName
        : collectionsVM.collectionRenameTextfieldText.capitalized
    }
}
