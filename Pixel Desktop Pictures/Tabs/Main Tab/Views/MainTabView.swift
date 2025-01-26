//
//  MainTabView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-22.
//

import SwiftUI

struct MainTabView: View {
    // MARK: - INJECTED PROPERTIES
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
            .onFirstTaskViewModifier {
                apiAccessKeyManager.apiAccessKeyStatus = .connected
            }
    }
}

// MARK: EXTENSIONS
extension MainTabView {
    @ViewBuilder
    private var footer: some View {
        let authorName: String? = mainTabVM.currentImage?.user.firstNLastName
        
        HStack {
            ImageAuthorView(name: authorName ?? "")
            Spacer()
            DownloadButtonView()
        }
        .padding(.top)
        .opacity(authorName == nil ? 0 : 1)
        .disabled(authorName == nil)
    }
    
    // MARK: - FUNCTIONS
    private func setDesktopPicture() async {
        showProgress = true
        try? await mainTabVM.setDesktopPicture()
        showProgress = false
    }
}
