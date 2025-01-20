//
//  MainTabErrorPopup.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-12.
//

import Foundation

enum MainTabErrorPopup: ErrorPopupProtocol {
    case failedToGenerateNextImage
    case failedToSetDesktopPicture
    case failedToDownloadImageToDevice
    
    var title: String {
        switch self {
        case .failedToGenerateNextImage:
            return "Failed to generate the next image.\nYou may have exceeded the maximum number of images."
        case .failedToSetDesktopPicture:
            return "Failed to set the desktop picture.\nPlease check your internet connection."
        case .failedToDownloadImageToDevice:
            return "Failed to download the image to your mac.\nPlease check your internet connection."
        }
    }
}
