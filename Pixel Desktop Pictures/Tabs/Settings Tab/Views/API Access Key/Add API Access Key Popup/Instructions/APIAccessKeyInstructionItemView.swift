//
//  APIAccessKeyInstructionItemView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-27.
//

import SwiftUI

struct APIAccessKeyInstructionItemView<T: View>: View {
    // MARK: - PROPERTIES
    let content: T
    
    // MARK: - INITIALIZER
    init(@ViewBuilder content: () -> T) {
        self.content = content()
    }
    
    // MARK: - BODY
    var body: some View {
        VStack(alignment: .leading) {
            content
        }
    }
}

// MARK: - PREVIEWS
#Preview("API Access Key Instruction Item View") {
    APIAccessKeyInstructionItemView {
        ForEach(0...5, id: \.self) { _ in
            Text(UUID().uuidString)
        }
    }
    .padding()
    .previewModifier
}
