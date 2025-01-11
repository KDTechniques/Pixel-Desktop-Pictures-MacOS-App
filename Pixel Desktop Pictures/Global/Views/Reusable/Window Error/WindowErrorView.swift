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
            
            model.message
        }
        .multilineTextAlignment(.center)
        .fixedSize(horizontal: true, vertical: false)
        .padding()
        .padding(.bottom, 30)
    }
}

// MARK: - PREVIEWS
#Preview("Content Not Available View") {
    WindowErrorView(model: GlobalWindowErrorModel.apiAccessKeyInvalid)
        .previewModifier
}
