//
//  UpdateCollectionTextfieldView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-09.
//

import SwiftUI

struct UpdateCollectionTextfieldView: View {
    // MARK: - PROPERTIES
    @Environment(CollectionsViewModel.self) private var collectionsVM
    let collectionName: String
    
    // MARK: - INITIAIZER
    init(collectionName: String) {
        self.collectionName = collectionName
    }
    
    // MARK: - BODY
    var body: some View {
        TextfieldView(
            textfieldText: collectionsVM.binding(\.collectionRenameTextfieldText),
            localizedKey: "Update Collection Textfield",
            prompt: collectionName) { collectionsVM.updateCollectionName() }
    }
}

// MARK: - PREVIEWS
#Preview("Update Collection Textfield View") {
    UpdateCollectionTextfieldView(collectionName: "Nature")
        .padding()
        .previewModifier
}
