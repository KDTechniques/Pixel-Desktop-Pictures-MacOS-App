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
    let recentsTabVM: RecentsTabViewModel
    
    // MARK: - ASSIGNED PROPERTIES
    private let desktopPictureManager: DesktopPictureManager = .shared
    private(set) var centerItem: ImageContainerCenterItems = .retryIcon
    private let defaults: UserDefaultsManager = .shared
    private(set) var currentImage: UnsplashImage?
    private let vmError: MainTabViewModelError.Type = MainTabViewModelError.self
    private let errorPopupVM: ErrorPopupViewModel = .shared
    private let errorPopup: MainTabErrorPopup.Type = MainTabErrorPopup.self
    
    // MARK: - INITIALIZER
    init(collectionsTabVM: CollectionsTabViewModel, recentsTabVM: RecentsTabViewModel) {
        self.collectionsTabVM = collectionsTabVM
        self.recentsTabVM = recentsTabVM
    }
    
    // MARK: - INTERNAL FUNCTIONS
    
    /// Initializes the ViewModel by fetching the current image from UserDefaults.
    func initializeMainTabViewModel() async {
        await getCurrentImageFromUserDefaults()
    }
    
    /// Sets the next image to display.
    ///
    /// - Note: Randomly selects a query image or fetches a random Unsplash image
    /// if no valid query is available. Updates the `currentImage` and stores it in UserDefaults.
    func setNextImage() async throws {
        setCenterItem(.progressView)
        
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
            setCenterItem(.retryIcon)
            print(vmError.failedToSetNextImage(error).localizedDescription)
            await errorPopupVM.addError(errorPopup.failedToGenerateNextImage)
            throw error
        }
    }
    
    /// Sets the current image as the desktop wallpaper.
    ///
    /// - Note: Downloads the image to the documents directory and applies it as the desktop wallpaper.
    func setDesktopPicture() async throws {
        // Early exit if the current image is not available.
        guard let currentImage else { return }
        
        do {
            // Download the image to documents directory
            let savedPath: String = try await ImageDownloadManager.shared.downloadImage(url: currentImage.imageQualityURLStrings.full, to: UnsplashImageDirectoryModel.documentsDirectory)
            
            // Then set the desktop picture.
            try await desktopPictureManager.setDesktopPicture(from: savedPath)
            print("✅: Current image has been set as desktop picture successfully.")
        } catch {
            print(vmError.failedToSetDesktopPicture(error).localizedDescription)
            await errorPopupVM.addError(errorPopup.failedToSetDesktopPicture)
            throw error
        }
    }
    
    /// Downloads the current image to the device's downloads directory.
    ///
    /// - Throws: An error if the download operation fails.
    func downloadImageToDevice() async throws {
        // Early exit if the current image is not available.
        guard let currentImage else { return }
        
        do {
            // Download the image to downloads directory
            let savedPath: String = try await ImageDownloadManager.shared.downloadImage(url: currentImage.links.downloadURL, to: UnsplashImageDirectoryModel.downloadsDirectory)
            print("✅: Current image has been downloaded to `Downloads` folder path: `\(savedPath)` successfully.")
        } catch {
            print(vmError.failedToDownloadImageToDevice(error).localizedDescription)
            await errorPopupVM.addError(errorPopup.failedToDownloadImageToDevice)
            throw error
        }
    }
    
    /// Sets the current image to the specified `UnsplashImage`.
    ///
    /// - Parameter item: The new `UnsplashImage` to set as the current image.
    func setCurrentImage(_ item: UnsplashImage?) async {
        currentImage = item
        
        // Save the current image to user defaults every time.
        if let item { try? await saveCurrentImageToUserDefaults(item) }
    }
    
    /// Updates the center item (e.g., progress indicator or retry icon).
    ///
    /// - Parameter item: The new item to display in the center.
    func setCenterItem(_ item: ImageContainerCenterItems) {
        centerItem = item
    }
    
    // MARK: - PRIVATE FUNCTIONS
    
    /// Fetches a random Unsplash image and updates the current image.
    ///
    /// - Note: Converts the random image to `UnsplashImage`, saves it to UserDefaults,
    /// and adds it to the recents tab.
    private func setNextRandomImage() async throws {
        do {
            let randomImage: UnsplashRandomImage = try await collectionsTabVM.getImageAPIServiceInstance().getRandomImage()
            
            // Convert the random image to `UnsplashImage`.
            let convertedImage: UnsplashImage = .convertUnsplashRandomImageToUnsplashImage(randomImage)
            
            // Set the current image
            await setCurrentImage(convertedImage)
            
            // Then encode and add the current image to recents
            let imageEncoded: Data = try JSONEncoder().encode(convertedImage)
            await recentsTabVM.addRecent(imageEncoded: imageEncoded)
            print("✅: Next random image has been set and added to recents successfully.")
        } catch {
            print(vmError.failedToGenerateNextRandomImage(error).localizedDescription)
            throw error
        }
    }
    
    /// Fetches the next image for a specific query and updates the current image.
    ///
    /// - Parameter item: The query image item to fetch.
    private func setNextQueryImage(from item: QueryImage) async throws {
        do {
            // Get image api service instance to fetch or load next query image.
            let imageAPIService: UnsplashImageAPIService = try await collectionsTabVM.getImageAPIServiceInstance()
            let queryImageItem: UnsplashQueryImage = try await collectionsTabVM.getQueryImageManager().getQueryImage(item: item, imageAPIService: imageAPIService)
            
            // Convert the query image to `UnsplashImage`.
            let convertedImage: UnsplashImage = .convertUnsplashQueryImageToUnsplashImage(queryImageItem)
            
            // Set the current image
            await setCurrentImage(convertedImage)
            
            // Then encode and add the current image to recents
            let imageEncoded: Data = try JSONEncoder().encode(convertedImage)
            await recentsTabVM.addRecent(imageEncoded: imageEncoded)
            print("✅: Next query image has been set and added to recents successfully.")
        } catch {
            print(vmError.failedToGenerateNextQueryImage(error).localizedDescription)
            throw error
        }
    }
    
    /// Saves the current image to UserDefaults.
    ///
    /// - Parameter currentImage: The image to save.
    private func saveCurrentImageToUserDefaults(_ currentImage: UnsplashImage) async throws {
        do {
            try await defaults.saveModel(key: .currentImageKey, value: currentImage)
            print("✅: Current image has been saved to user defaults successfully.")
        } catch {
            print(vmError.failedToSaveCurrentImageToUserDefaults(error).localizedDescription)
            throw error
        }
    }
    
    /// Retrieves the current image from UserDefaults.
    ///
    /// - Note: If no image is found, fetches a random Unsplash image as a fallback.
    private func getCurrentImageFromUserDefaults() async {
        do {
            let image: UnsplashImage? = try await defaults.getModel(key: .currentImageKey, type: UnsplashImage.self)
            
            // If current image is nil, fetch a random image and set it as the current image
            if image == nil {
                try await setNextRandomImage()
            }
            
            await setCurrentImage(image)
            print("✅: Current image has been fetched from user defaults successfully.")
        } catch {
            print(vmError.failedToGetCurrentImageFromUserDefaults(error).localizedDescription)
            try? await setNextRandomImage()
        }
    }
}
