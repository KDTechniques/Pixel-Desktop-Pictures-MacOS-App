//
//  AddNewCollectionTextfieldView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-23.
//

import SwiftUI

struct AddNewCollectionTextfieldView: View {
    // MARK: - PROPERTIES
    @Environment(CollectionsTabViewModel.self) private var collectionsTabVM
    @FocusState private var isFocused: Bool
    
    // MARK: - BODY
    var body: some View {
        TextfieldView(
            textfieldText: Binding(get: { collectionsTabVM.nameTextfieldText }, set: { collectionsTabVM.setNameTextfieldText($0) }),
            localizedKey: "Add New Collection Textfield",
            prompt: "Ex: Super Car") { await collectionsTabVM.createCollection() }
            .focused($isFocused)
            .onAppear { handleOnAppear() }
    }
}

// MARK: - PREVIEWS
#Preview("Add New Collection Textfield View") {
    AddNewCollectionTextfieldView()
        .padding()
        .environment(
            CollectionsTabViewModel(
                apiAccessKeyManager: .init(),
                collectionManager: .shared(localDatabaseManager: .init(localDatabaseManager: try! .init(appEnvironment: .production))),
                queryImageManager: .shared(localDatabaseManager: .init(localDatabaseManager: try! .init(appEnvironment: .production)))
            )
        )
}

// MARK: - EXTENSIONS
extension AddNewCollectionTextfieldView {
    private func handleOnAppear() {
        isFocused = true
    }
}
