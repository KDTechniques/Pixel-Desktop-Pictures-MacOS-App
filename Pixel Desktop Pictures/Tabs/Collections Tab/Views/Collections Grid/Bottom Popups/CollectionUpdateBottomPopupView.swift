//
//  CollectionUpdateBottomPopupView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-12.
//

import SwiftUI

struct CollectionUpdateBottomPopupView: View {
    // MARK: - PROPERTIES
    @Environment(CollectionsViewModel.self) private var collectionsVM
    @State private var collectionUpdatePopOverHeight: CGFloat = 0
    
    // MARK: - BODY
    var body: some View {
        UpdateCollectionView()
            .getBottomPopoverGeometryHeight($collectionUpdatePopOverHeight)
            .offset(y: collectionsVM.popOverItem == (true, .collectionUpdatePopOver) ? 0 : collectionUpdatePopOverHeight)
    }
}

// MARK: - PREVIEWS
#Preview("Collection Update Bottom Popup View") {
    @Previewable @State var collectionsVM: CollectionsViewModel = .init(
        apiAccessKeyManager: .init(),
        swiftDataManager: .init(swiftDataManager: try! .init(appEnvironment: .production))
    )
    
    CollectionUpdateBottomPopupView()
        .environment(collectionsVM)
        .previewModifier
        .onFirstTaskViewModifier {
            collectionsVM.presentPopup(true, for: .collectionUpdatePopOver)
        }
}
