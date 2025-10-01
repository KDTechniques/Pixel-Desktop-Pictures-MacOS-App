//
//  Update.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-09-30.
//

import AppKit

extension DesktopPictureManager {
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
                    Logger.log("⚠️: No need to change the desktop picture, because it's already been set.")
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
    
    /// Updates the desktop picture by setting the current image file URL.
    ///
    /// - Purpose: This function attempts to set the desktop picture using the current image file URL stored in the `currentDesktopPictureFileURLString` property.
    /// If an error occurs while setting the image, it Logger.logs an error message to the console.
    func updateDesktopPicture() async {
        guard let currentDesktopPictureFileURLString else {
            Logger.log(managerError.currentDesktopPictureFileURLStringFoundNil.localizedDescription)
            return
        }
        
        do {
            let currentDesktopPictureFileURL: URL = .init(filePath: currentDesktopPictureFileURLString, directoryHint: .notDirectory)
            try await setDesktopPicture(from: currentDesktopPictureFileURL)
        } catch {
            Logger.log(managerError.failedToUpdateDesktopPicture(error).localizedDescription)
        }
    }
}
