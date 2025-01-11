//
//  CollectionCreationBottomPopupView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-12.
//

import SwiftUI

struct CollectionCreationBottomPopupView: View {
    // MARK: - PROPERTIES
    @Environment(CollectionsViewModel.self) private var collectionsVM
    @State private var collectionCreationPopOverHeight: CGFloat = 0
    
    // MARK: - BODY
    var body: some View {
        AddNewCollectionView()
            .getBottomPopoverGeometryHeight($collectionCreationPopOverHeight)
            .offset(y: collectionsVM.popOverItem == (true, .collectionCreationPopOver) ? 0 : collectionCreationPopOverHeight)
    }
}

// MARK: - PREVIEWS
#Preview("Collection Creation Bottom Popup View") {
    @Previewable @State var collectionsVM: CollectionsViewModel = .init(
        apiAccessKeyManager: .init(),
        swiftDataManager: .init(swiftDataManager: try! .init(appEnvironment: .production))
    )
    
    CollectionCreationBottomPopupView()
        .environment(collectionsVM)
        .previewModifier
        .onFirstTaskViewModifier {
            collectionsVM.presentPopup(true, for: .collectionCreationPopOver)
        }
}
