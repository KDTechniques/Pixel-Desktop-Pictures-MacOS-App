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
    // MARK: - PROPERTIES
    @Environment(CollectionsViewModel.self) private var collectionsVM
    let item: CollectionItemModel
    @State private var showEditButton: Bool = false
    
    // MARK: - INITIALIZER
    init(item: CollectionItemModel) {
        self.item = item
    }
    
    // MARK: - PRIVATE PROPERTIES
    let vGridValues = VGridValuesModel.self
    
    // MARK: - BODY
    var body: some View {
        WebImage(
            url: .init(string: item.imageURLString),
            options: [.retryFailed, .continueInBackground, .highPriority, .scaleDownLargeImages]
        )
        .placeholder { Color.vGridItemPlaceholder }
        .resizable()
        .frame(height: vGridValues.height)
        .clipped()
        .overlay { Color.black.opacity(0.4) }
        .overlay { overlay }
        .onHover { handleHover($0) }
        .onTapGesture { handleTap() }
    }
}

// MARK: - PREVIEWS
#Preview("Collections VGrid Image View") {
    CollectionsVGridImageView(item: .defaultCollectionsArray.first!)
        .frame(width: 120)
        .padding()
        .environment(CollectionsViewModel(swiftDataManager: try! .init(appEnvironment: .mock)))
        .previewModifier
}

extension CollectionsVGridImageView {
    // MARK: - checkmark
    private var checkmark: some View {
        Image(systemName: "checkmark")
            .font(.subheadline.bold())
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding(6)
            .opacity(item.isSelected ? 1 : 0)
    }
    
    // MARK: - Collection Name Text
    private var collectionName: some View {
        Text(item.collectionName)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            .padding(8)
    }
    
    private var editButton: some View {
        Button {
            // open up another sheet here, rename the first popup befoe creating a new one.
            try! collectionsVM.deleteCollection(item)
        } label: {
            Image(systemName: "applepencil.gen1")
                .font(.subheadline)
                .fontWeight(.black)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(6)
                .opacity(item.isEditable ? 1 : 0)
                .opacity(showEditButton ? 1 : 0)
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - overlay
    private var overlay: some View {
        Group {
            checkmark
            collectionName
            editButton
        }
        .foregroundStyle(.white)
    }
    
    // MARK: FUNCTIONS
    
    // MARK: - Handle Tap
    private func handleTap() { // create a function in collection view model to handle tap gesture to remove selection when click on random and so on.
        Task {
            await collectionsVM.updateCollectionSelectionStatus(item: item, isSelected: !item.isSelected)
        }
    }
    
    // MARK: - Handle Hover
    private func handleHover(_ isHovering: Bool) {
        withAnimation(.smooth(duration: 0.3)) {
            showEditButton = isHovering
        }
    }
}
