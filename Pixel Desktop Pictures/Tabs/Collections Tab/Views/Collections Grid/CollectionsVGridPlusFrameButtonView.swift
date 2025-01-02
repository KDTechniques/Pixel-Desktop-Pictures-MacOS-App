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
    let id: String
    
    // MARK: - INITIALIZER
    init(id: String) {
        self.id = id
    }
    
    // MARK: - PRIVATE PROPERTIES
    let vGridValues = VGridValuesModel.self
    
    // MARK: - BODY
    var body: some View {
        if canShowPlusButton() {
            Button {
                collectionsVM.presentPopup(true)
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
    CollectionsVGridPlusFrameButtonView(id: CollectionVGridItemModel.defaultItemsArray.first!.id)
        .environment(CollectionsViewModel())
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
        let lastItemIdMatch: Bool = id == collectionsVM.collectionVGridItemsArray.last?.id
        let isEmptyItemsArray: Bool = collectionsVM.collectionVGridItemsArray.isEmpty
        
        return lastItemIdMatch || isEmptyItemsArray
    }
}
