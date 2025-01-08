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
                Task {
                    do {
                        try await collectionsVM.createCollection(collectionName: collectionsVM.collectionNameTextfieldText)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
        .padding()
        .background(Color.popupBackground)
        .overlay(alignment: .topTrailing) {
            AddNewCollectionPopupDismissButtonView()
        }
    }
}

// MARK: - PREVIEWS
#Preview("Add New Collection View") {
    AddNewCollectionView()
        .frame(width: TabItemsModel.allWindowWidth)
        .environment(CollectionsViewModel(swiftDataManager: try! .init(appEnvironment: .mock)))
}
