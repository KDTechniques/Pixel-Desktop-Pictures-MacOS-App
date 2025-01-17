//
//  CollectionsTabViewModel.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-23.
//

import SwiftUICore

@MainActor
@Observable
final class CollectionsTabViewModel {
    // MARK: - INJECTED PROPERTIES
    private let apiAccessKeyManager: APIAccessKeyManager
    private let collectionManager: CollectionManager
    private let queryImageManager: QueryImageManager
    
    // MARK: - ASSIGNED PROPERTIES
    private let defaults: UserDefaultsManager = .shared
    private let errorPopup = CollectionsTabErrorPopupModel.self
    private let encoder: JSONEncoder = .init()
    private let decoder: JSONDecoder = .init()
    private let errorPopupVM: ErrorPopupViewModel = .shared
    private(set) var collectionsArray: [Collection] = []
    private(set) var popOverItem: (isPresented: Bool, type: CollectionsViewPopOverModel) = (false, .collectionCreationPopOver)
    
    // Create Collection
    private(set) var nameTextfieldText: String = ""
    private(set) var showCreateButtonProgress: Bool = false
    
    // Edit Collection
    private(set) var renameTextfieldText: String = ""
    private(set) var showRenameButtonProgress: Bool = false
    private(set) var showChangeThumbnailButtonProgress: Bool = false
    private(set) var updatingItem: Collection?
    
    // Query Images Related
    /// Get a random index object and pass it to model manager to get an image
    private(set) var queryImagesArray: [QueryImage] = []
    
    // MARK: - INITIALIZER
    
    init(
        apiAccessKeyManager: APIAccessKeyManager,
        collectionManager: CollectionManager,
        queryImageManager: QueryImageManager
    ) {
        self.apiAccessKeyManager = apiAccessKeyManager
        self.collectionManager = collectionManager
        self.queryImageManager = queryImageManager
    }
}

// MARK: - GETTERS
extension CollectionsTabViewModel {
    func getAPIAccessKeyManager() -> APIAccessKeyManager {
        return apiAccessKeyManager
    }
    
    func getCollectionManager() -> CollectionManager {
        return collectionManager
    }
    
    func getQueryImageManager() -> QueryImageManager {
        return queryImageManager
    }
    
    func getJSONEncoder() -> JSONEncoder {
        return encoder
    }
    
    func getJSONDecoder() -> JSONDecoder {
        return decoder
    }
    
    func getUserDefaults() -> UserDefaultsManager {
        return defaults
    }
    
    func getErrorPopup() -> CollectionsTabErrorPopupModel.Type {
        return errorPopup
    }
    
    func getErrorPopupVM() -> ErrorPopupViewModel {
        return errorPopupVM
    }
}

// MARK: - SETTERS
extension CollectionsTabViewModel {
    func setCollectionsArray(_ newArray: [Collection]) {
        collectionsArray = newArray
        Task {  await getNSetQueryImagesArray() }
    }
    
    func setPopOverItem(_ newItem: (isPresented: Bool, type: CollectionsViewPopOverModel) ) {
        popOverItem = newItem
    }
    
    func setNameTextfieldText(_ newText: String) {
        nameTextfieldText = newText
    }
    
    func setRenameTextfieldText(_ newText: String) {
        renameTextfieldText = newText
    }
    
    func setShowCreateButtonProgress(_ boolean: Bool) {
        showCreateButtonProgress = boolean
    }
    
    func setShowRenameButtonProgress(_ boolean: Bool) {
        showRenameButtonProgress = boolean
    }
    
    func setShowChangeThumbnailButtonProgress(_ boolean: Bool) {
        showChangeThumbnailButtonProgress = boolean
    }
    
    func setUpdatingItem(_ newItem: Collection?) {
        updatingItem = newItem
    }
    
    func setQueryImagesArray(_ newArray: [QueryImage]) {
        queryImagesArray = newArray
    }
}
