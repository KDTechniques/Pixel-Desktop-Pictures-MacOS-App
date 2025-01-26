//
//  ImageAuthorView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-26.
//

import SwiftUI

struct ImageAuthorView: View {
    // MARK: - INJECTED PROPERTIES
    let name: String
    let link: String
    
    // MARK: - INITIALIZER
    init(name: String, link: String) {
        self.name = name
        self.link = link
    }
    
    // MARK: - BODY
    var body: some View {
        if let url: URL = .init(string: link) {
            Link(destination: url) { label }
                .buttonStyle(.plain)
        } else {
            label
        }
    }
}

// MARK: - PREVIEWS
#Preview("Image Author View") {
    ImageAuthorView(name: "John Doe", link: "")
        .padding()
        .background(Color.windowBackground)
}

// MARK: - EXTENSIONS
extension ImageAuthorView {
    private var label: some View {
        HStack(spacing: 3) {
            Text("By")
            Text(name)
                .fontWeight(.medium)
        }
    }
}
