//
//  SettingsTabViewModel.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-27.
//

import AppKit
import LaunchAtLogin
import Combine
import SwiftUI

@MainActor
@Observable final class SettingsTabViewModel {
    // MARK: - INJECTED PROPERTIES
    let desktopPictureScheduler: DesktopPictureScheduler
    
    // MARK: - ASSIGNED PROPERTIES
    let desktopPictureManager: DesktopPictureManager = .shared
    
    var launchAtLogin: Bool = true {
        didSet { launchAtLogin$ = launchAtLogin }
    }
    @ObservationIgnored @Published private var launchAtLogin$: Bool = true
    
    var showOnAllSpaces: Bool = true {
        didSet { showOnAllSpaces$ = showOnAllSpaces  }
    }
    @ObservationIgnored @Published private var showOnAllSpaces$: Bool = true
    
    var updateIntervalSelection: DesktopPictureSchedulerInterval = .defaultTimeInterval {
        didSet { updateIntervalSelection$ = updateIntervalSelection }
    }
    @ObservationIgnored @Published private var updateIntervalSelection$: DesktopPictureSchedulerInterval = .defaultTimeInterval
    
    private(set) var isPresentedPopup: Bool = false
    var apiAccessKeyTextfieldText: String = ""
    let defaults: UserDefaultsManager = .shared
    let vmError: SettingsTabViewModelError.Type = SettingsTabViewModelError.self
    @ObservationIgnored private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - INITIALIZER
    init(appEnvironment: AppEnvironment, mainTabVM: MainTabViewModel) {
        desktopPictureScheduler = .shared(appEnvironmentType: appEnvironment, mainTabVM: mainTabVM)
        Task { await initializeSettingsTabVM() }
    }
    
    // MARK: - INTERNAL FUNCTIONS
    
    /// Initializes the ViewModel for the Settings tab.
    ///
    /// This asynchronous function handles the setup of the Settings tab ViewModel by:
    /// - Setting up subscribers for update interval changes
    /// - Loading user settings from UserDefaults
    ///
    /// - Throws: `vmError` if initialization fails
    /// - Note: Settings are persisted using UserDefaults and loaded on initialization
    func initializeSettingsTabVM() async {
        do {
            updateIntervalSelectionSubscriber()
            showOnAllSpacesSubscriber()
            launchAtLoginSubscriber()
            try await getSettingsFromUserDefaults()
            Logger.log("✅: `Settings Tab View Model` has been initialized")
        } catch {
            Logger.log(vmError.failedToInitializeSettingsTabViewModel(error).localizedDescription)
        }
    }
    
    /// Controls the visibility of a popup.
    ///
    /// This function updates the state of `isPresentedPopup` to show or hide the popup
    /// based on the provided boolean value.
    ///
    /// - Parameter present: A Boolean value that determines whether the popup should be presented (`true`) or hidden (`false`).
    func presentPopup(_ present: Bool) {
        withAnimation(TabItem.bottomPopupAnimation) {
            isPresentedPopup = present
        }
        Logger.log("✅: Bottom popup has been presented/dismissed.")
    }
    
    /// Dismisses the popup and resets related data.
    ///
    /// This function hides the popup by setting its visibility state to `false` and clears
    /// the text in the API access key text field.
    func dismissPopUp() {
        presentPopup(false)
        apiAccessKeyTextfieldText = ""
        Logger.log("✅: Bottom popup has been dismissed and reset the api access key textfield.")
    }
    
    /// Pastes the API access key from the clipboard into the text field.
    ///
    /// This function retrieves a string from the system clipboard and sets it as the text
    /// for the API access key text field. If the clipboard does not contain a string, the function does nothing.
    func pasteAPIAccessKeyFromClipboard() {
        guard let clipboardString = NSPasteboard.general.string(forType: .string) else { return }
        apiAccessKeyTextfieldText = clipboardString
        Logger.log("✅: A text has been pasted from the clipboard.")
    }
    
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
        Logger.log("✅: Defaults settings have been restored.")
    }
    
    /// Quits the application.
    ///
    /// This function terminates the running application by invoking the `terminate` method
    /// on the shared `NSApplication` instance.
    func quitApp() {
        NSApplication.shared.terminate(nil)
        Logger.log("✅: App has been quit.")
    }
    
    // MARK: - PRIVATE FUNCTIONS
    
    /// Resets the API access key text field to an empty state.
    ///
    /// This function clears the text in the API access key text field by setting it to an empty string.
    private func resetAPIAccessKeyTextfieldText() {
        apiAccessKeyTextfieldText = ""
        Logger.log("✅: API access key textfield has been reset.")
    }
    
    /// Handles changes to the update interval setting.
    ///
    /// This asynchronous function is called when the update interval setting is changed. It updates
    /// the `desktopPictureScheduler` with the new interval value.
    ///
    /// - Parameter value: The new `DesktopPictureSchedulerInterval` representing the updated update interval selection.
    private func onUpdateIntervalChange(_ value: DesktopPictureSchedulerInterval) async {
        await desktopPictureScheduler.onChangeOfTimeIntervalSelection(from: value)
        Logger.log("✅: Change on update interval occurred.")
    }
}

// MARK: EXTENSIONS

// MARK: - User Defaults Related
extension SettingsTabViewModel {
    /// Saves the `launchAtLogin` setting to UserDefaults.
    ///
    /// This asynchronous function saves the given Boolean value for the `launchAtLogin` setting
    /// to UserDefaults using a specific key. It also Logger.logs a message confirming that the value has been saved.
    ///
    /// - Parameter value: A Boolean indicating whether the app should launch at login.
    /// `true` enables the setting, while `false` disables it.
    private func saveLaunchAtLoginToUserDefaults(_ value: Bool) async {
        await defaults.save(key: .launchAtLoginKey, value: value)
        Logger.log("✅: Launch at login state `\(value)` has been saved to user defaults")
    }
    
    /// Saves the `showOnAllSpaces` setting to UserDefaults.
    ///
    /// This asynchronous function saves the given Boolean value for the `showOnAllSpaces` setting
    /// to UserDefaults using a specific key. It also Logger.logs a message confirming that the value has been saved.
    ///
    /// - Parameter value: A Boolean indicating whether the app should be shown on all spaces.
    /// `true` enables the setting, while `false` disables it.
    private func saveShowOnAllSpacesToUserDefaults(_ value: Bool) async {
        await defaults.save(key: .showOnAllSpacesKey, value: value)
        Logger.log("✅: Show on all spaces state `\(value)` has been saved to user defaults")
    }
    
    /// Saves the update interval setting to UserDefaults.
    ///
    /// This asynchronous function saves the `updateIntervalSelection` setting, represented
    /// by a `DesktopPictureSchedulerInterval`, to UserDefaults using a specific key.
    /// It also handles potential errors and Logger.logs a message confirming whether the save was successful.
    ///
    /// - Parameter value: The `DesktopPictureSchedulerInterval` representing the selected update interval.
    private func saveUpdateIntervalToUserDefaults(_ value: DesktopPictureSchedulerInterval) async {
        do {
            try await defaults.saveModel(key: .timeIntervalSelectionKey, value: value)
            Logger.log("✅: Update interval has been saved to user defaults.")
        } catch {
            Logger.log(vmError.failedToSaveUpdateIntervalsToUserDefaults(error).localizedDescription)
        }
    }
    
    /// Saves all the settings to UserDefaults.
    ///
    /// This asynchronous function saves the current settings for `launchAtLogin`, `showOnAllSpaces`,
    /// and `updateIntervalSelection` to UserDefaults using the respective save functions for each setting.
    private func saveSettingsToUserDefaults() async {
        await saveLaunchAtLoginToUserDefaults(launchAtLogin)
        await saveShowOnAllSpacesToUserDefaults(showOnAllSpaces)
        await saveUpdateIntervalToUserDefaults(updateIntervalSelection)
        Logger.log("✅: Settings has been saved to user defaults.")
    }
    
    /// Retrieves settings from UserDefaults and updates the current settings.
    ///
    /// This asynchronous function attempts to load the `launchAtLogin`, `showOnAllSpaces`,
    /// and `updateIntervalSelection` settings from UserDefaults. If any setting is missing or cannot
    /// be retrieved, it saves the default settings to UserDefaults instead. Once the settings are successfully
    /// retrieved, they are assigned to the respective properties.
    ///
    /// - Throws: An error if retrieving the `updateIntervalSelection` model fails.
    private func getSettingsFromUserDefaults() async throws {
        do {
            // Handle settings states in very first app launch.
            guard
                let savedLaunchAtLogin: Bool = await defaults.get(key: .launchAtLoginKey) as? Bool,
                let savedShowOnAllSpaces: Bool = await defaults.get(key: .showOnAllSpacesKey) as? Bool,
                let savedUpdateInterval: DesktopPictureSchedulerInterval = try await defaults.getModel(key: .timeIntervalSelectionKey, type: DesktopPictureSchedulerInterval.self) else {
                await saveSettingsToUserDefaults()
                
                Logger.log("✅: Initial settings have been saved to user defaults.")
                return
            }
            
            self.launchAtLogin = savedLaunchAtLogin
            self.showOnAllSpaces = savedShowOnAllSpaces
            self.updateIntervalSelection = savedUpdateInterval
            Logger.log("✅: Settings have been retrieved from user defaults.")
        } catch {
            Logger.log(vmError.failedToGetSettingsFromUserDefaults(error).localizedDescription)
            throw error
        }
    }
}

// MARK: - Subscribers Related
extension SettingsTabViewModel {
    /// Subscribes to changes in the update interval selection and handles the updates.
    ///
    /// This function sets up a Combine subscriber that monitors changes to the update interval selection and:
    /// - Skips the first two values to avoid initial setup triggers
    /// - Removes duplicate interval selections
    /// - Saves the selected interval to UserDefaults
    /// - Updates the desktop picture scheduler with the new interval
    ///
    /// The subscription:
    /// 1. Uses `@MainActor` to ensure UI updates occur on the main thread
    /// 2. Implements weak self to prevent retain cycles
    /// 3. Stores the cancellable in the cancellables set for proper cleanup
    ///
    /// - Note: This is a private function as it handles internal view model state management
    private func updateIntervalSelectionSubscriber() {
        $updateIntervalSelection$
            .dropFirst(2)
            .removeDuplicates()
            .sink { interval in
                Logger.log("✅: Update interval selection subscriber has been triggered.")
                
                Task { @MainActor [weak self] in
                    guard let self else { return }
                    
                    await saveUpdateIntervalToUserDefaults(interval)
                    await desktopPictureScheduler.onChangeOfTimeIntervalSelection(from: interval)
                }
            }
            .store(in: &cancellables)
    }
    
    /// Subscribes to changes in the "Show on All Spaces" setting.
    ///
    /// Handles saving the setting to UserDefaults and activating/deactivating space notification observers.
    ///
    /// - Note: Uses `@MainActor` to ensure UI updates occur on the main thread.
    private func showOnAllSpacesSubscriber() {
        $showOnAllSpaces$
            .dropFirst()
            .removeDuplicates()
            .sink { boolean in
                Logger.log("✅: Show on all spaces subscriber has been triggered.")
                
                Task { @MainActor [weak self] in
                    guard let self else { return }
                    
                    await saveShowOnAllSpacesToUserDefaults(boolean)
                    boolean ? await desktopPictureManager.activateSpaceDidChangeNotificationObserver() : await desktopPictureManager.deactivateSpaceDidChangeNotificationObserver()
                }
            }
            .store(in: &cancellables)
    }
    
    /// Subscribes to changes in the "Launch at Login" setting.
    ///
    /// Handles updating the launch at login preference and saving to UserDefaults.
    ///
    /// - Note: Uses `@MainActor` to ensure UserDefaults update occurs on the main thread.
    private func launchAtLoginSubscriber() {
        $launchAtLogin$
            .dropFirst(2)
            .removeDuplicates()
            .sink { boolean in
                Logger.log("✅: Launch at login subscriber has been triggered.")
                
                LaunchAtLogin.isEnabled = boolean
                Task { @MainActor [weak self] in
                    await self?.saveLaunchAtLoginToUserDefaults(boolean)
                }
            }
            .store(in: &cancellables)
    }
}
