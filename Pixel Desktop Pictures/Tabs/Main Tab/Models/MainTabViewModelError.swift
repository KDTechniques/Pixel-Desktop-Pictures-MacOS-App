//
//  MainTabViewModelError.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-20.
//

import Foundation

enum MainTabViewModelError: LocalizedError {
    case failedToSetNextImage(_ error: Error)
    case failedToSetDesktopPicture(_ error: Error)
    case failedToDownloadImageToDevice(_ error: Error)
    case failedToGenerateNextRandomImage(_ error: Error)
    case failedToGenerateNextQueryImage(_ error: Error)
    case failedToSaveCurrentImageToUserDefaults(_ error: Error)
    case failedToGetCurrentImageFromUserDefaults(_ error: Error)
    
    var errorDescription: String? {
        switch self {
        case .failedToSetNextImage(let error):
            return "❌: Failed to generate next image. \(error.localizedDescription)"
        case .failedToSetDesktopPicture(let error):
            return "❌: Failed to set desktop picture. \(error.localizedDescription)"
        case .failedToDownloadImageToDevice(let error):
            return "❌: Failed to download image to device. \(error.localizedDescription)"
        case .failedToGenerateNextRandomImage(let error):
            return "❌: Failed to generate the next random image. \(error.localizedDescription)"
        case .failedToGenerateNextQueryImage(let error):
            return "❌: Failed to generate the next query image. \(error.localizedDescription)"
        case .failedToSaveCurrentImageToUserDefaults(let error):
            return "❌: Failed to save current image to user defaults. \(error.localizedDescription)"
        case .failedToGetCurrentImageFromUserDefaults(let error):
            return "⚠️/❌: Failed to fetch current image from user defaults. \(error.localizedDescription)"
        }
    }
}
