//
//  CollectionsTabViewModel.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-23.
//

import SwiftUI

@MainActor
@Observable
final class CollectionsTabViewModel {
    // MARK: - INJECTED PROPERTIES
    private let apiAccessKeyManager: APIAccessKeyManager = .shared
    private let collectionManager: CollectionManager = .shared
    private let queryImageManager: QueryImageManager = .shared
    
    // MARK: - INITIALIZER
    init() {

    }
    
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
    
    // MARK: - PRIVATE FUNCTIONS
    
    /// Initializes the Collections ViewModel by fetching collections and query images from the local database or creating default data.
    ///
    /// This function attempts to retrieve collections stored in the local database. If no collections are found,
    /// it creates a default set of collections and their associated `QueryImage` data, saves them to the database,
    /// and prepares the collections array for use. For subsequent launches, persistent data is used to initialize the view model.
    ///
    /// If an error occurs during initialization, the function falls back to setting default or empty collections,
    /// and displays an error popup.
    ///
    /// - Important: The function ensures that the `Collections Tab View Model` is initialized correctly with either
    /// persistent or default data to prevent the app from running in an inconsistent state.
    func initializeCollectionsViewModel() async {
        do {
            // Try to fetch collections from local database, if available.
            let fetchedCollectionsArray: [Collection] = try await getCollectionManager().getCollections()
            
            // Handle the case where no collections are found in local database.
            guard !fetchedCollectionsArray.isEmpty else {
                // Use the default values as the initial data or fallback option.
                let defaultCollectionsArray: [Collection] = try Collection.getDefaultCollectionsArray()
                
                // Omit the `RANDOM` collection, and map only collection names for processing
                let collectionNamesArray: [String] = defaultCollectionsArray
                    .filter { $0.name != Collection.randomKeywordString }
                    .map({ $0.name })
                
                // Fetch and add initial `QueryImage`s to local database
                try await fetchAndAddInitialQueryImages(with: collectionNamesArray)
                
                // Save the default collections array to local database.
                try await getCollectionManager().addCollections(defaultCollectionsArray)
                
                // Then prepare the collections array.
                setCollectionsArray(defaultCollectionsArray)
                Logger.log("✅: Initial default collections array has been added to local database")
                return
            }
            
            // After the initial launch, persistent data is available for use.
            setCollectionsArray(fetchedCollectionsArray)
            
            // Prepare query images array with selected collections fetched from the local database.
            try await getAndSetQueryImagesArray()
            
            Logger.log("✅: Collections has been fetched from the local database")
            Logger.log("✅: `Collections Tab View Model` has been initialized!")
        } catch {
            Logger.log(getVMError().failedToInitializeCollectionsTabVM(error).localizedDescription)
            
            do {
                let defaultCollectionsArray: [Collection] = try Collection.getDefaultCollectionsArray()
                setCollectionsArray(defaultCollectionsArray)
                Logger.log("⚠️: Default collections array has been added.")
            } catch {
                setCollectionsArray([]) // The window error will be taken care of from view level
                Logger.log("⚠️: Empty collections array has been assigned.")
            }
            
            await getErrorPopupVM().addError(getErrorPopup().somethingWentWrong)
        }
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
    
    func getErrorPopup() -> CollectionsTabErrorPopup.Type {
        return CollectionsTabErrorPopup.self
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
