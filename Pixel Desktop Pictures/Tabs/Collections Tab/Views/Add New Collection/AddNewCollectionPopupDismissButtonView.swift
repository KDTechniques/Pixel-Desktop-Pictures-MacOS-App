//
//  AddNewCollectionPopupDismissButtonView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-23.
//

import SwiftUI

struct AddNewCollectionPopupDismissButtonView: View {
    // MARK: - PROPERTIES
    @Environment(CollectionsViewModel.self) private var collectionsVM
    
    // MARK: - BODY
    var body: some View {
        Button {
            collectionsVM.presentPopup(false, for: .collectionCreationPopOver)
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
        .environment(CollectionsViewModel(swiftDataManager: try! .init(appEnvironment: .mock)))
}
