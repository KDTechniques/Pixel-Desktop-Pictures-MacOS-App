//
//  SettingsTabView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-22.
//

import SwiftUI

struct SettingsTabView: View {
    // MARK: - INJECTED PROPERTIES
    @Environment(SettingsTabViewModel.self) private var settingsTabVM
    @Environment(APIAccessKeyManager.self) private var apiAccessKeyManager
    
    // MARK: - BODY
    var body: some View {
        VStack(spacing: 0) {
            // Title
            SettingsTitleTextView()
            
            VStack(alignment: .leading) {
                // Launch at Login Checkbox
                CheckboxTextView(isChecked: settingsTabVM.binding(\.launchAtLogin), text: "Launch at login")
                
                // Show on All Spaces Checkbox
                CheckboxTextView(isChecked: settingsTabVM.binding(\.showOnAllSpaces), text: "Show on all spaces")
                
                // Update Time Interval Menu Picker
                UpdateIntervalSettingView()
                
                divider
                
                // Restore Default settings, Version and Quit button
                SettingsFooterView()
            }
            .padding([.horizontal, .bottom])
        }
        .setTabContentHeightToTabsViewModelViewModifier(from: .settings)
    }
}

// MARK: - PREVIEWS
#Preview("Settings Tab View") {
    PreviewView { SettingsTabView() }
}

// MARK: - EXTENSIONS
extension SettingsTabView {
    private var divider: some View {
        Divider()
            .padding(.vertical)
    }
}
