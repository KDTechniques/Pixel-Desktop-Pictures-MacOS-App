//
//  MainTabViewModel.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-26.
//

import Foundation

@MainActor
@Observable
final class MainTabViewModel {
    // MARK: - INJECTED PROPERTIES
    let collectionsTabVM: CollectionsTabViewModel
    
    // MARK: - ASSIGNED PROPERTIES
    private(set) var centerItem: ImageContainerCenterItemsModel?
    private let defaults: UserDefaultsManager = .shared
    
    // MARK: - INITIALIZER
    init(collectionsTabVM: CollectionsTabViewModel) {
        self.collectionsTabVM = collectionsTabVM
    }
    
    // MARK: - INTERNAL FUNCTIONS
    
    func getCurrentImageFromUserDefaults() async -> UnsplashImage? {
        do {
            let image: UnsplashImage? = try await defaults.getModel(key: .currentImageKey, type: UnsplashImage.self)
            return image
        } catch {
            print("⚠️/❌: Failed to fetch current image from user defaults.")
            return nil
        }
    }
    
    func getNextImage() async throws -> UnsplashImage {
        do {
            guard let randomQueryImageItem: QueryImage = collectionsTabVM.queryImagesArray.randomElement() else {
                // Random element must not fail, but if it does, fallback to next image conforming to `UnsplashRandomImage`.
                print("❌: Query images array is empty for some unknown reason.")
                return try await getNextRandomImage()
            }
            
            // Handle case when the random element is the `RANDOM` query.
            guard randomQueryImageItem.query != Collection.randomKeywordString else {
                return try await getNextRandomImage()
            }
            
            // Handle case when the random element is a non-random query. ex: Nature
            return try await getNextQueryImage(from: randomQueryImageItem)
        } catch {
            print("❌: Failed to generate next image. \(error.localizedDescription)")
            throw error
        }
    }
    
    // MARK: - PRIVATE FUNCTIONS
    
    private func getNextRandomImage() async throws -> UnsplashImage {
        do {
            let randomImage: UnsplashRandomImage = try await collectionsTabVM.getImageAPIServiceInstance().getRandomImage()
            
            // Convert the random image to `UnsplashImage`.
            let convertedImage: UnsplashImage = .convertUnsplashRandomImageToUnsplashImage(randomImage)
            
            // Save the image as current image to user defaults.
            try await saveCurrentImageToUserDefaults(convertedImage)
            
            // Then return the next random image.
            return convertedImage
        } catch {
            print("❌: Failed to generate the next random image. \(error.localizedDescription)")
            throw error
        }
    }
    
    private func getNextQueryImage(from item: QueryImage) async throws -> UnsplashImage {
        do {
            // Get image api service instance to fetch or load next query image.
            let imageAPIService: UnsplashImageAPIService = try await collectionsTabVM.getImageAPIServiceInstance()
            let queryImageItem: UnsplashQueryImage = try await collectionsTabVM.getQueryImageManager().getQueryImage(item: item, imageAPIService: imageAPIService)
            
            // Convert the query image to `UnsplashImage`.
            let convertedImage: UnsplashImage = .convertUnsplashQueryImageToUnsplashImage(queryImageItem)
            
            // Save the image as current image to user defaults.
            try await saveCurrentImageToUserDefaults(convertedImage)
            
            // Then return the next query image.
            return convertedImage
        } catch {
            print("❌: Failed to generate the next query image. \(error.localizedDescription)")
            throw error
        }
    }
    
    private func saveCurrentImageToUserDefaults(_ currentImage: UnsplashImage) async throws {
        do {
            let encodedImage: Data = try JSONEncoder().encode(currentImage)
            try await defaults.saveModel(key: .currentImageKey, value: encodedImage)
        } catch {
            print("❌: Failed to save current image to user defaults.")
            throw error
        }
    }
    
    // MARK: - Set Desktop Picture
    func setDesktopPicture() {
        
    }
    
    // MARK: - Download Image to Device
    func downloadImageToDevice() {
        
    }
}
