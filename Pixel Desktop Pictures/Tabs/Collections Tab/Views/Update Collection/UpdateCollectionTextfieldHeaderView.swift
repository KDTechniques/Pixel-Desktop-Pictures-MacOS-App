//
//  UpdateCollectionTextfieldHeaderView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-09.
//

import SwiftUI

struct UpdateCollectionTextfieldHeaderView: View {
    // MARK: - BODY
    var body: some View {
        VStack(alignment: .leading) {
            Text("Rename collection:")
            
            Text("Tip: Use a singular noun for correct results.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - PREVIEWS
#Preview("Update Collection Textfield Header View") {
    UpdateCollectionTextfieldHeaderView()
        .padding()
        .previewModifier
}
