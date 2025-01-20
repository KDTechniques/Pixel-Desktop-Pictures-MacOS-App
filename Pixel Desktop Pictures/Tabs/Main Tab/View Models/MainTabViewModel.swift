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
    private var currentImage: UnsplashImage?
    
    // MARK: - INITIALIZER
    init(collectionsTabVM: CollectionsTabViewModel) {
        self.collectionsTabVM = collectionsTabVM
    }
    
    // MARK: - INTERNAL FUNCTIONS
    
    func initializeMainTabViewModel() async {
        await getCurrentImageFromUserDefaults()
    }
    
    func setNextImage() async {
        do {
            guard let randomQueryImageItem: QueryImage = collectionsTabVM.queryImagesArray.randomElement() else {
                // Random element must not fail, but if it does, fallback to next image conforming to `UnsplashRandomImage`.
                print("❌: Query images array is empty for some unknown reason.")
                try await setNextRandomImage()
                return
            }
            
            // Handle case when the random element is the `RANDOM` query.
            guard randomQueryImageItem.query != Collection.randomKeywordString else {
                try await setNextRandomImage()
                return
            }
            
            // Handle case when the random element is a non-random query. ex: Nature
            try await setNextQueryImage(from: randomQueryImageItem)
        } catch {
            print("❌: Failed to generate next image. \(error.localizedDescription)")
        }
    }
    
    func setDesktopPicture() async {
        // Early exit if the current image is not available.
        guard let currentImage else { return }
        
        do {
            // Download the image to documents directory
            let savedPath: String = try await ImageDownloadManager.shared.downloadImage(url: currentImage.imageQualityURLStrings.full, to: UnsplashImageDirectoryModel.documentsDirectory)
            
            // Then set the desktop picture.
            try await DesktopPictureManager.shared.setDesktopPicture(from: savedPath)
            print("✅: Current image has been set as desktop picture successfully.")
        } catch {
            print("❌: Failed to set desktop picture. \(error.localizedDescription)")
        }
    }
    
    func downloadImageToDevice() async {
        // Early exit if the current image is not available.
        guard let currentImage else { return }
        
        do {
            // Download the image to downloads directory
            let savedPath: String = try await ImageDownloadManager.shared.downloadImage(url: currentImage.links.downloadURL, to: UnsplashImageDirectoryModel.downloadsDirectory)
            print("✅: Current image has been downloaded to `Downloads` folder path: `\(savedPath)` successfully.")
        } catch {
            print("❌: Failed to set desktop picture. \(error.localizedDescription)")
        }
    }
    
    // MARK: - PRIVATE FUNCTIONS
    
    private func setNextRandomImage() async throws {
        do {
            let randomImage: UnsplashRandomImage = try await collectionsTabVM.getImageAPIServiceInstance().getRandomImage()
            
            // Convert the random image to `UnsplashImage`.
            let convertedImage: UnsplashImage = .convertUnsplashRandomImageToUnsplashImage(randomImage)
            
            // Save the image as current image to user defaults.
            try await saveCurrentImageToUserDefaults(convertedImage)
            
            currentImage = convertedImage
        } catch {
            print("❌: Failed to generate the next random image. \(error.localizedDescription)")
            throw error
        }
    }
    
    private func setNextQueryImage(from item: QueryImage) async throws {
        do {
            // Get image api service instance to fetch or load next query image.
            let imageAPIService: UnsplashImageAPIService = try await collectionsTabVM.getImageAPIServiceInstance()
            let queryImageItem: UnsplashQueryImage = try await collectionsTabVM.getQueryImageManager().getQueryImage(item: item, imageAPIService: imageAPIService)
            
            // Convert the query image to `UnsplashImage`.
            let convertedImage: UnsplashImage = .convertUnsplashQueryImageToUnsplashImage(queryImageItem)
            
            // Save the image as current image to user defaults.
            try await saveCurrentImageToUserDefaults(convertedImage)
            
            currentImage = convertedImage
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
    
    func getCurrentImageFromUserDefaults() async {
        do {
            let image: UnsplashImage? = try await defaults.getModel(key: .currentImageKey, type: UnsplashImage.self)
            currentImage = image
        } catch {
            print("⚠️/❌: Failed to fetch current image from user defaults.")
        }
    }
}
