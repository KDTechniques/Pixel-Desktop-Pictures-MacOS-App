//
//  NotificationObservers.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-09-30.
//

import AppKit

extension DesktopPictureManager {
    // MARK: - Space Did Change
    
    /// Adds an observer for the active space change notification.
    ///
    /// - Purpose: When the user switches between different spaces, this observer ensures that the desktop picture
    /// is updated for the new active space. This is necessary because there is no API available
    /// to change the desktop picture across all spaces at once.
    ///
    /// - Behavior: Listens for `NSWorkspace.activeSpaceDidChangeNotification` and triggers the `spaceDidChange` method.
    func activateSpaceDidChangeNotificationObserver() async {
        workspace.notificationCenter.addObserver(
            self,
            selector: #selector(onSpaceDidChange),
            name: NSWorkspace.activeSpaceDidChangeNotification,
            object: nil
        )
        
        await activateDidWakeNotificationObserver()
        Logger.log("✅: Did wake notification observer has been activated.")
    }
    
    /// Removes observers for workspace space changes and system wake notifications.
    ///
    /// This function:
    /// - Removes the observer for active space change notifications.
    /// - Cleans up the system wake notification observer.
    ///
    /// - Note: Should be called when cleanup is needed, typically in deinit or when stopping monitoring.
    func deactivateSpaceDidChangeNotificationObserver() async {
        workspace.notificationCenter.removeObserver(
            self,
            name: NSWorkspace.activeSpaceDidChangeNotification,
            object: nil
        )
        
        await deactivateDidWakeNotificationObserver()
        Logger.log("✅: Space did change notification has been deactivated.")
    }
    
    /// Handles the active space change by updating the desktop picture.
    ///
    /// - Purpose: This method is called when the active space changes. It ensures that the desktop picture
    /// is updated for the new space, as macOS doesn't allow setting wallpapers for all spaces at once.
    ///
    /// - Behavior:  The method is triggered by the `spaceDidChange` notification and invokes
    /// `updateDesktopPicture` to set the wallpaper accordingly.
    @MainActor
    @objc private func onSpaceDidChange(notification: NSNotification) {
        Task {
            await updateDesktopPicture()
        }
        Logger.log("✅: Space did change.")
    }
    
    // MARK: - Did Awake
    
    /// Adds an observer for the system wake notification.
    ///
    /// - Purpose: Monitors when the system wakes from sleep to perform tasks such as checking
    /// if 24 hours have passed and updating the desktop picture accordingly.
    ///
    /// - Behavior: Listens for `NSWorkspace.didWakeNotification` and triggers the `systemDidWake` method.
    private func activateDidWakeNotificationObserver() async {
        workspace.notificationCenter.addObserver(
            self,
            selector: #selector(onSystemDidWake),
            name: NSWorkspace.didWakeNotification,
            object: nil
        )
    }
    
    /// Removes the observer for system wake notifications from the workspace notification center.
    ///
    /// - Note: Called as part of the space change observer cleanup process.
    private func deactivateDidWakeNotificationObserver() async {
        workspace.notificationCenter.removeObserver(
            self,
            name: NSWorkspace.didWakeNotification,
            object: nil
        )
    }
    
    /// Handles the system wake event by updating the desktop picture.
    ///
    /// - Purpose: This method is called when the system wakes from sleep. It ensures that the desktop picture
    /// is refreshed after the system resumes, which can be useful for updating it based on specific criteria.
    ///
    /// - Behavior: The method is triggered by the `systemDidWake` notification and invokes
    /// `updateDesktopPicture` to set the wallpaper accordingly.
    @MainActor
    @objc private func onSystemDidWake(notification: NSNotification) {
        Task { await updateDesktopPicture() }
        Logger.log("✅: System did wake.")
    }
}
