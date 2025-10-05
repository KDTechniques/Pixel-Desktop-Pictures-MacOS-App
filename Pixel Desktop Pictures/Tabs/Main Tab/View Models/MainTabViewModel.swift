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
    let defaults: UserDefaultsManager = .shared
    private(set) var currentImage: UnsplashImage?
    let vmError = MainTabViewModelError.self
    let errorPopupVM: ErrorPopupViewModel = .shared
    let errorPopup = MainTabErrorPopup.self
    
    // MARK: - INITIALIZER
    init(collectionsTabVM: CollectionsTabViewModel, recentsTabVM: RecentsTabViewModel) {
        self.collectionsTabVM = collectionsTabVM
        self.recentsTabVM = recentsTabVM
    }
    
    // MARK: - SETTERS
    func setCurrentImage(_ value: UnsplashImage?) {
        currentImage = value
    }
    
    func setCenterItem(_ value: ImageContainerCenterItems) {
        centerItem = value
    }
    
    // MARK: - INTERNAL FUNCTIONS
    
    /// Initializes the ViewModel by fetching the current image from UserDefaults.
    func initializeMainTabViewModel() async {
        await getCurrentImageFromUserDefaults()
    }
    
    /// Sets the current image as the desktop wallpaper.
    ///
    /// - Note: Downloads the image to the documents directory and applies it as the desktop wallpaper.
    func setDesktopPicture() async throws {
        // Early exit if the current image is not available.
        guard let currentImage else { return }
        
        do {
            // Get the documents directory based on app environment
            let documentsDirectory: UnsplashImageDirectoryProtocol = DirectoryTypes.documents.directory
            
            // Download the image to documents directory
            let savedPathURL: URL = try await ImageDownloadManager.shared.downloadImage(url: currentImage.imageQualityURLStrings.full, to: documentsDirectory)
            
            // Then set the desktop picture.
            try await desktopPictureManager.setDesktopPicture(from: savedPathURL)
            Logger.log("✅: Current image has been set as desktop picture")
        } catch {
            Logger.log(vmError.failedToSetDesktopPicture(error).localizedDescription)
            await errorPopupVM.addError(errorPopup.failedToSetDesktopPicture)
            throw error
        }
    }
    
    /// Sets the current image to the specified `UnsplashImage`.
    ///
    /// - Parameter item: The new `UnsplashImage` to set as the current image.
    func setNSaveCurrentImageToUserDefaults(_ item: UnsplashImage?) async {
        setCurrentImage(item)
        
        // Save the current image to user defaults every time.
        if let item {
            try? await saveCurrentImageToUserDefaults(item)
            Logger.log("✅: Saved current image to user defaults.")
        }
    }
}
