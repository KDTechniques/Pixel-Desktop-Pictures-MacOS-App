//
//  MainTabErrorPopup.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-12.
//

import Foundation

enum MainTabErrorPopup: ErrorPopupProtocol {
    case failedToGenerateNextImage(_ error: Error)
    case failedToSetDesktopPicture
    case failedToDownloadImageToDevice
    
    var title: String {
        switch self {
        case .failedToGenerateNextImage(let error):
            return "Failed to generate the next image.\(getReason(for: error))"
        case .failedToSetDesktopPicture:
            return "Failed to set the desktop picture.\nPlease check your internet connection."
        case .failedToDownloadImageToDevice:
            return "Failed to download the image to your mac.\nPlease check your internet connection."
        }
    }
    
    private func getReason(for error: Error) -> String {
        var reason: String {
            let defaultReason: String = "\nSomething went wrong. Please try again later."
            guard let urlError: URLError = error as? URLError else { return defaultReason }
            
            switch urlError.code {
            case .clientCertificateRejected:
                return "\nYou may have exceeded the maximum number of images."
            default:
                return defaultReason
            }
        }
        
        return reason
    }
}
