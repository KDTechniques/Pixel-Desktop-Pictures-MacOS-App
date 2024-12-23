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
            ButtonView(title: "Create", type: .popup) { collectionsVM.createCollection() }
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
        .frame(width: Utilities.allWindowWidth)
        .environment(CollectionsViewModel())
}
