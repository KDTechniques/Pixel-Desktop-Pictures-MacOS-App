//
//  DesktopPictureManagerError.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-23.
//

import Foundation

enum DesktopPictureManagerError: LocalizedError {
    case failedToSetDesktopPictureForScreens(screen: String, _ error: Error)
    case failedToPrepareAndSetDesktopPicture(_ error: Error)
    case currentDesktopPictureFileURLStringFoundNil
    case failedToUpdateDesktopPicture(_ error: Error)
    case currentDesktopPictureFileURLStringFoundNilInUserDefaults
    
    var errorDescription: String? {
        switch self {
        case .failedToSetDesktopPictureForScreens(let screen, let error):
            return "❌: Failed to set wallpaper for screen \(screen): \(error.localizedDescription)"
        case .failedToPrepareAndSetDesktopPicture(let error):
            return "❌: Failed to prepare and set desktop picture. \(error.localizedDescription)"
        case .currentDesktopPictureFileURLStringFoundNil:
            return "⚠️/❌: Local current desktop picture file url string` found nil."
        case .failedToUpdateDesktopPicture(let error):
            return "❌: Failed to update desktop picture. \(error.localizedDescription)"
        case .currentDesktopPictureFileURLStringFoundNilInUserDefaults:
            return "⚠️/❌: Failed to find current desktop picture file url string in user defaults."
        }
    }
}
