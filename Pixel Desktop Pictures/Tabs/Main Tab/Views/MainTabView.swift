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
    @Environment(RecentsTabViewModel.self) private var recentsTabVM
    
    @State var regularImageURLString: String = ""
    @State var isLoading: Bool = false
    
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
                imageURLString: regularImageURLString,
                location: "Colombo, Sri Lanka"
            ) // change this later with a view model property model
            .onFirstTaskViewModifier {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                if recentsTabVM.recentsArray.isEmpty {
                    await handleGetImage(currentImage: true)
                }
            }
            
            VStack {
                // Set Desktop Picture Button
                ButtonView(title: "Set Desktop Picture", type: .regular) {
                    mainTabVM.setDesktopPicture()
                    isLoading = true
                    await handleGetImage(currentImage: false)
                    isLoading = false
                }
                .disabled(isLoading)
                
                // Author and Download Button
                footer
            }
            .padding()
        }
    }
}

extension MainTabView {
    func handleGetImage(currentImage: Bool) async {
        guard let queryImage: QueryImage = collectionsTabVM.queryImagesArray.first else { return }
        
        let apiAccessKey: String = "Gqa1CTD4LkSdLlUlKH7Gxo8EQNZocXujDfe26KlTQwQ"
        let imageAPIService: UnsplashImageAPIService = .init(apiAccessKey: apiAccessKey)
        
        do {
            let queryImageItem: UnsplashQueryImage = try await QueryImageManager.shared(localDatabaseManager: .init(localDatabaseManager: try .init(appEnvironment: .production))).getQueryImage(
                item: queryImage,
                isCurrentImage: currentImage,
                imageAPIService: imageAPIService
            )
            
            regularImageURLString = queryImageItem.imageQualityURLStrings.regular
            
            let data: Data = try JSONEncoder().encode(queryImageItem)
            await recentsTabVM.addRecent(imageEncoded: data)
        } catch {
            print("❌: getting UnsplashQueryImage ❌❌❌❌")
        }
    }
}
