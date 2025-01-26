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
    @Environment(CollectionsTabViewModel.self) private var collectionsTabVM
    let item: Collection
    
    // MARK: - INITIALIZER
    init(item: Collection) {
        self.item = item
    }
    
    // MARK: - ASSIGNED PROPERTIES
    private let vGridValues: VGridValues.Type = VGridValues.self
    private var collectionModelManager: CollectionManager { collectionsTabVM.getCollectionManager() }
    @State private var imageURLString: String?
    @State private var showImage: Bool = false
    
    // MARK: - BODY
    var body: some View {
        Group {
            if showImage {
                WebImage(
                    url: .init(string: imageURLString ?? ""),
                    options: [.retryFailed, .highPriority, .continueInBackground]
                )
                .placeholder { ProgressView().scaleEffect(0.3) }
                .resizable()
                .scaledToFill()
                .transition(.fade)
            } else {
                ProgressView().scaleEffect(0.3)
            }
        }
        .frame(width: vGridValues.width, height: vGridValues.height)
        .clipped()
        .overlay(Color.vGridItemOverlay)
        .overlay(CollectionNameOverlayView(collectionName: imageOverlayText()))
        .onChange(of: item.imageQualityURLStringsEncoded) { _, _ in handleImageURLsDataChange() }
        .task { await handleTask() }
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
    private func imageOverlayText() -> String {
        return collectionsTabVM.renameTextfieldText.isEmpty
        ? item.name
        : collectionsTabVM.renameTextfieldText.capitalized
    }
    
    // MARK: - FUNCTIONS
    
    private func handleImageURLsDataChange() {
        Task {
            imageURLString = try? await collectionModelManager.getImageURLs(from: item).small
        }
    }
    
    private func handleTask() async {
        imageURLString = try? await collectionModelManager.getImageURLs(from: item).small
        try? await Task.sleep(nanoseconds: 500_000_000)
        withAnimation { showImage = true }
    }
}
