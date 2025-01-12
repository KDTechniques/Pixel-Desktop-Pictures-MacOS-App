//
//  CollectionNameOverlayView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-10.
//

import SwiftUI

struct CollectionNameOverlayView: View {
    // MARK: - PROPERTIES
    let collectionName: String
    
    // MARK: - INITIALIZER
    init(collectionName: String) {
        self.collectionName = collectionName
    }
    
    // MARK: - BODY
    var body: some View {
        Text(collectionName)
            .lineLimit(2)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            .padding(8)
    }
}

// MARK: - PREVIEWS
#Preview("Collection Name Overlay View") {
    CollectionNameOverlayView(collectionName: "Nature")
        .padding()
        .previewModifier
}
