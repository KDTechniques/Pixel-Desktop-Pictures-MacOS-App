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
    private init() {
        Task {
            await initializeDesktopPictureManager()
        }
    }
    
    // MARK: - ASSIGNED PROPERTIES
    static let shared: DesktopPictureManager = .init()
    nonisolated(unsafe) let workspace = NSWorkspace.shared
    let defaults: UserDefaultsManager = .shared
    let currentDesktopPictureFileURLStringKey: UserDefaultKeys = .currentDesktopPictureFileURLStringKey
    private(set) var currentDesktopPictureFileURLString: String?
    let managerError = DesktopPictureManagerError.self
    
    // MARK: - Deinitializer
    deinit {
        deinitializeDesktopPictureManager()
    }
    
    // MARK: - SETTERS
    func setCurrentDesktopPictureFileURLString(_ value: String) {
        currentDesktopPictureFileURLString = value
    }
    
    // MARK: - PRIVATE FUNCTIONS
    
    /// Initializes the desktop picture by retrieving the saved image file URL from User Defaults and setting it.
    ///
    /// - Purpose: This function fetches the stored desktop picture URL from User Defaults and attempts to set the desktop picture
    /// accordingly. If an error occurs while setting the image, it Logger.logs an error message to the console.
    private func initializeDesktopPictureManager() async {
        guard let imageFileURLString: String = await getNSetCurrentDesktopPictureFileURLStringFromUserDefaults() else {
            return
        }
        
        Logger.log("✅: Retrieved Current desktop picture url.")
        
        do {
            let currentDesktopPictureFileURL: URL = .init(filePath: imageFileURLString, directoryHint: .notDirectory)
            try await setDesktopPicture(from: currentDesktopPictureFileURL)
            Logger.log("✅: Initialized `Desktop Picture Manager`.")
        } catch {
            Logger.log(managerError.failedToPrepareAndSetDesktopPicture(error).localizedDescription)
        }
    }
    
    nonisolated
    private func deinitializeDesktopPictureManager() {
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
        Logger.log("✅: Deinitialized `Desktop Picture Manager`.")
    }
}
