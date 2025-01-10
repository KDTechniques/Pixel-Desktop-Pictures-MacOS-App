//
//  CollectionsVGridPlusFrameButtonView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-23.
//

import SwiftUI

struct CollectionsVGridPlusFrameButtonView: View {
    // MARK: - PROPERTIES
    @Environment(CollectionsViewModel.self) private var collectionsVM
    let collectionName: String
    
    // MARK: - INITIALIZER
    init(collectionName: String) {
        self.collectionName = collectionName
    }
    
    // MARK: - PRIVATE PROPERTIES
    let vGridValues = VGridValuesModel.self
    
    // MARK: - BODY
    var body: some View {
        if canShowPlusButton() {
            Button {
                collectionsVM.presentPopup(true, for: .collectionCreationPopOver)
            } label: {
                Rectangle()
                    .fill(Color.collectionPlusFrameBackground)
                    .frame(height: vGridValues.height)
                    .overlay { overlay }
            }
            .buttonStyle(.plain)
        }
    }
}

// MARK: - PREVIEWS
#Preview("Collections VGrid Plus Frame Button View") {
    CollectionsVGridPlusFrameButtonView(collectionName: CollectionItemModel.defaultCollectionsArray.first!.collectionName)
        .environment(CollectionsViewModel(swiftDataManager: try! .init(appEnvironment: .mock)))
}

// MARK: - EXTENSIONS
extension CollectionsVGridPlusFrameButtonView {
    // MARK: - overlay
    private var overlay: some View {
        Image(systemName: "plus")
            .font(.title)
            .foregroundStyle(Color.collectionPlusIcon)
    }
    
    // MARK: FUNCTIONS
    
    // MARK: - Can Show Plus Button
    private func canShowPlusButton() -> Bool {
        let firstItemCollectionNameMatch: Bool = collectionName == collectionsVM.collectionItemsArray.first?.collectionName
        let isEmptyItemsArray: Bool = collectionsVM.collectionItemsArray.isEmpty
        
        return firstItemCollectionNameMatch || isEmptyItemsArray
    }
}
