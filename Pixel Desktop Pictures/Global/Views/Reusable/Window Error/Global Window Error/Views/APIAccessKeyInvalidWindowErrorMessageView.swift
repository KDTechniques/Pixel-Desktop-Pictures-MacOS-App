//
//  APIAccessKeyInvalidWindowErrorMessageView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-12.
//

import SwiftUI

struct APIAccessKeyInvalidWindowErrorMessageView: View {
    // MARK: - INJECTED PROPERTIES
    @Environment(APIAccessKeyManager.self) private var apiAccessKeyManager
    
    // MARK: - BODY
    var body: some View {
        VStack(spacing: 30) {
            Text("Your API access key is invalid. Please retry or add a new API access key.")
            
            ButtonView(title: "Retry", type: .regular) {
                Task {
                    await apiAccessKeyManager.apiAccessKeyCheckup()
                }
            }
        }
    }
}

// MARK: - PREVIEWS
#Preview("API Access Key Invalid Window Error Message View") {
    WindowErrorView(model: GlobalWindowError.apiAccessKeyInvalid)
        .padding()
        .previewModifier
}
