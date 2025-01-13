//
//  UpdateCollectionView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-09.
//

import SwiftUI
import SDWebImageSwiftUI

struct UpdateCollectionView: View {
    // MARK: - PROPERTIES
    @Environment(CollectionsTabViewModel.self) private var collectionsTabVM
    let vGridValues = VGridValuesModel.self
    
    // MARK: - BODY
    var body: some View {
        Group {
            if let item: CollectionModel = collectionsTabVM.updatingItem {
                VStack(alignment: .leading) {
                    UpdateCollectionTextfieldHeaderView()
                    UpdateCollectionTextfieldView(collectionName: item.collectionName)
                    
                    ButtonView(title: "Rename", showProgress: collectionsTabVM.showRenameButtonProgress, type: .popup) {
                        collectionsTabVM.updateCollectionName()
                    }
                    .disabled(collectionsTabVM.collectionRenameTextfieldText.isEmpty)
                    
                    VStack(alignment: .leading) {
                        HStack {
                            previewImage(item: item)
                            
                            VStack(spacing: 0) {
                                changeThumbnailButton(item: item)
                                Spacer()
                                deleteButton(item: item)
                            }
                        }
                        .frame(height: vGridValues.height)
                    }
                }
                .padding()
            } else {
                WindowErrorView(model: CollectionsTabWindowErrorModel.updatingCollectionNotFound)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .background(Color.bottomPopupBackground)
        .overlay(alignment: .topTrailing) {
            CollectionPopupDismissButtonView(popOverType: .collectionUpdatePopOver)
        }
    }
}

// MARK: - PREVIEWS
#Preview("Update Collection View") {
    UpdateCollectionView()
        .previewModifier
}

// MARK: EXTENSIONS
extension UpdateCollectionView {
    // MARK: - Preview Image
    private func previewImage(item: CollectionModel) -> some View {
        UpdateCollectionPreviewImageView(item: item)
    }
    
    // MARK: - Change Thumbnail Button
    private func changeThumbnailButton(item: CollectionModel) -> some View {
        CollectionPopOverSecondaryButtonView(
            title: "Change Thumbnail",
            systemImageName: "arrow.trianglehead.clockwise.rotate.90",
            foregroundColor: Color.textfieldBackground,
            showProgress: collectionsTabVM.showChangeThumbnailButtonProgress) {
                Task {
                    await collectionsTabVM.updateCollectionImageURLString(item: item)
                }
            }
    }
    
    // MARK: - Delete Button
    private func deleteButton(item: CollectionModel) -> some View {
        CollectionPopOverSecondaryButtonView(
            title: "Delete",
            systemImageName: "trash",
            foregroundColor: Color.red) {
                do {
                    try collectionsTabVM.deleteCollection(item: item)
                } catch {
                    print("Error: Failed to delete collection: \(item.collectionName).")
                    // show an alert here for deletion error...
                }
            }
    }
}
