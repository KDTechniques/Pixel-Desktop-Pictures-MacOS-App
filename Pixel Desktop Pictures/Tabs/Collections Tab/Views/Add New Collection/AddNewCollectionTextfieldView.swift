//
//  AddNewCollectionTextfieldView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-23.
//

import SwiftUI

struct AddNewCollectionTextfieldView: View {
    // MARK: - PROPERTIES
    @Environment(CollectionsViewModel.self) private var collectionsVM
    
    // MARK: - BODY
    var body: some View {
        TextfieldView(
            textfieldText: collectionsVM.binding(\.collectionNameTextfieldText),
            localizedKey: "Add New Collection Textfield",
            prompt: "Ex: Super Car") { collectionsVM.createCollection() }
    }
}

// MARK: - PREVIEWS
#Preview("Add New Collection Textfield View") {
    AddNewCollectionTextfieldView()
        .padding()
        .environment(CollectionsViewModel(swiftDataManager: try! .init(appEnvironment: .mock)))
}
