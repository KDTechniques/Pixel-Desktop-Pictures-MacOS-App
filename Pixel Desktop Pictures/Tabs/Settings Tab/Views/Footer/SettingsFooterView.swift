//
//  SettingsFooterView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-27.
//

import SwiftUI

struct SettingsFooterView: View {
    // MARK: - PROPERTIES
    @Environment(SettingsTabViewModel.self) private var settingsTabVM
    
    // MARK: - BODY
    var body: some View {
        VStack(alignment: .trailing, spacing: 5) {
            HStack {
                eraseAllDataButton
                Spacer()
                restoreToDefaultButton
            }
            
            HStack(alignment: .bottom) {
                appVersionNAuthorText
                Spacer()
                quitButton
            }
        }
    }
}

// MARK: - PREVIEWS
#Preview("Settings Footer View") {
    SettingsFooterView()
        .padding()
        .previewModifier
}

// MARK: EXTENSIONS
extension SettingsFooterView {
    // MARK: - Restore to Defaults Button
    private var restoreToDefaultButton: some View {
        Button {
            settingsTabVM.restoreDefaultSettings()
        } label: {
            Text("Restore Default Settings")
                .foregroundStyle(Color.buttonForeground)
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                .background(Color.buttonBackground, in: .rect(cornerRadius: 5))
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - App Version & Author Text
    private var appVersionNAuthorText: some  View {
        VStack(alignment: .leading, spacing: 2) {
            if let version: String = Utilities.appVersion() {
                Text("Version \(version) 🇱🇰")
                Text("By **KAVINDA DILSHAN PARAMSOODI**")
            }
        }
        .font(.footnote)
    }
    
    // MARK: - Quit Button
    private var quitButton: some View {
        Button {
            settingsTabVM.quitApp()
        } label: {
            Text("Quit")
                .foregroundStyle(Color.buttonForeground)
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                .background(Color.buttonBackground, in: .rect(cornerRadius: 5))
        }
        .buttonStyle(.plain)
    }
    
#if DEBUG
    // MARK: - Erase All Data Button
    private var eraseAllDataButton: some View {
        Button("Erase All Swift Data") {
            Task {
                do {
                    try await LocalDatabaseManager(appEnvironment: .production).eraseAllData()
                } catch {
                    print("❌: Failed to erase all data from swift data. \(error.localizedDescription)")
                }
            }
        }
    }
#endif
}
