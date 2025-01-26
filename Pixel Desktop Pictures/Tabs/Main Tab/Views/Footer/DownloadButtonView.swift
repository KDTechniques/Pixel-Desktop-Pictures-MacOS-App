//
//  DownloadButtonView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-26.
//

import SwiftUI

fileprivate enum DownloadState: CaseIterable {
    case none, downloading, downloaded
}

struct DownloadButtonView: View {
    // MARK: - INJECTED PROPERTIES
    @Environment(\.appEnvironment) private var appEnvironment
    @Environment(MainTabViewModel.self) private var mainTabVM
    
    // MARK: - ASSIGNED PROPERTIES
    @State private var downloadState: DownloadState = .none
    
    // MARK: - BODY
    var body: some View {
        Button("Download") {
            Task { await handleTask() }
        }
        .buttonStyle(.plain)
        .opacity(downloadState == .none ? 1 : 0)
        .overlay(alignment: .trailing) { overlay }
    }
}

// MARK: - PREVIEWS
#Preview("Download Button View") {
    DownloadButtonView()
        .padding()
        .previewModifier
        .environment(MainTabViewModel(collectionsTabVM: .init(
            apiAccessKeyManager: .init(),
            collectionManager: .shared(localDatabaseManager: .init(localDatabaseManager: try! .init(appEnvironment: .mock))),
            queryImageManager: .shared(localDatabaseManager: .init(localDatabaseManager: try! .init(appEnvironment: .mock)))),
                                      recentsTabVM: .init(recentManager: .shared(localDatabaseManager: .init(localDatabaseManager: try! .init(appEnvironment: .mock)))))
        )
}

// MARK: - EXTENTIONS
extension DownloadButtonView {
    private var checkmark: some View {
        Image(systemName: "checkmark")
            .fontWeight(.semibold)
    }
    
    private var progressIndicator: some View {
        Image(systemName: "progress.indicator")
            .symbolEffect(.variableColor.iterative)
            .fontWeight(.semibold)
    }
    
    @ViewBuilder
    private var overlay: some View {
        if downloadState == .downloading {
            progressIndicator
        } else if downloadState == .downloaded {
            checkmark
        }
    }
    
    // MARK: - FUNCTIONS
    private func handleTask() async {
        downloadState = .downloading
        
        do {
            try await mainTabVM.downloadImageToDevice(environment: appEnvironment)
            downloadState = .downloaded
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            downloadState = .none
        } catch {
            downloadState = .none
        }
    }
}
