//
//  MainTabView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-22.
//

import SwiftUI

struct MainTabView: View {
    // MARK: - PROPERTIES
    @Environment(NetworkManager.self) private var networkManager
    @Environment(MainTabViewModel.self) private var mainTabVM
    @Environment(APIAccessKeyManager.self) private var apiAccessKeyManager
    @Environment(SwiftDataManager.self) private var swiftDataManager
    
    // MARK: - BODY
    var body: some View {
        Group {
            if networkManager.connectionStatus == .connected {
                switch apiAccessKeyManager.apiAccessKeyStatus {
                case .notFound, .validating, .failed: ContentNotAvailableView(type: .apiAccessKeyNotFound)
                case .invalid: ContentNotAvailableView(type: .apiAccessKeyError)
                case .connected : content
                }
            } else {
                ContentNotAvailableView(type: .noInternetConnection)
            }
        }
        .setTabContentHeightToTabsViewModelViewModifier(from: .main)
    }
}

// MARK: - PREVIEWS
#Preview("Main Tab View") {
    @Previewable @State var networkManager: NetworkManager = .init()
    @Previewable @State var apiAccessKeyManager: APIAccessKeyManager = .init()
    PreviewView { MainTabView()  }
        .environment(networkManager)
        .environment(apiAccessKeyManager)
        .onFirstTaskViewModifier {
            networkManager.initializeNetworkManager()
            try? await apiAccessKeyManager.initializeAPIAccessKeyManager()
            await apiAccessKeyManager.connectAPIAccessKey(key: "Gqa1CTD4LkSdLlUlKH7Gxo8EQNZocXujDfe26KlTQwQ")
        }
}

// MARK: - EXTENSIONS
extension MainTabView {
    // MARK: - Footer
    private var footer: some View {
        HStack {
            ImageAuthorView(name: "John Doe") // change this later with a view model property model
            Spacer()
            DownloadButtonView()
        }
        .padding(.top)
    }
    
    private var content: some View {
        VStack(spacing: 0) {
            // Image Preview
            ImageContainerView(
                thumbnailURLString: try! CollectionItemModel.defaultCollectionsArray.first!.getImageURLs().thumb,
                imageURLString: try! CollectionItemModel.defaultCollectionsArray.first!.getImageURLs().regular,
                location: "Colombo, Sri Lanka"
            ) // change this later with a view model property model
            
            VStack {
                // Set Desktop Picture Button
                ButtonView(title: "Set Desktop Picture", type: .regular) { mainTabVM.setDesktopPicture() }
                
                // Author and Download Button
                footer
            }
            .padding()
        }
    }
}
