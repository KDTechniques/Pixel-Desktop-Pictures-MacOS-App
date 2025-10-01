//
//  MainTab_UserDefaults.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-09-29.
//

import Foundation

extension MainTabViewModel {
    /// Saves the current image to UserDefaults.
    ///
    /// - Parameter currentImage: The image to save.
    func saveCurrentImageToUserDefaults(_ currentImage: UnsplashImage) async throws {
        do {
            try await defaults.saveModel(key: .currentImageKey, value: currentImage)
            Logger.log("✅: Current image saved to user defaults.")
        } catch {
            Logger.log(vmError.failedToSaveCurrentImageToUserDefaults(error).localizedDescription)
            throw error
        }
    }
    
    /// Retrieves the current image from UserDefaults.
    ///
    /// - Note: If no image is found, fetches a random Unsplash image as a fallback.
    func getCurrentImageFromUserDefaults() async {
        do {
            let image: UnsplashImage? = try await defaults.getModel(key: .currentImageKey, type: UnsplashImage.self)
            
            // If current image is nil, fetch a random image and set it as the current image
            if image == nil {
                try await setNextRandomImage()
            }
            
            await setNSaveCurrentImageToUserDefaults(image)
            Logger.log("✅: Current image fetched from user defaults.")
        } catch {
            Logger.log(vmError.failedToGetCurrentImageFromUserDefaults(error).localizedDescription)
            try? await setNextRandomImage()
        }
    }
}
