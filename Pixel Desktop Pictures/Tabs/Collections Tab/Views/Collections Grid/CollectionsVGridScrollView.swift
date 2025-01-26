//
//  CollectionsVGridScrollView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-12.
//

import SwiftUI

struct CollectionsVGridScrollView: View {
    // MARK: - INJECTED PROPERTIES
    @Environment(CollectionsTabViewModel.self) private var collectionsTabVM
    @Binding var scrollPosition: ScrollPosition
    
    // MARK: - INITIALIZER
    init(scrollPosition: Binding<ScrollPosition>) {
        _scrollPosition = scrollPosition
    }
    
    // MARK: - ASSIGNED PROPERTIES
    let vGridValues: VGridValues.Type = VGridValues.self
    let nonScrollableItemsCount: Int = 8
    
    // MARK: - BODY
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: vGridValues.columns, spacing: vGridValues.spacing) {
                ForEach(collectionsTabVM.collectionsArray, id: \.self) { item in
                    CollectionsVGridPlusFrameButtonView(collectionName: item.name)
                    CollectionsVGridImageView(item: item)
                }
            }
            .padding(.horizontal)
        }
        .scrollPosition($scrollPosition)
        .scrollDisabled(collectionsTabVM.collectionsArray.count <= nonScrollableItemsCount)
        .frame(height: TabItem.collections.contentHeight)
        .padding(.bottom)
        .overlay { CollectionsGridPopupBackgroundView() }
        .overlay(alignment: .bottom) { bottomPopup }
    }
}

// MARK: - PREVIEWS
#Preview("Collections VGrid Scroll View") {
    CollectionsVGridScrollView(scrollPosition: .constant(.init(edge: .top)))
        .previewModifier
}

// MARK: - EXTENSIONS
extension CollectionsVGridScrollView {
    @ViewBuilder
    private var bottomPopup: some View {
        if collectionsTabVM.popOverItem == (true, .collectionCreationPopOver) {
            AddNewCollectionView()
                .transition(.move(edge: .bottom))
        }
        
        if collectionsTabVM.popOverItem == (true, .collectionUpdatePopOver) {
            UpdateCollectionView()
                .transition(.move(edge: .bottom))
        }
    }
}
