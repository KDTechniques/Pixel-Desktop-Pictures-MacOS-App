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
                thumbnailURLString: try! CollectionModel.getDefaultCollectionsArray().first!.getImageURLs().thumb,
                imageURLString: try! CollectionModel.getDefaultCollectionsArray().first!.getImageURLs().regular,
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
