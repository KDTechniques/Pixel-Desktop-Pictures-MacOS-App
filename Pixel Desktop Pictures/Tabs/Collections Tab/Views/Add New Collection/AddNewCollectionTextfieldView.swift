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
            textfieldText: collectionsTabVM.binding(\.collectionNameTextfieldText),
            localizedKey: "Add New Collection Textfield",
            prompt: "Ex: Super Car") { collectionsTabVM.createCollection() }
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
                collectionModelSwiftDataManager: .init(swiftDataManager: try! .init(appEnvironment: .mock)),
                imageQueryURLModelSwiftDataManager: .init(swiftDataManager: try! .init(appEnvironment: .mock)),
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
