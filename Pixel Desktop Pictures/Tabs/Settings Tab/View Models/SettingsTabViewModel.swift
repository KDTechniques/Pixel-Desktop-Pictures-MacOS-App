//
//  SettingsTabViewModel.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-27.
//

import AppKit

@MainActor
@Observable final class SettingsTabViewModel {
    // MARK: - PROPERTIES
    var launchAtLogin: Bool = false
    var showOnAllSpaces: Bool = false
    var updateIntervalSelection: ImageUpdateIntervalModel = .daily
    var apiAccessKeyStatus: APIAccessKeyValidityStatusModel = .random() // set to validating later as the initial value
    private(set) var isPresentedPopup: Bool = false
    var apiAccessKeyTextfieldText: String = ""
    
    // MARK: - FUNCTIONS
    
    // MARK: - Present Popup
    func presentPopup(_ present: Bool) {
        isPresentedPopup = present
    }
    
    // MARK: - Pate API Access Key from Clipboard
    func pasteAPIAccessKeyFromClipboard() {
        guard let clipboardString = NSPasteboard.general.string(forType: .string) else { return }
        apiAccessKeyTextfieldText = clipboardString
    }
    
    // MARK: - Connect API Access Key
    func connectAPIAccessKey() {
        
    }
    
    // MARK: - Restore Default Settings
    func restoreDefaultSettings() {
        
    }
    
    // MARK: - Quit App
    func quitApp() {
        
    }
}
