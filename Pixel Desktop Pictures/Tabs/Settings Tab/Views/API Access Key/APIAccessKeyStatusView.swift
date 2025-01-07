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
    @Environment(NetworkManager.self) private var networkManager
    
    // MARK: - BODY
    var body: some View {
        HStack(spacing: 5) {
            Text("API Access Key Status:")
            apiAccessKeyManager.apiAccessKeyStatus.status
            apiAccessKeyManager.apiAccessKeyStatus.systemImage
        }
        .onChange(of: networkManager.connectionStatus) { onChangeOfInternetConnection($1) }
    }
}

// MARK: - BODY
#Preview("API Access Key Status View") {
    APIAccessKeyStatusView()
        .padding()
        .previewModifier
}

// MARK: - EXTENSIONS
extension APIAccessKeyStatusView {
    // MARK: - On Change of Internet Connection
    private func onChangeOfInternetConnection(_ status: InternetConnectionStatusModel) {
        guard apiAccessKeyManager.apiAccessKeyStatus == .failed,
              status == .connected else {
            return
        }
        
        apiAccessKeyManager.apiAccessKeyStatus = .notFound
    }
}
