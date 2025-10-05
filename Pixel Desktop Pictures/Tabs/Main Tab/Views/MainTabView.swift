//
//  MainTabView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-22.
//

import SwiftUI

struct MainTabView: View {
    // MARK: - INJECTED PROPERTIES
    @Environment(\.appEnvironment) private var appEnvironment
    @Environment(MainTabViewModel.self) private var mainTabVM
    
    // MARK: - ASSIGNED PROPERTIES
    @State private var showProgress: Bool = false
    
    // MARK: - BODY
    var body: some View {
        TabContentWithWindowErrorView(tab: .main) {
            VStack(spacing: 0) {
                // Image Preview
                ImageContainerView()
                
                VStack {
                    // Set Desktop Picture Button
                    ButtonView(
                        title: "Set Desktop Picture",
                        showProgress: showProgress,
                        type: .regular
                    ) { await setDesktopPicture() }
                    
                    // Author and Download Button
                    footer
                }
                .padding()
            }
        }
    }
}

// MARK: - PREVIEWS
#Preview("Main Tab View") {
    @Previewable @State var networkManager: NetworkManager = .shared
    @Previewable @State var apiAccessKeyManager: APIAccessKeyManager = .init()
    
    PreviewView {
        MainTabView()
            .frame(maxHeight: .infinity)
            .environment(networkManager)
            .environment(apiAccessKeyManager)
    }
}

// MARK: EXTENSIONS
extension MainTabView {
    @ViewBuilder
    private var footer: some View {
        let authorName: String? = mainTabVM.currentImage?.user.firstNLastName
        let link: String? = mainTabVM.currentImage?.links.webLinkURL
        let condition: Bool = authorName == nil || link == nil
        
        HStack {
            ImageAuthorView(name: authorName ?? "Unknown", link: link ?? "")
            Spacer()
            DownloadButtonView()
        }
        .padding(.top)
        .opacity(condition ? 0 : 1)
        .disabled(condition)
    }
    
    // MARK: - FUNCTIONS
    
    private func setDesktopPicture() async {
        showProgress = true
        try? await mainTabVM.setDesktopPicture(environment: appEnvironment)
        showProgress = false
    }
}
