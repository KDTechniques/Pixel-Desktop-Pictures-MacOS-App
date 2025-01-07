//
//  APIAccessKeyStatusView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-27.
//

import SwiftUI

struct APIAccessKeyStatusView: View {
    // MARK: - PROPERTIES
    @Environment(SettingsTabViewModel.self) private var settingsVM
    @Environment(APIAccessKeyManager.self) private var apiAccessKeyManager
    
    // MARK: - BODY
    var body: some View {
        HStack(spacing: 5) {
            Text("API Access Key Status:")
            apiAccessKeyManager.apiAccessKeyStatus.status
            apiAccessKeyManager.apiAccessKeyStatus.systemImage
        }
    }
}

// MARK: - BODY
#Preview("API Access Key Status View") {
    APIAccessKeyStatusView()
        .padding()
        .previewModifier
}
