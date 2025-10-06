//
//  CollectionsGridPopupBackgroundView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-23.
//

import SwiftUI

struct CollectionsGridPopupBackgroundView: View {
    // MARK: - PROPERTIES
    @Environment(CollectionsTabViewModel.self) private var collectionsTabVM
    
    // MARK: - BODY
    var body: some View {
        Color.windowBackground
            .opacity(collectionsTabVM.popOverItem.isPresented ? 0.8 : 0)
            .onTapGesture { handleTap() }
    }
}

// MARK: - PREVIEWS
#Preview("Collections Grid Popup Background View") {
    CollectionsGridPopupBackgroundView()
        .previewModifier
}

// MARK: - EXTENSIONS
extension CollectionsGridPopupBackgroundView {
    private func handleTap() {
        collectionsTabVM.presentPopup(false, for: collectionsTabVM.popOverItem.type)
    }
}
