//
//  CollectionsVGridImageView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-23.
//

import SwiftUI
import SDWebImageSwiftUI


struct VGridItemWidthPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct CollectionsVGridImageView: View {
    // MARK: - INJECTED PROPERTIES
    let item: CollectionModel
    
    // MARK: - ASSIGNED PROPERTIES
    @Environment(CollectionsViewModel.self) private var collectionsVM
    @State private var showEditButton: Bool = false
    @State private var imageURLString: String?
    let collectionModelManager: CollectionModelManager = .shared
    
    // MARK: - INITIALIZER
    init(item: CollectionModel) {
        self.item = item
    }
    
    // MARK: - PRIVATE PROPERTIES
    let vGridValues = VGridValuesModel.self
    
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
        .onChange(of: item.imageURLsData) { _, _ in handleImageURLsDataChange() }
        .task { await handleTask() }
    }
}

// MARK: - PREVIEWS
#Preview("Collections VGrid Image View") {
    CollectionsVGridImageView(item: try! .getDefaultCollectionsArray()[3])
        .frame(width: 120)
        .padding()
        .environment(
            CollectionsViewModel(
                apiAccessKeyManager: .init(),
                swiftDataManager: .init(swiftDataManager: try! .init(appEnvironment: .mock)),
                errorPopupVM: .init())
        )
        .previewModifier
}

// MARK: EXTENSIONS
extension CollectionsVGridImageView {
    // MARK: - Placeholder
    @ViewBuilder
    private var placeholder: some View {
        if item.collectionName != CollectionModel.randomKeywordString {
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
                collectionsVM.updatingItem = item
                collectionsVM.presentPopup(true, for: .collectionUpdatePopOver)
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
            CollectionNameOverlayView(collectionName: item.collectionName)
            editButton
        }
        .foregroundStyle(.white)
    }
    
    // MARK: FUNCTIONS
    
    // MARK: - Handle Tap
    private func handleTap() {
        collectionsVM.updateCollectionSelection(item: item)
    }
    
    // MARK: - Handle Hover
    private func handleHover(_ isHovering: Bool) {
        withAnimation(.smooth(duration: 0.3)) {
            showEditButton = isHovering
        }
    }
    
    // MARK: - Handle `imageURLsData` Change
    private func handleImageURLsDataChange() {
        Task { await handleTask() }
    }
    
    // MARK: - Handle Task
    private func handleTask() async {
        imageURLString = try? await collectionModelManager.getImageURLs(from: item).small
    }
}
