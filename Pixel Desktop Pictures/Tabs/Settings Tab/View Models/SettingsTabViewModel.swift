//
//  SettingsTabViewModel.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-27.
//

import AppKit

@MainActor
@Observable final class SettingsTabViewModel {
    // MARK: - INJECTED PROPERTIES
    let desktopPictureScheduler: DesktopPictureScheduler
    
    // MARK: - ASSIGNED PROPERTIES
    var launchAtLogin: Bool = false {
        didSet {
            guard oldValue != launchAtLogin else { return }
            Task { await saveLaunchAtLoginToUserDefaults(launchAtLogin) }
        }
    }
    var showOnAllSpaces: Bool = false {
        didSet {
            guard oldValue != showOnAllSpaces else { return }
            Task { await saveShowOnAllSpacesToUserDefaults(showOnAllSpaces) }
        }
    }
    var updateIntervalSelection: DesktopPictureSchedulerIntervalsModel = .defaultTimeInterval {
        didSet {
            guard oldValue != updateIntervalSelection else { return }
            Task { await saveUpdateIntervalToUserDefaults(updateIntervalSelection) }
        }
    }
    var apiAccessKeyStatus: APIAccessKeyValidityStatusModel = .validating
    private(set) var isPresentedPopup: Bool = false
    var apiAccessKeyTextfieldText: String = ""
    let defaults: UserDefaultsManager = .init()
    
    // MARK: - INITIALIZER
    init(appEnvironment: AppEnvironmentModel) {
        desktopPictureScheduler = .init(appEnvironmentType: appEnvironment)
    }
    
    // MARK: FUNCTIONS
    
    // MARK: INTERNAL FUNCTIONS
    
    // MARK: - Initialize Settings Tab View Model
    func initializeSettingsTabVM() async throws {
        try await getSettingsFromUserDefaults()
    }
    
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
        NSApplication.shared.terminate(nil)
    }
    
    // MARK: PRIVATE FUNCTIONS
    
    //  MARK: - Save Launch at Login to User Defaults
    private func saveLaunchAtLoginToUserDefaults(_ value: Bool) async {
        await defaults.save(key: .launchAtLoginKey, value: value)
    }
    
    // MARK: - Save Show on All Spaces to User Defaults
    private func saveShowOnAllSpacesToUserDefaults(_ value: Bool) async {
        await defaults.save(key: .showOnAllSpacesKey, value: value)
    }
    
    // MARK: - Save Update Interval to User Defaults
    private func saveUpdateIntervalToUserDefaults(_ value: DesktopPictureSchedulerIntervalsModel) async {
        do {
            try await defaults.saveModel(key: .timeIntervalSelectionKey, value: value)
        } catch {
            print("Error: Saving update Interval to user defaults.")
        }
    }
    
    // MARK: - On Update Interval Change
    private func onUpdateIntervalChange(_ value: DesktopPictureSchedulerIntervalsModel) async {
        await desktopPictureScheduler.onChangeOfTimeIntervalSelection(from: value)
    }
    
    // MARK: - Save Settings to User Defaults
    private func saveSettingsToUserDefaults() async {
        await saveLaunchAtLoginToUserDefaults(launchAtLogin)
        await saveShowOnAllSpacesToUserDefaults(showOnAllSpaces)
        await saveUpdateIntervalToUserDefaults(updateIntervalSelection)
    }
    
    // MARK: - Get Settings from User Defaults
    private func getSettingsFromUserDefaults() async throws {
        guard
            let launchAtLogin: Bool = await defaults.get(key: .launchAtLoginKey) as? Bool,
            let showOnAllSpaces: Bool = await defaults.get(key: .showOnAllSpacesKey) as? Bool,
            let updateInterval: DesktopPictureSchedulerIntervalsModel = try await defaults.getModel(key: .timeIntervalSelectionKey, type: DesktopPictureSchedulerIntervalsModel.self) else {
            await saveSettingsToUserDefaults()
            return
        }
        
        self.launchAtLogin = launchAtLogin
        self.showOnAllSpaces = showOnAllSpaces
        self.updateIntervalSelection = updateInterval
    }
}
