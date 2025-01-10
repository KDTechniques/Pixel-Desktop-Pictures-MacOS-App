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
    @Environment(CollectionsViewModel.self) private var collectionsVM
    let vGridValues = VGridValuesModel.self
    
    // MARK: - BODY
    var body: some View {
        if let item: CollectionItemModel = collectionsVM.updatingItem {
            VStack(alignment: .leading) {
                UpdateCollectionTextfieldHeaderView()
                UpdateCollectionTextfieldView(collectionName: item.collectionName)
                
                ButtonView(title: "Rename", showProgress: collectionsVM.showRenameButtonProgress, type: .popup) {
                    collectionsVM.updateCollectionName()
                }
                .disabled(collectionsVM.collectionRenameTextfieldText.isEmpty)
                
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
            .background(Color.popupBackground)
            .overlay(alignment: .topTrailing) {
                CollectionPopupDismissButtonView(popOverType: .collectionUpdatePopOver)
            }
        } else {
            Color.clear
        }
    }
}

// MARK: - PREVIEWS
#Preview("Update Collection View") {
    UpdateCollectionView()
        .previewModifier
}

// MARK: - EXTENSIONS
extension UpdateCollectionView {
    // MARK: - Preview Image
    private func previewImage(item: CollectionItemModel) -> some View {
        UpdateCollectionPreviewImageView(
            imageURLs: try! item.getImageURLs(),
            collectionName: item.collectionName
        )
    }
    
    // MARK: - Change Thumbnail Button
    private func changeThumbnailButton(item: CollectionItemModel) -> some View {
        CollectionPopOverSecondaryButtonView(
            title: "Change Thumbnail",
            systemImageName: "arrow.trianglehead.clockwise.rotate.90",
            foregroundColor: Color.textfieldBackground,
            showProgress: collectionsVM.showChangeThumbnailButtonProgress) {
                Task {
                    await collectionsVM.updateCollectionImageURLString(item: item)
                }
            }
    }
    
    // MARK: - Delete Button
    private func deleteButton(item: CollectionItemModel) -> some View {
        CollectionPopOverSecondaryButtonView(
            title: "Delete",
            systemImageName: "trash",
            foregroundColor: Color.red) {
                do {
                    try collectionsVM.deleteCollection(item: item)
                } catch {
                    print("Error: Failed to delete collection: \(item.collectionName).")
                    // show an alert here for deletion error...
                }
            }
    }
}
