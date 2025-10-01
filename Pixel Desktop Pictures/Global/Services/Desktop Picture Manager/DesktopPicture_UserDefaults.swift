//
//  DesktopPicture_UserDefaults.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-09-30.
//

import Foundation

extension DesktopPictureManager {
    /// Retrieves and sets the current desktop picture file URL from User Defaults.
    ///
    /// - Returns: A `String?` containing the URL of the current desktop picture if it exists in User Defaults,
    /// or `nil` if the URL is not found.
    ///
    /// - Purpose: This function retrieves the desktop picture file URL previously saved in User Defaults.
    /// It also updates the `currentDesktopPictureFileURLString` property with the retrieved URL.
    func getNSetCurrentDesktopPictureFileURLStringFromUserDefaults() async -> String? {
        guard let imageFileURLString: String = await defaults.get(key: currentDesktopPictureFileURLStringKey) as? String else {
            Logger.log(managerError.currentDesktopPictureFileURLStringFoundNilInUserDefaults.localizedDescription)
            return nil
        }
        
        setCurrentDesktopPictureFileURLString(imageFileURLString)
        Logger.log("✅: Current desktop picture file url string has been retrieved.")
        
        return imageFileURLString
    }
    
    /// Saves and sets the current desktop picture file URL to User Defaults.
    ///
    /// - Parameter imageFileURLString: A `String` containing the URL of the image to be saved as the current desktop picture.
    ///
    /// - Purpose: This function saves the provided desktop picture file URL to User Defaults for future use
    /// and updates the `currentDesktopPictureFileURLString` property with the saved URL.
    func setNSaveCurrentDesktopPictureFileURLStringToUserDefaults(from imageFileURLString: String) async {
        await defaults.save(key: currentDesktopPictureFileURLStringKey, value: imageFileURLString)
        setCurrentDesktopPictureFileURLString(imageFileURLString)
        Logger.log("✅: Current desktop picture file url string has been updated and saved to user defaults.")
    }
}
