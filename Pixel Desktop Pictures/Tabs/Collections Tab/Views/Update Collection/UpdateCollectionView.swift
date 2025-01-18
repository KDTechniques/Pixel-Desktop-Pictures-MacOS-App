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
            if let item: Collection = collectionsTabVM.updatingItem {
                VStack(alignment: .leading) {
                    UpdateCollectionTextfieldHeaderView()
                    UpdateCollectionTextfieldView(collectionName: item.name)
                    
                    ButtonView(
                        title: "Rename",
                        showProgress: collectionsTabVM.showRenameButtonProgress,
                        type: .popup) { await collectionsTabVM.renameCollection() }
                    
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
    private func previewImage(item: Collection) -> some View {
        UpdateCollectionPreviewImageView(item: item)
    }
    
    // MARK: - Change Thumbnail Button
    private func changeThumbnailButton(item: Collection) -> some View {
        CollectionPopOverSecondaryButtonView(
            title: "Change Thumbnail",
            systemImageName: "arrow.trianglehead.clockwise.rotate.90",
            foregroundColor: Color.textfieldBackground,
            showProgress: collectionsTabVM.showChangeThumbnailButtonProgress) {
                Task {
                    await collectionsTabVM.changeCollectionThumbnailImage(item: item)
                }
            }
    }
    
    // MARK: - Delete Button
    private func deleteButton(item: Collection) -> some View {
        CollectionPopOverSecondaryButtonView(
            title: "Delete",
            systemImageName: "trash",
            foregroundColor: Color.red) {
                Task {
                    await collectionsTabVM.deleteCollection(at: item)
                }
            }
    }
}
