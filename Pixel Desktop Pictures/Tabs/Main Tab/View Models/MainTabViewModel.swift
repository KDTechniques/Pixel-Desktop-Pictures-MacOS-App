//
//  MainTabViewModel.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-26.
//

import Foundation
import Combine

@MainActor
@Observable
final class MainTabViewModel {
    // MARK: - INJECTED PROPERTIES
    let collectionsTabVM: CollectionsTabViewModel
    let recentsTabVM: RecentsTabViewModel
    let apiKeyManager: APIKeyManager
    
    // MARK: - ASSIGNED PROPERTIES
    private let desktopPictureManager: DesktopPictureManager = .shared
    private(set) var centerItem: ImageContainerCenterItems = .retryIcon
    let defaults: UserDefaultsManager = .init()
    private(set) var currentImage: UnsplashImage?
    let vmError = MainTabViewModelErrorModel.self
    let errorPopupVM: ErrorPopupViewModel = .shared
    let errorPopup = MainTabErrorPopup.self
    var mainTabDeferredOperations: Set<MainTabDeferredOperationModel> = []
    private var cancellables: Set<AnyCancellable> = []
    private(set) var showDesktopPictureButtonProgressIndicator: Bool = false
    private(set) var downloadButtonProgressIndicatorState: DownloadStates = .none
    private(set) var deferredOperationsTask: Task<Void, Never>? = nil
    
    // MARK: - INITIALIZER
    init(collectionsTabVM: CollectionsTabViewModel, recentsTabVM: RecentsTabViewModel, apiKeyManager: APIKeyManager) {
        self.collectionsTabVM = collectionsTabVM
        self.recentsTabVM = recentsTabVM
        self.apiKeyManager = apiKeyManager
        
        validAPIKeySubscriber()
    }
    
    // MARK: - SETTERS
    func setCurrentImage(_ value: UnsplashImage?) {
        currentImage = value
    }
    
    func setCenterItem(_ value: ImageContainerCenterItems) {
        centerItem = value
    }
    
    func setDesktopPictureButtonProgressIndicatorVisibility(_ value: Bool) {
        showDesktopPictureButtonProgressIndicator = value
    }
    
    func setDownloadButtonProgressIndicatorState(_ state: DownloadStates) {
        switch state {
        case .none:
            return
            
        case .downloading:
            downloadButtonProgressIndicatorState = state
            
        case .downloaded:
            Task {
                downloadButtonProgressIndicatorState = state
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                downloadButtonProgressIndicatorState = .none
            }
        }
    }
    
    func setDeferredOperationsTask(_ task: Task<Void, Never>?) {
        deferredOperationsTask = task
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
        
        setDesktopPictureButtonProgressIndicatorVisibility(true)
        
        do {
            // Get the documents directory based on app environment
            let documentsDirectory: UnsplashImageDirectoryProtocol = DirectoryTypes.documents.directory
            
            // Download the image to documents directory
            let savedPathURL: URL = try await ImageDownloadManager.shared.downloadImage(url: currentImage.imageQualityURLStrings.full, to: documentsDirectory)
            
            // Then set the desktop picture.
            try await desktopPictureManager.setDesktopPicture(from: savedPathURL)
            setDesktopPictureButtonProgressIndicatorVisibility(false)
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
    
    // MARK: - PRIVATE FUNCTIONS
    private func validAPIKeySubscriber() {
        apiKeyManager.apiKeyValidationStatePublisher
            .dropFirst()
            .removeDuplicates()
            .compactMap { $0 == .valid ? $0 : nil }
            .sink { _ in
                Task { [weak self] in
                    await self?.executeDeferredOperations()
                }
                
                return
            }
            .store(in: &cancellables)
    }
}
