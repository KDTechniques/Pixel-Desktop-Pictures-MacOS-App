//
//  WindowErrorView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-22.
//

import SwiftUI

struct WindowErrorView<T: WindowErrorModelProtocol>: View {
    // MARK: - PROPERTIES
    let model: T
    
    // MARK: - INITIALIZER
    init(model: T) {
        self.model = model
    }
    
    // MARK: - BODY
    var body: some View {
        VStack(spacing: 2) {
            Text(model.title)
                .font(.headline)
            
            model.messageView
        }
        .multilineTextAlignment(.center)
        .fixedSize(horizontal: false, vertical: true)
        .padding()
        .padding(.bottom, model.withBottomPadding ? 30 : 0)
    }
}

// MARK: - PREVIEWS
#Preview("Window Error View") {
    WindowErrorView(model: GlobalWindowErrorModel.random())
        .previewModifier
}
