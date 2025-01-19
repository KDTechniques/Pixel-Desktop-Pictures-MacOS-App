//
//  BlurPlaceholderView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-19.
//

import SwiftUI

struct BlurPlaceholderView: View {
    // MARK: - INJECTED PROPERTIES
    let blurRadius: CGFloat
    
    // MARK: - INITIALIZER
    init(blurRadius: CGFloat) {
        self.blurRadius = blurRadius
    }
    
    // MARK: - BODY
    var body: some View {
        MeshGradient(
            width: 4,
            height: 4,
            points: [
                .init(0, 0), .init(0.5, 0), .init(1, 0),
                .init(0, 0.5), .init(0.3, 0.5), .init(1, 0.5),
                .init(0, 1), .init(0.5, 1), .init(1, 1)
            ],
            colors: [
                .debug, .debug, .debug,
                .debug, .debug, .debug,
                .debug, .debug, .debug
            ]
        )
        .blur(radius: blurRadius)
    }
}

// MARK: - PREVIEW
#Preview("Blur Placeholder View") {
    BlurPlaceholderView(blurRadius: 20)
        .previewModifier
}
