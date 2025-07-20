//
//  DesktopPictureManager.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-28.
//

import AppKit

/**
 An actor responsible for managing desktop pictures across all screens (monitors).
 
 The `DesktopPictureManager` provides functionality to:
 - Set the desktop picture for all connected monitors.
 - Handle active space changes and system wake events to update desktop pictures accordingly.
 - Persist the currently set desktop picture's file URL in `UserDefaults`.
 
 This actor ensures thread-safe operations while interacting with macOS APIs and `UserDefaults`.
 */
actor DesktopPictureManager {
    // MARK: - INITIALIZER
    private init() { Task { await initializeDesktopPictureManager() } }
    
    // MARK: - ASSIGNED PROPERTIES
    static let shared: DesktopPictureManager = .init()
    private let workspace = NSWorkspace.shared
    private let defaults: UserDefaultsManager = .shared
    private let currentDesktopPictureFileURLStringKey: UserDefaultKeys = .currentDesktopPictureFileURLStringKey
    private var currentDesktopPictureFileURLString: String?
    private let managerError: DesktopPictureManagerError.Type = DesktopPictureManagerError.self
    
    // MARK: - Deinitializer
    deinit {
        // Remove Observers from `NSWorkspace.shared.notificationCenter`
        workspace.notificationCenter.removeObserver(
            self,
            name: NSWorkspace.activeSpaceDidChangeNotification,
            object: nil
        )
        
        workspace.notificationCenter.removeObserver(
            self,
            name: NSWorkspace.didWakeNotification,
            object: nil
        )
        Logger.log("✅: `Desktop Picture Manager` has been Deinitialized.")
    }
    
    // MARK: - INTERNAL FUNCTIONS
    
    /// Sets the desktop picture for all screens (monitors).
    ///
    /// This function performs the following:
    /// 1. Validates and converts the provided image file URL string into a `URL`.
    /// 2. Iterates through all available screens (monitors) and checks if the current desktop picture is different from the provided one.
    /// 3. If the current picture is different, it updates the desktop picture for the screen and saves the new picture's URL to User Defaults.
    ///
    /// - Parameter imageFileURLString: A `String` representing the file URL of the image to be set as the desktop picture.
    ///
    /// - Throws: `URLError.badURL`: If the provided `imageFileURLString` is invalid.
    /// Any errors encountered while setting the desktop image for a screen.
    ///
    /// - Note:
    ///   - If the current desktop picture is the same as the provided image, no changes are made.
    ///   - The function ensures each screen's desktop picture is updated independently and Logger.logs success or failure for each screen.
    func setDesktopPicture(from imageFileURL: URL) async throws {
        let screens: [NSScreen] = NSScreen.screens
        
        // Iterate through screens(monitors) not desktops/spaces
        for screen in screens {
            do {
                // Get Current Desktop Picture File URL
                let currentImageFileURL: URL? = workspace.desktopImageURL(for: screen)
                
                // Check If the Current Desktop Picture is the Same as the Provided Image File URL
                guard currentImageFileURL != imageFileURL else {
                    Logger.log("⚠️: No need to change the desktop picture.")
                    return
                }
                
                // Set Desktop Picture
                try workspace.setDesktopImageURL(imageFileURL, for: screen, options: [:])
                
                // Set & Save Current Desktop Picture File URL to User Defaults
                await setNSaveCurrentDesktopPictureFileURLStringToUserDefaults(from: imageFileURL.path(percentEncoded: false))
                Logger.log("✅: Wallpaper has been changed & saved for screen: \(screen.localizedName).")
            } catch {
                Logger.log(managerError.failedToSetDesktopPictureForScreens(screen: screen.localizedName, error).localizedDescription)
            }
        }
    }
    
    // MARK: - PRIVATE FUNCTIONS
    
    /// Initializes the desktop picture manager.
    ///
    /// This function sets up the desktop picture manager by performing the following:
    /// 1. Initializes the desktop picture settings.
    /// 2. Adds observers for active space changes and wake-from-sleep notifications.
    ///
    /// Once the initialization is complete, it Logger.logs a confirmation message indicating
    /// that the desktop picture manager has been successfully initialized.
    ///
    /// - Note: This function ensures that necessary system notifications and observers are
    /// in place to handle desktop picture management seamlessly.
    private func initializeDesktopPictureManager() async {
        await initializeDesktopPicture()
        Logger.log("✅: `Desktop Picture Manager` has been initialized.")
    }
    
    /// Initializes the desktop picture by retrieving the saved image file URL from User Defaults and setting it.
    ///
    /// - Purpose: This function fetches the stored desktop picture URL from User Defaults and attempts to set the desktop picture
    /// accordingly. If an error occurs while setting the image, it Logger.logs an error message to the console.
    private func initializeDesktopPicture() async {
        guard let imageFileURLString: String = await getNSetCurrentDesktopPictureFileURLStringFromUserDefaults() else {
            return
        }
        
        do {
            try await setDesktopPicture(from: URL(fileURLWithPath: imageFileURLString, isDirectory: false))
            Logger.log("✅: Current desktop picture url has been retrieved.")
        } catch {
            Logger.log(managerError.failedToPrepareAndSetDesktopPicture(error).localizedDescription)
        }
    }
    
    /// Updates the desktop picture by setting the current image file URL.
    ///
    /// - Purpose: This function attempts to set the desktop picture using the current image file URL stored in the `currentDesktopPictureFileURLString` property.
    /// If an error occurs while setting the image, it Logger.logs an error message to the console.
    private func updateDesktopPicture() async {
        guard let currentDesktopPictureFileURLString else {
            Logger.log(managerError.currentDesktopPictureFileURLStringFoundNil.localizedDescription)
            return
        }
        
        do {
            try await setDesktopPicture(from: URL(fileURLWithPath: currentDesktopPictureFileURLString, isDirectory: false))
            Logger.log("✅: Desktop picture has been updated.")
        } catch {
            Logger.log(managerError.failedToUpdateDesktopPicture(error).localizedDescription)
        }
    }
}

// MARK: EXTENSIONS

// MARK: - Notification Observers Related
extension DesktopPictureManager {
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
    
    /// Handles the active space change by updating the desktop picture.
    ///
    /// - Purpose: This method is called when the active space changes. It ensures that the desktop picture
    /// is updated for the new space, as macOS doesn't allow setting wallpapers for all spaces at once.
    ///
    /// - Behavior:  The method is triggered by the `spaceDidChange` notification and invokes
    /// `updateDesktopPicture` to set the wallpaper accordingly.
    @MainActor
    @objc private func onSpaceDidChange(notification: NSNotification) {
        Task { await updateDesktopPicture() }
        Logger.log("✅: Space did change.")
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

// MARK: - User Defaults Related
extension DesktopPictureManager {
    /// Retrieves and sets the current desktop picture file URL from User Defaults.
    ///
    /// - Returns: A `String?` containing the URL of the current desktop picture if it exists in User Defaults,
    /// or `nil` if the URL is not found.
    ///
    /// - Purpose: This function retrieves the desktop picture file URL previously saved in User Defaults.
    /// It also updates the `currentDesktopPictureFileURLString` property with the retrieved URL.
    private func getNSetCurrentDesktopPictureFileURLStringFromUserDefaults() async -> String? {
        guard let imageFileURLString: String = await defaults.get(key: currentDesktopPictureFileURLStringKey) as? String else {
            Logger.log(managerError.currentDesktopPictureFileURLStringFoundNilInUserDefaults.localizedDescription)
            return nil
        }
        
        self.currentDesktopPictureFileURLString = imageFileURLString
        Logger.log("✅: Current desktop picture file url string has been retrieved.")
        
        return imageFileURLString
    }
    
    /// Saves and sets the current desktop picture file URL to User Defaults.
    ///
    /// - Parameter imageFileURLString: A `String` containing the URL of the image to be saved as the current desktop picture.
    ///
    /// - Purpose: This function saves the provided desktop picture file URL to User Defaults for future use
    /// and updates the `currentDesktopPictureFileURLString` property with the saved URL.
    private func setNSaveCurrentDesktopPictureFileURLStringToUserDefaults(from imageFileURLString: String) async {
        await defaults.save(key: currentDesktopPictureFileURLStringKey, value: imageFileURLString)
        currentDesktopPictureFileURLString = imageFileURLString
        Logger.log("✅: Current desktop picture file url string has been updated and saved to user defaults.")
    }
}
