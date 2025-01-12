//
//  CollectionPopupDismissButtonView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-09.
//

import SwiftUI

struct CollectionPopupDismissButtonView: View {
    // MARK: - PROPERTIES
    @Environment(CollectionsViewModel.self) private var collectionsVM
    let popOverType: CollectionsViewPopOverModel
    
    // MARK: - INITIALIZER
    init(popOverType: CollectionsViewPopOverModel) {
        self.popOverType = popOverType
    }
    
    // MARK: - BODY
    var body: some View {
        Button {
            collectionsVM.presentPopup(false, for: popOverType)
        } label: {
            Image(systemName: "xmark.circle.fill")
                .foregroundStyle(.secondary)
                .symbolRenderingMode(.hierarchical)
                .font(.title2)
                .padding(5)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - PREVIEWS
#Preview("Collection Popup Dismiss Button View") {
    CollectionPopupDismissButtonView(popOverType: .random())
        .previewModifier
}
