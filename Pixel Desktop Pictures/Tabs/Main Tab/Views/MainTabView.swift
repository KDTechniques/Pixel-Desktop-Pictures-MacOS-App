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
    @State private var mainTabVM: MainTabViewModel = .init()
    
    // MARK: - BODY
    var body: some View {
        Group {
            if networkManager.connectionStatus == .connected {
//                VStack(spacing: 0) {
//                    // Image Preview
//                    ImageContainerView(
//                        thumbnailURLString: CollectionVGridItemModel.defaultItemsArray.first!.imageURLString,
//                        imageURLString: CollectionVGridItemModel.defaultItemsArray.first!.imageURLString,
//                        location: "Colombo, Sri Lanka"
//                    ) // change this later with a view model property model
//                    
//                    VStack {
//                        // Set Desktop Picture Button
//                        ButtonView(title: "Set Desktop Picture", type: .regular) { mainTabVM.setDesktopPicture() }
//                        
//                        // Author and Download Button
//                        footer
//                    }
//                    .padding()
//                }
                
                ContentNotAvailableView(type: .apiAccessKeyError)
            } else {
                ContentNotAvailableView(type: .noInternetConnection)
            }
        }
        .setTabContentHeightToTabsViewModelViewModifier
        .environment(mainTabVM)
    }
}

// MARK: - PREVIEWS
#Preview("Main Tab View") {
    @Previewable @State var networkManager: NetworkManager = .init()
    PreviewView { MainTabView()  }
        .environment(networkManager)
        .onFirstTaskViewModifier {
            networkManager.initializeNetworkManager()
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
}
