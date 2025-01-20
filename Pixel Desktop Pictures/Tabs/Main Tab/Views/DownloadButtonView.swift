//
//  DownloadButtonView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-26.
//

import SwiftUI

struct DownloadButtonView: View {
    // MARK: - PROPERTIES
    @Environment(MainTabViewModel.self) private var mainTabVM
    
    // MARK: - BODY
    var body: some View {
        Button("Download") {
            Task { await mainTabVM.downloadImageToDevice() }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - PREVIEWS
#Preview("Download Button View") {
    DownloadButtonView()
        .padding()
        .environment(MainTabViewModel(collectionsTabVM: .init(
            apiAccessKeyManager: .init(),
            collectionManager: .shared(localDatabaseManager: .init(localDatabaseManager: try! .init(appEnvironment: .mock))),
            queryImageManager: .shared(localDatabaseManager: .init(localDatabaseManager: try! .init(appEnvironment: .mock)))
        )))
}
