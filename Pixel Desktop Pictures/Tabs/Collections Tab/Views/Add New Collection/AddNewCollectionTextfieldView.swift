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
    @FocusState private var isFocused: Bool
    
    // MARK: - BODY
    var body: some View {
        TextfieldView(
            textfieldText: collectionsVM.binding(\.collectionNameTextfieldText),
            localizedKey: "Add New Collection Textfield",
            prompt: "Ex: Super Car") { collectionsVM.createCollection() }
            .focused($isFocused)
            .onAppear { handleOnAppear() }
    }
}

// MARK: - PREVIEWS
#Preview("Add New Collection Textfield View") {
    AddNewCollectionTextfieldView()
        .padding()
        .environment(
            CollectionsViewModel(
                apiAccessKeyManager: .init(),
                swiftDataManager: .init(swiftDataManager: try! .init(appEnvironment: .mock)),
                errorPopupVM: .init())
        )
}

// MARK: - EXTENSIONS
extension AddNewCollectionTextfieldView {
    // MARK: - handleOnAppear
    private func handleOnAppear() {
        isFocused = true
    }
}
