//
//  AddNewCollectionView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-22.
//

import SwiftUI

struct AddNewCollectionView: View {
    // MARK: - PROPERTIES
    @Environment(CollectionsTabViewModel.self) private var collectionsTabVM
    
    // MARK: - BODY
    var body: some View {
        VStack(alignment: .leading) {
            AddNewCollectionTextfieldHeaderView()
            AddNewCollectionTextfieldView()
            ButtonView(
                title: "Create",
                showProgress: collectionsTabVM.showCreateButtonProgress,
                type: .popup) { await collectionsTabVM.createCollection() }
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
            CollectionsTabViewModel(
                apiAccessKeyManager: .init(),
                collectionManager: .shared(localDatabaseManager: .init(localDatabaseManager: try! .init(appEnvironment: .production))),
                queryImageManager: .shared(localDatabaseManager: .init(localDatabaseManager: try! .init(appEnvironment: .production)))
            )
        )
        .previewModifier
}
