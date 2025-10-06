//
//  SettingsTab_UserDefaults.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-10-01.
//

import Foundation

extension SettingsTabViewModel {
    /// Saves the `launchAtLogin` setting to UserDefaults.
    ///
    /// This asynchronous function saves the given Boolean value for the `launchAtLogin` setting
    /// to UserDefaults using a specific key. It also Logger.logs a message confirming that the value has been saved.
    ///
    /// - Parameter value: A Boolean indicating whether the app should launch at login.
    /// `true` enables the setting, while `false` disables it.
    func saveLaunchAtLoginToUserDefaults(_ value: Bool) {
        defaults.save(key: .launchAtLoginKey, value: value)
        Logger.log("✅: Saved launch at login state `\(value)` to user defaults.")
    }
    
    /// Saves the `showOnAllSpaces` setting to UserDefaults.
    ///
    /// This asynchronous function saves the given Boolean value for the `showOnAllSpaces` setting
    /// to UserDefaults using a specific key. It also Logger.logs a message confirming that the value has been saved.
    ///
    /// - Parameter value: A Boolean indicating whether the app should be shown on all spaces.
    /// `true` enables the setting, while `false` disables it.
    func saveShowOnAllSpacesToUserDefaults(_ value: Bool) {
        defaults.save(key: .showOnAllSpacesKey, value: value)
        Logger.log("✅: Saved show on all spaces state `\(value)` to user defaults.")
    }
    
    /// Saves the update interval setting to UserDefaults.
    ///
    /// This asynchronous function saves the `updateIntervalSelection` setting, represented
    /// by a `DesktopPictureSchedulerInterval`, to UserDefaults using a specific key.
    /// It also handles potential errors and Logger.logs a message confirming whether the save was successful.
    ///
    /// - Parameter value: The `DesktopPictureSchedulerInterval` representing the selected update interval.
    func saveUpdateIntervalToUserDefaults(_ value: DesktopPictureSchedulerInterval) {
        do {
            try defaults.saveModel(key: .timeIntervalSelectionKey, value: value)
            Logger.log("✅: Saved update interval to user defaults.")
        } catch {
            Logger.log(vmError.failedToSaveUpdateIntervalsToUserDefaults(error).localizedDescription)
        }
    }
    
    /// Saves all the settings to UserDefaults.
    ///
    /// This asynchronous function saves the current settings for `launchAtLogin`, `showOnAllSpaces`,
    /// and `updateIntervalSelection` to UserDefaults using the respective save functions for each setting.
    private func saveSettingsToUserDefaults() {
        saveLaunchAtLoginToUserDefaults(launchAtLogin)
        saveShowOnAllSpacesToUserDefaults(showOnAllSpaces)
        saveUpdateIntervalToUserDefaults(updateIntervalSelection)
        Logger.log("✅: Saved settings to user defaults.")
    }
    
    /// Retrieves settings from UserDefaults and updates the current settings.
    ///
    /// This asynchronous function attempts to load the `launchAtLogin`, `showOnAllSpaces`,
    /// and `updateIntervalSelection` settings from UserDefaults. If any setting is missing or cannot
    /// be retrieved, it saves the default settings to UserDefaults instead. Once the settings are successfully
    /// retrieved, they are assigned to the respective properties.
    ///
    /// - Throws: An error if retrieving the `updateIntervalSelection` model fails.
    func getSettingsFromUserDefaults() throws {
        do {
            // Handle settings states in very first app launch.
            guard
                let savedLaunchAtLogin: Bool = defaults.get(key: .launchAtLoginKey) as? Bool,
                let savedShowOnAllSpaces: Bool = defaults.get(key: .showOnAllSpacesKey) as? Bool,
                let savedUpdateInterval: DesktopPictureSchedulerInterval = try defaults.getModel(key: .timeIntervalSelectionKey, type: DesktopPictureSchedulerInterval.self) else {
                saveSettingsToUserDefaults()
                
                Logger.log("✅: Saved initial settings to user defaults.")
                return
            }
            
            launchAtLogin = savedLaunchAtLogin
            showOnAllSpaces = savedShowOnAllSpaces
            updateIntervalSelection = savedUpdateInterval
            Logger.log("✅: Retrieved settings from user defaults.")
        } catch {
            Logger.log(vmError.failedToGetSettingsFromUserDefaults(error).localizedDescription)
            throw error
        }
    }
}
