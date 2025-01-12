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
    @Environment(CollectionsViewModel.self) private var collectionsVM
    let item: CollectionModel
    
    // MARK: - ASSIGNED PROPERTIES
    let vGridValues = VGridValuesModel.self
    @State private var showImage: Bool = false
    
    // MARK: - INITIALIZER
    init(item: CollectionModel) {
        self.item = item
    }
    
    // MARK: - BODY
    var body: some View {
        Group {
            if let imageURLString: String = try? item.getImageURLs().small {
                if showImage {
                    WebImage(
                        url: .init(string: imageURLString),
                        options: [.retryFailed, .highPriority, .continueInBackground]
                    )
                    .placeholder { ProgressView().scaleEffect(0.3) }
                    .resizable()
                    .scaledToFill()
                    .transition(.fade)
                } else {
                    ProgressView().scaleEffect(0.3)
                }
            } else {
                Color.clear
            }
        }
        .frame(width: vGridValues.width, height: vGridValues.height)
        .clipped()
        .overlay(Color.vGridItemOverlay)
        .overlay(CollectionNameOverlayView(collectionName: imageOverlayText()))
        .onFirstTaskViewModifier {
            try? await Task.sleep(nanoseconds: 500_000_000)
            withAnimation { showImage = true }
        }
    }
}

// MARK: - PREVIEWS
#Preview("UpdateCollectionPreviewImageView") {
    UpdateCollectionPreviewImageView(item: try! .getDefaultCollectionsArray()[1])
        .padding()
        .previewModifier
}

// MARK: EXTENSIONS
extension UpdateCollectionPreviewImageView {
    // MARK: - Image Overlay Text
    private func imageOverlayText() -> String {
        return collectionsVM.collectionRenameTextfieldText.isEmpty
        ? item.collectionName
        : collectionsVM.collectionRenameTextfieldText.capitalized
    }
}
