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
    let item: CollectionModel
    
    // MARK: - ASSIGNED PROPERTIES
    let vGridValues = VGridValuesModel.self
    let collectionModelManager: CollectionModelManager = .shared
    @State private var imageURLString: String?
    @State private var showImage: Bool = false
    
    // MARK: - INITIALIZER
    init(item: CollectionModel) {
        self.item = item
    }
    
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
        .onChange(of: item.imageURLsData) { _, _ in handleImageURLsDataChange() }
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
    // MARK: - Image Overlay Text
    private func imageOverlayText() -> String {
        return collectionsTabVM.collectionRenameTextfieldText.isEmpty
        ? item.collectionName
        : collectionsTabVM.collectionRenameTextfieldText.capitalized
    }
    
    // MARK: FUNCTIONS
    
    // MARK: - Handle `imageURLsData` Change
    private func handleImageURLsDataChange() {
        Task {
            imageURLString = try? await collectionModelManager.getImageURLs(from: item).small
        }
    }
    
    // MARK: - Handle Task
    private func handleTask() async {
        imageURLString = try? await collectionModelManager.getImageURLs(from: item).small
        try? await Task.sleep(nanoseconds: 500_000_000)
        withAnimation { showImage = true }
    }
}
