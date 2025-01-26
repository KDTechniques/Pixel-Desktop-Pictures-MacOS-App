//
//  CollectionsVGridImageView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-23.
//

import SwiftUI
import SDWebImageSwiftUI

struct CollectionsVGridImageView: View {
    // MARK: - INJECTED PROPERTIES
    let item: Collection
    
    // MARK: - ASSIGNED PROPERTIES
    @Environment(CollectionsTabViewModel.self) private var collectionsTabVM
    @State private var showEditButton: Bool = false
    @State private var imageURLString: String?
    
    // MARK: - INITIALIZER
    init(item: Collection) {
        self.item = item
    }
    
    // MARK: - PRIVATE PROPERTIES
    let vGridValues = VGridValues.self
    
    // MARK: - BODY
    var body: some View {
        WebImage(
            url: .init(string: imageURLString ?? ""),
            options: [.retryFailed, .continueInBackground, .highPriority, .scaleDownLargeImages]
        )
        .placeholder { placeholder }
        .resizable()
        .scaledToFill()
        .frame(width: vGridValues.width, height: vGridValues.height)
        .clipped()
        .overlay(Color.vGridItemOverlay)
        .overlay { overlay }
        .onHover { handleHover($0) }
        .onTapGesture { handleTap() }
        .onLongPressGesture { handleLongTap() }
        .onChange(of: item.imageQualityURLStringsEncoded) { _, _ in handleImageURLsDataChange() }
        .task { await handleTask() }
    }
}

// MARK: - PREVIEWS
#Preview("Collections VGrid Image View") {
    CollectionsVGridImageView(item: try! .getDefaultCollectionsArray()[3])
        .frame(width: 120)
        .padding()
        .environment(
            CollectionsTabViewModel(
                apiAccessKeyManager: .init(),
                collectionManager: .shared(localDatabaseManager: .init(localDatabaseManager: try! .init(appEnvironment: .production))),
                queryImageManager: .shared(localDatabaseManager: .init(localDatabaseManager: try! .init(appEnvironment: .production)))
            )
        )
        .previewModifier
}

// MARK: EXTENSIONS
extension CollectionsVGridImageView {
    // MARK: - Placeholder
    @ViewBuilder
    private var placeholder: some View {
        if item.name != Collection.randomKeywordString {
            ProgressView().scaleEffect(0.3)
        }
    }
    
    // MARK: - Checkmark
    private var checkmark: some View {
        Image(systemName: "checkmark")
            .font(.subheadline.bold())
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding(6)
            .opacity(item.isSelected ? 1 : 0)
    }
    
    // MARK: - Edit Button
    private var editButton: some View {
        Button {
            Task {
                collectionsTabVM.setUpdatingItem(item)
                collectionsTabVM.presentPopup(true, for: .collectionUpdatePopOver)
            }
        } label: {
            Image(systemName: "applepencil.gen1")
                .font(.subheadline)
                .fontWeight(.black)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(6)
        }
        .opacity(item.isEditable ? 1 : 0)
        .opacity(showEditButton ? 1 : 0)
        .buttonStyle(.plain)
        .disabled(!item.isEditable)
    }
    
    // MARK: - Overlay
    private var overlay: some View {
        Group {
            checkmark
            CollectionNameOverlayView(collectionName: item.name)
            editButton
        }
        .foregroundStyle(.white)
    }
    
    // MARK: FUNCTIONS
    private func handleTap() {
        Task {
            await collectionsTabVM.updateCollectionSelection(item: item)
        }
    }
    
    private func handleLongTap() {
        Task {
            await collectionsTabVM.updateCollectionSelections(excludedItem: item)
        }
    }
    
    private func handleHover(_ isHovering: Bool) {
        withAnimation(.smooth(duration: 0.3)) {
            showEditButton = isHovering
        }
    }
    
    private func handleImageURLsDataChange() {
        Task { await handleTask() }
    }
    
    private func handleTask() async {
        imageURLString = try? await collectionsTabVM.getCollectionManager().getImageURLs(from: item).small
    }
}
