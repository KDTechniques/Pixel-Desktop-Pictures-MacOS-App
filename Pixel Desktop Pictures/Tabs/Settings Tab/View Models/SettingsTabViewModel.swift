//
//  SettingsTabViewModel.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-27.
//

import AppKit
import LaunchAtLogin

@MainActor
@Observable final class SettingsTabViewModel {
    // MARK: - INJECTED PROPERTIES
    let desktopPictureScheduler: DesktopPictureScheduler
    
    // MARK: - ASSIGNED PROPERTIES
    var launchAtLogin: Bool = true {
        didSet {
            guard oldValue != launchAtLogin else { return }
            LaunchAtLogin.isEnabled = launchAtLogin
            Task { await saveLaunchAtLoginToUserDefaults(launchAtLogin) }
        }
    }
    var showOnAllSpaces: Bool = true {
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
    private(set) var isPresentedPopup: Bool = false
    var apiAccessKeyTextfieldText: String = ""
    let defaults: UserDefaultsManager = .init()
    
    // MARK: - INITIALIZER
    init(appEnvironment: AppEnvironmentModel) {
        desktopPictureScheduler = .shared(appEnvironmentType: appEnvironment)
    }
    
    // MARK: FUNCTIONS
    
    // MARK: INTERNAL FUNCTIONS
    
    // MARK: - Initialize Settings Tab View Model
    /// Initializes the ViewModel for the Settings tab.
    ///
    /// This asynchronous function retrieves and sets up user settings from UserDefaults.
    /// It ensures that any settings data required by the Settings tab is properly loaded and ready for use.
    ///
    /// - Throws: An error if retrieving settings from UserDefaults fails.
    func initializeSettingsTabVM() async throws {
        try await getSettingsFromUserDefaults()
    }
    
    // MARK: - Present Popup
    /// Controls the visibility of a popup.
    ///
    /// This function updates the state of `isPresentedPopup` to show or hide the popup
    /// based on the provided boolean value.
    ///
    /// - Parameter present: A Boolean value that determines whether the popup should be presented (`true`) or hidden (`false`).
    func presentPopup(_ present: Bool) {
        isPresentedPopup = present
    }
    
    // MARK: - Dismiss Popup
    /// Dismisses the popup and resets related data.
    ///
    /// This function hides the popup by setting its visibility state to `false` and clears
    /// the text in the API access key text field.
    func dismissPopUp() {
        presentPopup(false)
        apiAccessKeyTextfieldText = ""
    }
    
    // MARK: - Pate API Access Key from Clipboard
    /// Pastes the API access key from the clipboard into the text field.
    ///
    /// This function retrieves a string from the system clipboard and sets it as the text
    /// for the API access key text field. If the clipboard does not contain a string, the function does nothing.
    func pasteAPIAccessKeyFromClipboard() {
        guard let clipboardString = NSPasteboard.general.string(forType: .string) else { return }
        apiAccessKeyTextfieldText = clipboardString
    }
    
    // MARK: - Restore Default Settings
    /// Restores the default settings and saves them to UserDefaults.
    ///
    /// This function resets the settings to their default values and ensures these values are
    /// saved to UserDefaults. The settings include launch behavior, display preferences, and update interval.
    ///
    /// - Note: Calling this function will also update the settings stored in UserDefaults.
    func restoreDefaultSettings() {
        launchAtLogin = true
        showOnAllSpaces = true
        updateIntervalSelection = .defaultTimeInterval
    }
    
    // MARK: - Quit App
    /// Quits the application.
    ///
    /// This function terminates the running application by invoking the `terminate` method
    /// on the shared `NSApplication` instance.
    func quitApp() {
        NSApplication.shared.terminate(nil)
    }
    
    // MARK: PRIVATE FUNCTIONS
    
    // MARK: - Reset API Access Key Textfield Text
    /// Resets the API access key text field to an empty state.
    ///
    /// This function clears the text in the API access key text field by setting it to an empty string.
    private func resetAPIAccessKeyTextfieldText() {
        apiAccessKeyTextfieldText = ""
    }
    
    //  MARK: - Save Launch at Login to User Defaults
    /// Saves the `launchAtLogin` setting to UserDefaults.
    ///
    /// This asynchronous function saves the given Boolean value for the `launchAtLogin` setting
    /// to UserDefaults using a specific key. It also prints a message confirming that the value has been saved.
    ///
    /// - Parameter value: A Boolean indicating whether the app should launch at login.
    /// `true` enables the setting, while `false` disables it.
    private func saveLaunchAtLoginToUserDefaults(_ value: Bool) async {
        await defaults.save(key: .launchAtLoginKey, value: value)
        print("Saved `launchAtLogin` to user defaults.")
    }
    
    // MARK: - Save Show on All Spaces to User Defaults
    /// Saves the `showOnAllSpaces` setting to UserDefaults.
    ///
    /// This asynchronous function saves the given Boolean value for the `showOnAllSpaces` setting
    /// to UserDefaults using a specific key. It also prints a message confirming that the value has been saved.
    ///
    /// - Parameter value: A Boolean indicating whether the app should be shown on all spaces.
    /// `true` enables the setting, while `false` disables it.
    private func saveShowOnAllSpacesToUserDefaults(_ value: Bool) async {
        await defaults.save(key: .showOnAllSpacesKey, value: value)
        print("Saved `showOnAllSpaces` to user defaults.")
    }
    
    // MARK: - Save Update Interval to User Defaults
    /// Saves the update interval setting to UserDefaults.
    ///
    /// This asynchronous function saves the `updateIntervalSelection` setting, represented
    /// by a `DesktopPictureSchedulerIntervalsModel`, to UserDefaults using a specific key.
    /// It also handles potential errors and prints a message confirming whether the save was successful.
    ///
    /// - Parameter value: The `DesktopPictureSchedulerIntervalsModel` representing the selected update interval.
    private func saveUpdateIntervalToUserDefaults(_ value: DesktopPictureSchedulerIntervalsModel) async {
        do {
            try await defaults.saveModel(key: .timeIntervalSelectionKey, value: value)
            print("Saved `updateIntervalSelection` to user defaults.")
        } catch {
            print("Error: Saving update Interval to user defaults.")
        }
    }
    
    // MARK: - On Update Interval Change
    /// Handles changes to the update interval setting.
    ///
    /// This asynchronous function is called when the update interval setting is changed. It updates
    /// the `desktopPictureScheduler` with the new interval value.
    ///
    /// - Parameter value: The new `DesktopPictureSchedulerIntervalsModel` representing the updated update interval selection.
    private func onUpdateIntervalChange(_ value: DesktopPictureSchedulerIntervalsModel) async {
        await desktopPictureScheduler.onChangeOfTimeIntervalSelection(from: value)
    }
    
    // MARK: - Save Settings to User Defaults
    /// Saves all the settings to UserDefaults.
    ///
    /// This asynchronous function saves the current settings for `launchAtLogin`, `showOnAllSpaces`,
    /// and `updateIntervalSelection` to UserDefaults using the respective save functions for each setting.
    private func saveSettingsToUserDefaults() async {
        await saveLaunchAtLoginToUserDefaults(launchAtLogin)
        await saveShowOnAllSpacesToUserDefaults(showOnAllSpaces)
        await saveUpdateIntervalToUserDefaults(updateIntervalSelection)
    }
    
    // MARK: - Get Settings from User Defaults
    /// Retrieves settings from UserDefaults and updates the current settings.
    ///
    /// This asynchronous function attempts to load the `launchAtLogin`, `showOnAllSpaces`,
    /// and `updateIntervalSelection` settings from UserDefaults. If any setting is missing or cannot
    /// be retrieved, it saves the default settings to UserDefaults instead. Once the settings are successfully
    /// retrieved, they are assigned to the respective properties.
    ///
    /// - Throws: An error if retrieving the `updateIntervalSelection` model fails.
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
