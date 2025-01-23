//
//  APIAccessKeyPopupView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-23.
//

import SwiftUI

struct APIAccessKeyPopupView: View {
    // MARK: - INJECTED PROPERTIES
    @Environment(SettingsTabViewModel.self) private var settingsTabVM
    @Environment(APIAccessKeyManager.self) private var apiAccessKeyManager
    
    // MARK: - ASSIGNED PROPERTIES
    let dismissButtonFrameHeight: CGFloat = 30
    
    // MARK: - BODY
    var body: some View {
        VStack(spacing: 0) {
            dismissButton
            
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    // Textfield
                    APIAccessKeyTextfieldView()
                    
                    // Connect Button
                    ButtonView(title: "Connect", type: .popup) { await handleConnect() }
                        .disabled(settingsTabVM.apiAccessKeyTextfieldText.isEmpty ? true : false)
                    
                    // Instructions Container
                    APIAccessKeyInstructionsView()
                        .padding(.top)
                }
                .padding([.horizontal, .bottom])
            }
        }
        .background(Color.bottomPopupBackground)
    }
}

// MARK: - PREVIEWS
#Preview("API Access Key Popup View") {
    @Previewable @State var settingsTabVM: SettingsTabViewModel = .init(
        appEnvironment: .mock,
        mainTabVM: .init(
            collectionsTabVM: .init(apiAccessKeyManager: .init(),
                                    collectionManager: .shared(localDatabaseManager: .init(localDatabaseManager: try! .init(appEnvironment: .mock))),
                                    queryImageManager: .shared(localDatabaseManager: .init(localDatabaseManager: try! .init(appEnvironment: .mock)))),
            recentsTabVM: .init(recentManager: .shared(localDatabaseManager: .init(localDatabaseManager: try! .init(appEnvironment: .mock)))))
    )
    
    APIAccessKeyPopupView()
        .environment(settingsTabVM)
        .previewModifier
        .onAppear {
            settingsTabVM.presentPopup(true)
        }
}

// MARK: EXTENSIONS
extension APIAccessKeyPopupView {
    // MARK: - Dismiss Button
    private var dismissButton: some View {
        Button {
            settingsTabVM.presentPopup(false)
        } label: {
            Image(systemName: "xmark.circle.fill")
                .foregroundStyle(.secondary)
                .symbolRenderingMode(.hierarchical)
                .font(.title2)
                .padding(5)
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity, alignment: .trailing)
        .frame(height: dismissButtonFrameHeight, alignment: .top)
    }
    
    // MARK: - FUNCTIONS
    private func handleConnect() async {
        let tempAPIAccessKey: String = settingsTabVM.apiAccessKeyTextfieldText
        settingsTabVM.dismissPopUp()
        try? await apiAccessKeyManager.connectAPIAccessKey(key: tempAPIAccessKey)
    }
}
