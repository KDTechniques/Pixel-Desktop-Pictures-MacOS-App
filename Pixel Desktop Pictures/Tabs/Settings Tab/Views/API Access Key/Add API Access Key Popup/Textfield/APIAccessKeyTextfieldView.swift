//
//  APIAccessKeyTextfieldView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-27.
//

import SwiftUI

struct APIAccessKeyTextfieldView: View {
    // MARK: - PROPERTIES
    @Environment(SettingsTabViewModel.self) private var settingsTabVM
    @Environment(APIAccessKeyManager.self) private var apiAccessKeyManager
    
    // MARK: - BODY
    var body: some View {
        VStack(alignment: .leading) {
            header
            
            TextfieldView(
                textfieldText: settingsTabVM.binding(\.apiAccessKeyTextfieldText),
                localizedKey: "API Access Key",
                prompt: "Ex: 2in4w8v0oGOqdQdPsnKBF2d5-je8fyJs8YkEsfvNaY0") {
                    Task {
                        let tempAPIAccessKey: String = settingsTabVM.apiAccessKeyTextfieldText
                        settingsTabVM.dismissPopUp()
                        await apiAccessKeyManager.connectAPIAccessKey(key: tempAPIAccessKey)
                    }
                }
                .overlay(alignment: .trailing) { pasteFromClipboardButton }
        }
    }
}

// MARK: - PREVIEWS
#Preview("API Access Key Textfield View") {
    APIAccessKeyTextfieldView()
        .padding()
        .environment(SettingsTabViewModel(appEnvironment: .mock))
}

// MARK: - EXTENSIONS
extension APIAccessKeyTextfieldView {
    // MARK: - Header
    private var header: some View {
        Text("Copy, Paste your Unsplash API Access Key here:")
    }
    
    // MARK: - Paste from Clipboard Button
    @ViewBuilder
    private var pasteFromClipboardButton: some View {
        if settingsTabVM.apiAccessKeyTextfieldText.isEmpty {
            Button {
                settingsTabVM.pasteAPIAccessKeyFromClipboard()
            } label: {
                Image(systemName: "doc.on.clipboard.fill")
                    .font(.footnote)
                    .padding(.trailing, 5)
            }
            .buttonStyle(.plain)
        }
    }
}
