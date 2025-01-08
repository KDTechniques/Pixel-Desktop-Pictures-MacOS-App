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
    let item: CollectionVGridItemModel
    
    // MARK: - INITIALIZER
    init(item: CollectionVGridItemModel) {
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
        .onTapGesture { handleTap() }
    }
}

// MARK: - PREVIEWS
#Preview("Collections VGrid Image View") {
    CollectionsVGridImageView(item: .defaultCollectionsArray.first!)
        .frame(width: 120)
        .padding()
        .environment(CollectionsViewModel())
}

extension CollectionsVGridImageView {
    // MARK: - checkmark
    private var checkmark: some View {
        Image(systemName: "checkmark")
            .font(.subheadline)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding(6)
            .opacity(collectionsVM.selectedCollectionsArray.contains(where: { $0.id == item.id }) ? 1 : 0)
    }
    
    // MARK: - Collection Name Text
    private var collectionName: some View {
        Text(item.collectionName)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            .padding(8)
    }
    
    // MARK: - overlay
    private var overlay: some View {
        Group {
            checkmark
            collectionName
        }
        .foregroundStyle(.white)
    }
    
    // MARK: FUNCTIONS
    
    // MARK: - Handle Tap
    private func handleTap() {
        collectionsVM.setSelectedCollection(item)
    }
}
