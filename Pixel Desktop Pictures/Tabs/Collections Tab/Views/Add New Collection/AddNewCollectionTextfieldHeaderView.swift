//
//  AddNewCollectionTextfieldHeaderView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-23.
//

import SwiftUI

struct AddNewCollectionTextfieldHeaderView: View {
    // MARK: - BODY
    var body: some View {
        VStack(alignment: .leading) {
            Text("Enter a keyword for a custom collection:")
            
            Text("Tip: Use a singular noun for correct results.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - PREVIEWS
#Preview("Add New Collection Textfield Header View") {
    AddNewCollectionTextfieldHeaderView()
        .padding()
        .previewModifier
}
