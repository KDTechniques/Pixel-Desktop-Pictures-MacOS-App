//
//  MainTabView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-22.
//

import SwiftUI

struct MainTabView: View {
    // MARK: - PROPERTIES
    @Environment(MainTabViewModel.self) private var mainTabVM
    @Environment(CollectionsTabViewModel.self) private var collectionsTabVM
    
    @State var thumbImageURLString: String = ""
    @State var regularImageURLString: String = ""
    
    // MARK: - BODY
    var body: some View {
        TabContentWithWindowErrorView(tab: .main, content)
    }
}

// MARK: - PREVIEWS
#Preview("Main Tab View") {
    @Previewable @State var networkManager: NetworkManager = .init()
    @Previewable @State var apiAccessKeyManager: APIAccessKeyManager = .init()
    
    PreviewView {
        MainTabView()
            .frame(maxHeight: .infinity)
            .environment(networkManager)
            .environment(apiAccessKeyManager)
            .onFirstTaskViewModifier {
                networkManager.initializeNetworkManager()
                apiAccessKeyManager.apiAccessKeyStatus = .connected
            }
    }
}

// MARK: EXTENSIONS
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
                thumbnailURLString: thumbImageURLString,
                imageURLString: regularImageURLString,
                location: "Colombo, Sri Lanka"
            ) // change this later with a view model property model
            .task {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                handleGetImage(currentImage: true)
            }
            
            VStack {
                // Set Desktop Picture Button
                ButtonView(title: "Set Desktop Picture", type: .regular) {
                    mainTabVM.setDesktopPicture()
                    handleGetImage(currentImage: false)
                }
                
                // Author and Download Button
                footer
            }
            .padding()
        }
    }
}

extension MainTabView {
    func handleGetImage(currentImage: Bool) {
        guard let queryImage: QueryImage = collectionsTabVM.queryImagesArray.first else { return }
        
        let apiAccessKey: String = "Gqa1CTD4LkSdLlUlKH7Gxo8EQNZocXujDfe26KlTQwQ"
        let imageAPIService: UnsplashImageAPIService = .init(apiAccessKey: apiAccessKey)
        
        Task {
            do {
                let queryImageItem: UnsplashQueryImage = try await QueryImageManager.shared(localDatabaseManager: .init(localDatabaseManager: try .init(appEnvironment: .production))).getQueryImage(
                    item: queryImage,
                    isCurrentImage: currentImage,
                    imageAPIService: imageAPIService
                )
                
                regularImageURLString = queryImageItem.imageQualityURLStrings.regular
                thumbImageURLString = queryImageItem.imageQualityURLStrings.thumb
            } catch {
                print("❌: getting UnsplashQueryImage ❌❌❌❌")
            }
        }
    }
}
