//
//  APIAccessRateLimitedWindowErrorMessageView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-12.
//

import SwiftUI

struct APIAccessRateLimitedWindowErrorMessageView: View {
    // MARK: - PROPERTIES
    @Environment(APIAccessKeyManager.self) private var apiAccessKeyManager
    
    // MARK: - BODY
    var body: some View {
        VStack(spacing: 30) {
            Text("Too many changes in a short period. Please wait an hour before retrying.")
            
            ButtonView(title: "Retry", type: .regular) {
                Task {
                    await apiAccessKeyManager.apiAccessKeyCheckup()
                }
            }
        }
    }
}

// MARK: - PREVIEWS
#Preview("API Access Rate Limited Window Error Message View") {
    APIAccessRateLimitedWindowErrorMessageView()
        .previewModifier
}
