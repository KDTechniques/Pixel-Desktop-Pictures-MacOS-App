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
        TextField("",
                  text: collectionsVM.binding(\.collectionNameTextfieldText),
                  prompt: Text("Ex: Landscapes")
        )
        .textFieldStyle(.plain)
        .textSelection(.enabled)
        .padding(5)
        .padding(.trailing, 25)
        .background(
            Color.textfieldBackground
                .clipShape(.rect(cornerRadius: 5))
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.textfieldBorder, lineWidth: 1)
                }
        )
        .overlay(alignment: .trailing) {
            Button {
                collectionsVM.collectionNameTextfieldText = ""
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.secondary)
                    .padding(5)
            }
            .buttonStyle(.plain)
            .opacity(collectionsVM.collectionNameTextfieldText == "" ? 0 : 1)
        }
        .onSubmit { collectionsVM.createCollection() }
    }
}

// MARK: - PREVIEWS
#Preview("Add New Collection Textfield View") {
    AddNewCollectionTextfieldView()
        .padding()
        .environment(CollectionsViewModel())
}
