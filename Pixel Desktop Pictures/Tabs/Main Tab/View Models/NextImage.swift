//
//  NextImage.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-09-29.
//

import Foundation

extension MainTabViewModel {
    /// Sets the next image to display.
    ///
    /// - Note: Randomly selects a query image or fetches a random Unsplash image
    /// if no valid query is available. Updates the `currentImage` and stores it in UserDefaults.
    func setNextImage() async throws {
        setCenterItem(.progressView)
        
        do {
            // Handle when query images array is empty due to `RANDOM` collection selection.
            // Or random element fails for some reason, but if it does, fallback to next image conforming to `UnsplashRandomImage`.
            guard let randomQueryImageItem: QueryImage = collectionsTabVM.queryImagesArray.randomElement() else {
                try await setNextRandomImage()
                Logger.log("✅: Generated next random image.")
                return
            }
            
            // Handle case when the random element is a non-random query. ex: Nature
            try await setNextQueryImage(from: randomQueryImageItem)
            Logger.log("✅: Generated next query image.")
        } catch {
            setCenterItem(.retryIcon)
            Logger.log(vmError.failedToSetNextImage(error).localizedDescription)
            await errorPopupVM.addError(errorPopup.failedToGenerateNextImage(error))
            throw error
        }
    }
    
    /// Fetches a random Unsplash image and updates the current image.
    ///
    /// - Note: Converts the random image to `UnsplashImage`, saves it to UserDefaults,
    /// and adds it to the recents tab.
    func setNextRandomImage() async throws {
        do {
            let randomImage: UnsplashRandomImage = try await collectionsTabVM.getImageAPIServiceInstance().getRandomImage()
            
            // Convert the random image to `UnsplashImage`.
            let convertedImage: UnsplashImage = .convertUnsplashRandomImageToUnsplashImage(randomImage)
            
            // Set the current image
            await setNSaveCurrentImageToUserDefaults(convertedImage)
            
            // Then encode and add the current image to recents
            let imageEncoded: Data = try JSONEncoder().encode(convertedImage)
            await recentsTabVM.addRecent(imageEncoded: imageEncoded)
            Logger.log("✅: Next random image has been set and added to recents")
        } catch {
            Logger.log(vmError.failedToGenerateNextRandomImage(error).localizedDescription)
            throw error
        }
    }
    
    /// Fetches the next image for a specific query and updates the current image.
    ///
    /// - Parameter item: The query image item to fetch.
    func setNextQueryImage(from item: QueryImage) async throws {
        do {
            // Get image api service instance to fetch or load next query image.
            let imageAPIService: UnsplashImageAPIService = try await collectionsTabVM.getImageAPIServiceInstance()
            let queryImageItem: UnsplashQueryImage = try await collectionsTabVM.getQueryImageManager().getQueryImage(item: item, imageAPIService: imageAPIService)
            
            // Convert the query image to `UnsplashImage`.
            let convertedImage: UnsplashImage = .convertUnsplashQueryImageToUnsplashImage(queryImageItem)
            
            // Set the current image
            await setNSaveCurrentImageToUserDefaults(convertedImage)
            
            // Then encode and add the current image to recents
            let imageEncoded: Data = try JSONEncoder().encode(convertedImage)
            await recentsTabVM.addRecent(imageEncoded: imageEncoded)
            Logger.log("✅: Next query image has been set and added to recents")
        } catch {
            Logger.log(vmError.failedToGenerateNextQueryImage(error).localizedDescription)
            throw error
        }
    }
}
