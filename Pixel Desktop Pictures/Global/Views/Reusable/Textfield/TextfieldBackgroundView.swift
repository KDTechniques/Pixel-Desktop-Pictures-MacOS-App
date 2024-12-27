//
//  TextfieldBackgroundView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-24.
//

import SwiftUI

struct TextfieldBackgroundView: View {
    // MARK: - BODY
    var body: some View {
        Color.textfieldBackground
            .clipShape(.rect(cornerRadius: 5))
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.textfieldBorder, lineWidth: 1)
            }
    }
}

// MARK: - PREVIEWS
#Preview("Textfield Background View") {
    TextfieldBackgroundView()
}
