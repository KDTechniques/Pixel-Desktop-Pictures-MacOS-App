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
                    setDesktopPictureButton
                    footer // Author and Download Button
                }
                .padding()
            }
        }
    }
}

// MARK: - PREVIEWS
#Preview("Main Tab View") {
    PreviewView {
        MainTabView()
            .frame(maxHeight: .infinity)
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
        .disabled(condition || mainTabVM.disableOnFirstLaunch())
    }
    
    private var setDesktopPictureButton: some View {
        ButtonView(
            title: "Set Desktop Picture",
            showProgress: showProgress,
            type: .regular
        ) { await setDesktopPicture() }
            .disabled(mainTabVM.disableOnFirstLaunch())
    }
    
    // MARK: - FUNCTIONS
    
    private func setDesktopPicture() async {
        showProgress = true
        
        do {
            try await setDesktopPictureTask()
        } catch {
            let operation: MainTabDeferredOperationModel = .init(type: .setDesktopPicture, action: setDesktopPictureTask)
            await mainTabVM.checkAPIKeyValidationBeforeExecution(operation: operation)
        }
    }
    
    private func setDesktopPictureTask() async throws {
        try await mainTabVM.setDesktopPicture()
        showProgress = false
    }
}
