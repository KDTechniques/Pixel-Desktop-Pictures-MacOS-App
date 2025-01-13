//
//  AddNewCollectionPopupDismissButtonView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-23.
//

import SwiftUI

struct AddNewCollectionPopupDismissButtonView: View {
    // MARK: - PROPERTIES
    @Environment(CollectionsTabViewModel.self) private var collectionsTabVM
    
    // MARK: - BODY
    var body: some View {
        Button {
            collectionsTabVM.presentPopup(false, for: .collectionCreationPopOver)
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
#Preview("Add New Collection Textfield Reset Button View") {
    AddNewCollectionPopupDismissButtonView()
        .padding()
        .environment(
            CollectionsTabViewModel(
                apiAccessKeyManager: .init(),
                collectionModelSwiftDataManager: .init(swiftDataManager: try! .init(appEnvironment: .mock)),
                imageQueryURLModelSwiftDataManager: .init(swiftDataManager: try! .init(appEnvironment: .mock)),
                errorPopupVM: .init()
            )
        )
}
