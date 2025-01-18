//
//  UpdateCollectionTextfieldView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-09.
//

import SwiftUI

struct UpdateCollectionTextfieldView: View {
    // MARK: - PROPERTIES
    @Environment(CollectionsTabViewModel.self) private var collectionsTabVM
    let collectionName: String
    
    // MARK: - INITIAIZER
    init(collectionName: String) {
        self.collectionName = collectionName
    }
    
    // MARK: - BODY
    var body: some View {
        TextfieldView(
            textfieldText: Binding(get: { collectionsTabVM.renameTextfieldText }, set: { collectionsTabVM.setRenameTextfieldText($0) }),
            localizedKey: "Update Collection Textfield",
            prompt: collectionName) { collectionsTabVM.renameCollection() }
    }
}

// MARK: - PREVIEWS
#Preview("Update Collection Textfield View") {
    UpdateCollectionTextfieldView(collectionName: "Nature")
        .padding()
        .previewModifier
}
