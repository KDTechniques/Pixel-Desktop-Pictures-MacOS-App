//
//  CollectionsTabView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-22.
//

import SwiftUI

struct CollectionsTabView: View {
    // MARK: - PROPERTIES
    @Environment(CollectionsViewModel.self) private var collectionsVM
    @State private var collectionCreationPopOverHeight: CGFloat = 0
    @State private var collectionUpdatePopOverHeight: CGFloat = 0
    @State private var scrollPosition: ScrollPosition = .init()
    let vGridValues = VGridValuesModel.self
    let nonScrollableItemsCount: Int = 8
    
    // MARK: - BODY
    var body: some View {
        TabContentWithErrorView(tab: .collections) {
            ScrollView(.vertical) {
                LazyVGrid(columns: vGridValues.columns, spacing: vGridValues.spacing) {
                    ForEach(collectionsVM.collectionItemsArray, id: \.self) { item in
                        CollectionsVGridPlusFrameButtonView(collectionName: item.collectionName)
                        CollectionsVGridImageView(item: item)
                    }
                }
                .padding(.horizontal)
            }
            .scrollPosition($scrollPosition)
            .scrollDisabled(collectionsVM.collectionItemsArray.count <= nonScrollableItemsCount)
            .frame(height: TabItemsModel.collections.contentHeight)
            .padding(.bottom)
            .overlay { CollectionsGridPopupBackgroundView() }
            .overlay(alignment: .bottom) { collectionCreationPopOver }
            .overlay(alignment: .bottom) { collectionUpdatePopOver }
            .background(Color.windowBackground)
            .onChange(of: collectionsVM.collectionItemsArray.count) {
                collectionsVM.onCollectionItemsArrayChange(oldValue: $0, newValue: $1, scrollPosition: $scrollPosition)
            }
        }
    }
}

// MARK: - PREVIEWS
#Preview("Collections Grid Tab View") {
    @Previewable @State var networkManager: NetworkManager = .init()
    PreviewView { CollectionsTabView() }
        .environment(networkManager)
        .onFirstAppearViewModifier {
            networkManager.initializeNetworkManager()
        }
}

// MARK: EXTENSIONS
extension CollectionsTabView {
    // MARK: - Collection Creation PopOver
    private var collectionCreationPopOver: some View {
        AddNewCollectionView()
            .getBottomPopoverGeometryHeight($collectionCreationPopOverHeight)
            .offset(y: collectionsVM.popOverItem == (true, .collectionCreationPopOver) ? 0 : collectionCreationPopOverHeight)
    }
    
    // MARK: - Collection Update PopOver
    private var collectionUpdatePopOver: some View {
        UpdateCollectionView()
            .getBottomPopoverGeometryHeight($collectionUpdatePopOverHeight)
            .offset(y: collectionsVM.popOverItem == (true, .collectionUpdatePopOver) ? 0 : collectionUpdatePopOverHeight)
    }
}
