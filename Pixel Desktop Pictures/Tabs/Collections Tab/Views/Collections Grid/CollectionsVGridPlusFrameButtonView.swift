//
//  CollectionsVGridPlusFrameButtonView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-23.
//

import SwiftUI

struct CollectionsVGridPlusFrameButtonView: View {
    // MARK: - PROPERTIES
    @Environment(CollectionsTabViewModel.self) private var collectionsTabVM
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
                collectionsTabVM.presentPopup(true, for: .collectionCreationPopOver)
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
    CollectionsVGridPlusFrameButtonView(collectionName: "Nature")
        .environment(
            CollectionsTabViewModel(
                apiAccessKeyManager: .init(),
                collectionManager: .shared(localDatabaseManager: .init(localDatabaseManager: try! .init(appEnvironment: .production))),
                queryImageManager: .shared(localDatabaseManager: .init(localDatabaseManager: try! .init(appEnvironment: .production)))
            )
        )
}

// MARK: EXTENSIONS
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
        let firstItemCollectionNameMatch: Bool = collectionName == collectionsTabVM.collectionsArray.first?.name
        let isEmptyItemsArray: Bool = collectionsTabVM.collectionsArray.isEmpty
        
        return firstItemCollectionNameMatch || isEmptyItemsArray
    }
}
