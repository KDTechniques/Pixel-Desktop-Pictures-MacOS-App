//
//  CollectionsGridPopupBackgroundView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-23.
//

import SwiftUI

struct CollectionsGridPopupBackgroundView: View {
    // MARK: - PROPERTIES
    @Environment(CollectionsViewModel.self) private var collectionsVM
    
    // MARK: - BODY
    var body: some View {
        Color.windowBackground
            .opacity(collectionsVM.isPresentedPopup ? 0.8 : 0)
            .animation(collectionsVM.popOverAnimation.0, value: collectionsVM.popOverAnimation.1)
    }
}

// MARK: - PREVIEWS
#Preview("Collections Grid Popup Background View") {
    CollectionsGridPopupBackgroundView()
        .environment(CollectionsViewModel(swiftDataManager: try! .init(appEnvironment: .mock)))
}
