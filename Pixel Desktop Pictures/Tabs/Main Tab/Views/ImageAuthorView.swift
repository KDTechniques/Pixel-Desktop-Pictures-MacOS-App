//
//  ImageAuthorView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-26.
//

import SwiftUI

struct ImageAuthorView: View {
    // MARK: - PROPERTIES
    let name: String
    
    // MARK: - INITIALIZER
    init(name: String) {
        self.name = name
    }
    
    // MARK: - BODY
    var body: some View {
        HStack(spacing: 3) {
            Text("By")
            Text(name)
                .fontWeight(.medium)
        }
    }
}

// MARK: - PREVIEWS
#Preview("Image Author View") {
    ImageAuthorView(name: "John Doe")
        .padding()
        .background(Color.windowBackground)
}
