//
//  AddNewCollectionView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-22.
//

import SwiftUI

struct AddNewCollectionView: View {
    // MARK: - PROPERTIES
    @Environment(CollectionsViewModel.self) private var collectionsVM
    
    // MARK: - BODY
    var body: some View {
        VStack(alignment: .leading) {
            AddNewCollectionTextfieldHeaderView()
            AddNewCollectionTextfieldView()
            ButtonView(title: "Create", showProgress: collectionsVM.showCreateButtonProgress, type: .popup) {
                collectionsVM.createCollection()
            }
            .disabled(collectionsVM.collectionNameTextfieldText.isEmpty)
        }
        .padding()
        .background(Color.bottomPopupBackground)
        .overlay(alignment: .topTrailing) {
            CollectionPopupDismissButtonView(popOverType: .collectionCreationPopOver)
        }
    }
}

// MARK: - PREVIEWS
#Preview("Add New Collection View") {
    AddNewCollectionView()
        .frame(width: TabItemsModel.allWindowWidth)
        .environment(
            CollectionsViewModel(
                apiAccessKeyManager: .init(),
                swiftDataManager: .init(swiftDataManager: try! .init(appEnvironment: .mock)))
        )
        .previewModifier
}
