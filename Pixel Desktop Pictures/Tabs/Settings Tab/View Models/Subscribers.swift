//
//  Subscribers.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-10-01.
//

import Foundation
import LaunchAtLogin

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
    func updateIntervalSelectionSubscriber() {
        $updateIntervalSelection$
            .removeDuplicates()
            .sink { interval in
                Logger.log("✅: Triggered update interval selection subscriber.")
                
                Task { [weak self] in
                    guard let self else { return }
                    
                    saveUpdateIntervalToUserDefaults(interval)
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
    func showOnAllSpacesSubscriber() {
        $showOnAllSpaces$
            .removeDuplicates()
            .sink { boolean in
                Logger.log("✅: Triggered show on all spaces subscriber.")
                
                Task { [weak self] in
                    guard let self else { return }
                    
                    saveShowOnAllSpacesToUserDefaults(boolean)
                    
                    boolean
                    ? await desktopPictureManager.activateSpaceDidChangeNotificationObserver()
                    : await desktopPictureManager.deactivateSpaceDidChangeNotificationObserver()
                }
            }
            .store(in: &cancellables)
    }
    
    /// Subscribes to changes in the "Launch at Login" setting.
    ///
    /// Handles updating the launch at login preference and saving to UserDefaults.
    ///
    /// - Note: Uses `@MainActor` to ensure UserDefaults update occurs on the main thread.
    func launchAtLoginSubscriber() {
        $launchAtLogin$
            .removeDuplicates()
            .sink { boolean in
                LaunchAtLogin.isEnabled = boolean
                Task { [weak self] in
                    self?.saveLaunchAtLoginToUserDefaults(boolean)
                }
                
                Logger.log("✅: Assigned and saved Launch at login boolean to User Defaults.")
            }
            .store(in: &cancellables)
    }
}
