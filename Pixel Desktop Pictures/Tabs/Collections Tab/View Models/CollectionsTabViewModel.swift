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
    private(set) var collectionsArray: [Collection] = []
    private(set) var popOverItem: (isPresented: Bool, type: CollectionsViewPopOver) = (false, .collectionCreationPopOver)
    
    // Create Collection
    private(set) var nameTextfieldText: String = ""
    private(set) var showCreateButtonProgress: Bool = false
    
    // Edit Collection
    private(set) var renameTextfieldText: String = ""
    private(set) var showRenameButtonProgress: Bool = false
    private(set) var showChangeThumbnailButtonProgress: Bool = false
    private(set) var updatingItem: Collection?
    
    // Query Images Related
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
        return .init()
    }
    
    func getJSONDecoder() -> JSONDecoder {
        return .init()
    }
    
    func getUserDefaults() -> UserDefaultsManager {
        return .shared
    }
    
    func getErrorPopup() -> CollectionsTabErrorPopupModel.Type {
        return CollectionsTabErrorPopupModel.self
    }
    
    func getErrorPopupVM() -> ErrorPopupViewModel {
        return .shared
    }
    
    func getVMError() -> CollectionsViewModelError.Type {
        return CollectionsViewModelError.self
    }
}

// MARK: - SETTERS
extension CollectionsTabViewModel {
    func setCollectionsArray(_ newArray: [Collection]) {
        collectionsArray = newArray
    }
    
    func appendCollectionsArray(_ newElement: Collection) {
        collectionsArray.append(newElement)
    }
    
    func removeFromCollectionsArray(_ element: Collection) {
        collectionsArray.removeAll(where: { $0 == element })
    }
    
    func setPopOverItem(_ newItem: (isPresented: Bool, type: CollectionsViewPopOver) ) {
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
