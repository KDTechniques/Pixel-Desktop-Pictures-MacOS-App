//
//  APIAccessKeyPopupView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-23.
//

import SwiftUI

struct APIAccessKeyPopupViewPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct APIAccessKeyPopupView: View {
    // MARK: - PROPERTIES
    @Environment(SettingsTabViewModel.self) private var settingsTabVM
    @Environment(APIAccessKeyManager.self) private var apiAccessKeyManager
    
    // MARK: - PRIVATE PROPERTIES
    @State private var height: CGFloat = 0
    let dismissButtonFrameHeight: CGFloat = 30
    
    // MARK: - BODY
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                // Textfield
                APIAccessKeyTextfieldView()
                
                // Connect Button
                ButtonView(title: "Connect", type: .popup) {
                    Task {
                        let tempAPIAccessKey: String = settingsTabVM.apiAccessKeyTextfieldText
                        settingsTabVM.dismissPopUp()
                        try await apiAccessKeyManager.connectAPIAccessKey(key: tempAPIAccessKey)
                    }
                }
                .disabled(settingsTabVM.apiAccessKeyTextfieldText.isEmpty ? true : false)
                
                // Instructions Container
                APIAccessKeyInstructionsView()
                    .padding(.top)
            }
            .padding([.horizontal, .bottom])
            .background(Color.bottomPopupBackground)
        }
        .padding(.top, dismissButtonFrameHeight)
        .overlay(alignment: .topTrailing) { dismissButton }
        .background {
            GeometryReader { geo in
                Color.bottomPopupBackground
                    .preference(key: APIAccessKeyPopupViewPreferenceKey.self, value: geo.size.height)
            }
            .onPreferenceChange(APIAccessKeyPopupViewPreferenceKey.self) { value in
                height = value
            }
        }
        .offset(y: settingsTabVM.isPresentedPopup ? 0 : height)
        .animation(.smooth(duration: 0.3), value: settingsTabVM.isPresentedPopup)
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
        .background(Color.bottomPopupBackground)
    }
}
