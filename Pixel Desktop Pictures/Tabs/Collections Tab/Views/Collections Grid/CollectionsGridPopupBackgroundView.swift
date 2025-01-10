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
            .opacity(collectionsVM.popOverItem.isPresented ? 0.8 : 0)
            .onTapGesture { handleTap() }
    }
}

// MARK: - PREVIEWS
#Preview("Collections Grid Popup Background View") {
    CollectionsGridPopupBackgroundView()
        .environment(CollectionsViewModel(swiftDataManager: try! .init(appEnvironment: .mock)))
}

extension CollectionsGridPopupBackgroundView {
    // MARK: - Handle Tap
    private func handleTap() {
        collectionsVM.presentPopup(false, for: collectionsVM.popOverItem.type)
    }
}
