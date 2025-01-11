//
//  CollectionsViewModel.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-23.
//

import SwiftUICore

@MainActor
@Observable final class CollectionsViewModel {
    // MARK: - INJECTED PROPERTIES
    let swiftDataManager: CollectionModelSwiftDataManager
    let apiAccessKeyManager: APIAccessKeyManager
    
    // MARK: - ASSIGNED PROPERTIES
    let defaults: UserDefaultsManager = .shared
    var collectionNameTextfieldText: String = ""
    var collectionRenameTextfieldText: String = ""
    var collectionItemsArray: [CollectionModel] = []
    var showCreateButtonProgress: Bool = false
    var showRenameButtonProgress: Bool = false
    var showChangeThumbnailButtonProgress: Bool = false
    private(set) var popOverItem: (isPresented: Bool, type: CollectionsViewPopOverModel) = (false, .collectionCreationPopOver)
    var updatingItem: CollectionModel?
    private(set) var localAPIAccessKey: String?
    
    // MARK: - INITIALIZER
    /// Initializes the CollectionsViewModel with a SwiftDataManager instance.
    /// - Parameter swiftDataManager: The instance of SwiftDataManager used for data management.
    init(apiAccessKeyManager: APIAccessKeyManager, swiftDataManager: CollectionModelSwiftDataManager) {
        self.apiAccessKeyManager = apiAccessKeyManager
        self.swiftDataManager = swiftDataManager
    }
    
    // MARK: FUNCTIONS
    
    // MARK: INTERNAL FUNCTIONS
    
    // MARK: - Initialize Collections View Model
    /// Initializes the view model by fetching existing collection items or creating default ones if none exist.
    func initializeCollectionsViewModel() async {
        localAPIAccessKey = await apiAccessKeyManager.getAPIAccessKeyFromUserDefaults()
        
        do {
            // Try to fetch collection items from SwiftData, if available.
            let fetchedCollectionItemsArray: [CollectionModel] = try swiftDataManager.fetchCollectionItemModelsArray()
            
            // Handle the case where no data is found in SwiftData.
            guard !fetchedCollectionItemsArray.isEmpty else {
                // Use the default values as the initial data or fallback option.
                // Prepare the `collectionItemsArray` and save it to SwiftData.
                let defaultCollectionItemsArray: [CollectionModel] = try CollectionModel.getDefaultCollectionsArray()
                collectionItemsArray = defaultCollectionItemsArray
                try addInitialCollectionsArrayToSwiftData(defaultCollectionItemsArray)
                return
            }
            
            // After the initial launch, SwiftData is available for use.
            collectionItemsArray = fetchedCollectionItemsArray
            print("`Collections View Model` has been initialized!")
        } catch {
            print("Error: Failed to initialize `Collections View Model`: \(error.localizedDescription)")
            
            do {
                collectionItemsArray = try CollectionModel.getDefaultCollectionsArray()
            } catch {
                collectionItemsArray = []
            }
        }
    }
    
    // MARK: - Create Collection
    /// Creates a new collection with the name provided in `collectionNameTextfieldText`.
    /// - Validates the collection name, checks for duplications, fetches an image from Unsplash API,
    ///   and saves the collection to persistent storage.
    func createCollection() {
        // Assign the collection name to a temporary property in case it changes before this function finishes.
        let collectionName: String = collectionNameTextfieldText
        
        // Early exit to avoid errors when creating a collection with an empty value.
        guard !collectionName.isEmpty else { return }
        showCreateButtonProgress = true
        
        Task {
            do {
                // Since the collection name must be unique in the SwiftData model, duplication must be avoided.
                guard !checkCollectionNameDuplications(collectionName) else {
                    print(CollectionsViewModelErrorModel.duplicateCollectionName)
                    showCreateButtonProgress = false
                    // show an error pop for duplicate name here...
                    return
                }
                
                // Get the API access key properly via `getAPIAccessKey()`
                let apiAccessKey: String = try await getAPIAccessKey()
                let imageAPIService: UnsplashImageAPIService = .init(apiAccessKey: apiAccessKey)
                
                // Collection creation requires one image URL model to work with.
                let model: UnsplashQueryImageModel = try await imageAPIService.getQueryImageModel(
                    queryText: collectionName,
                    pageNumber: 1,
                    imagesPerPage: 1
                )
                
                // Get the first result, as there's only one result (images per page is set to 1 above).
                guard let imageURLs: UnsplashImageURLsModel = model.results.first?.imageQualityURLStrings else {
                    throw URLError(.badServerResponse)
                }
                
                // Create the collection model object.
                let object: CollectionModel = try .init(collectionName: collectionName, imageURLs: imageURLs)
                
                // First, add the new object to SwiftData for better UX.
                try swiftDataManager.addCollectionItemModel(object)
                
                // Then, add the object to the collections array for the user to interact with.
                collectionItemsArray.append(object)
                
                // Dismiss progress and popup after successful collection creation.
                showCreateButtonProgress = false
                presentPopup(false, for: .collectionCreationPopOver)
                // Show success alert here...
            } catch {
                showCreateButtonProgress = false
                // Show an alert based on the thrown error here...
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Update Collection Name
    /// Updates the name of an existing collection.
    /// - Uses `collectionRenameTextfieldText` for the new name and updates it in persistent storage.
    func updateCollectionName() {
        let newCollectionName: String = collectionRenameTextfieldText
        guard !newCollectionName.isEmpty,
              let item: CollectionModel = updatingItem else {
            return
        }
        
        showRenameButtonProgress = true
        
        Task {
            do {
                guard !checkCollectionNameDuplications(newCollectionName) else {
                    throw CollectionsViewModelErrorModel.duplicateCollectionName
                }
                
                // Get the API access key from UserDefaults to ensure we always work with a valid API key, in case changes happen.
                guard let apiAccessKey: String = await getAPIAccessKeyFromUserDefaults() else {
                    throw CollectionsViewModelErrorModel.apiAccessKeyNotFound
                }
                
                let imageAPIService: UnsplashImageAPIService = .init(apiAccessKey: apiAccessKey)
                try await swiftDataManager.updateCollectionName(item, newCollectionName: newCollectionName, imageAPIServiceReference: imageAPIService)
                showRenameButtonProgress = false
                resetTextfieldTexts()
            } catch {
                showRenameButtonProgress = false
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Update Collection Image URL String
    /// Updates the image URL for a specific collection item.
    /// - Parameter item: The collection item to update.
    func updateCollectionImageURLString(item: CollectionModel) async {
        showChangeThumbnailButtonProgress = true
        do {
            // Get the API access key from UserDefaults to ensure we always work with a valid API key, in case changes happen.
            guard let apiAccessKey: String = await getAPIAccessKeyFromUserDefaults() else {
                throw CollectionsViewModelErrorModel.apiAccessKeyNotFound
            }
            
            let imageAPIService: UnsplashImageAPIService = .init(apiAccessKey: apiAccessKey)
            try await swiftDataManager.updateCollectionImageURLString(item, imageAPIServiceReference: imageAPIService)
            showChangeThumbnailButtonProgress = false
        } catch {
            showChangeThumbnailButtonProgress = false
            if let urlError = error as? URLError {
                switch urlError.code {
                case .clientCertificateRejected:
                    apiAccessKeyManager.apiAccessKeyStatus = .rateLimited
                case .userAuthenticationRequired:
                    apiAccessKeyManager.apiAccessKeyStatus = .invalid
                default:
                    print(urlError.localizedDescription)
                }
            }
            
            
            
            print("Error: Updating collection item's image url string. \(error.localizedDescription)")
        }
    }
    
    // MARK: - Update Collection Selection Status
    /// Updates the selection status of a specific collection item.
    /// - Parameters:
    ///   - item: The collection item to update.
    ///   - isSelected: A Boolean value indicating the new selection state.
    func updateCollectionSelectionStatus(item: CollectionModel, isSelected: Bool) {
        do {
            try swiftDataManager.updateCollectionSelectionState(item, isSelected: isSelected)
        } catch {
            print("Error: Updating collection selection status to `\(isSelected)`. \(error.localizedDescription)")
        }
    }
    
    // MARK: - Handle Collection Item Tap
    /// Handles the tap action on a collection item.
    /// - Ensures appropriate selection and deselection of items, including the random collection item.
    func handleCollectionItemTap(item: CollectionModel) {
        let randomCollectionName: String = CollectionModel.randomKeywordString
        
        // Handle case where the tapped item is the random collection
        guard item.collectionName != randomCollectionName else {
            // Select the random collection and deselect others
            collectionItemsArray.forEach { $0.updateIsSelected($0.collectionName == randomCollectionName) }
            return
        }
        
        // Deselect the random collection if tapped item is not the random collection
        collectionItemsArray.first(where: { $0.collectionName == randomCollectionName })?.updateIsSelected(false)
        
        // Toggle the tapped item's selection state
        item.updateIsSelected(!item.isSelected)
        
        // Ensure at least one item is selected, and reselect random collection if none are selected
        if collectionItemsArray.first(where: { $0.isSelected }) == nil {
            collectionItemsArray.first(where: { $0.collectionName == randomCollectionName })?.updateIsSelected(true)
        }
    }
    
    // MARK: - Delete Collection
    /// Deletes a specific collection.
    /// - Parameter item: The collection item to delete.
    /// - Throws: An error if the deletion fails.
    func deleteCollection(item: CollectionModel) throws {
        do {
            showChangeThumbnailButtonProgress = true
            try swiftDataManager.deleteCollectionItemModel(item)
            presentPopup(false, for: .collectionUpdatePopOver)
            withAnimation(.smooth(duration: 0.3)) {
                collectionItemsArray.removeAll(where: { $0 == item })
            }
            showChangeThumbnailButtonProgress = false
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
    
    // MARK: - Present & Dismiss Popup
    /// Presents or dismisses a popup with a specified type.
    /// - Parameters:
    ///   - isPresented: A Boolean value indicating whether the popup should be presented.
    ///   - type: The type of popup to present.
    func presentPopup(_ isPresented: Bool, for type: CollectionsViewPopOverModel) {
        withAnimation(.smooth(duration: 0.3)) { popOverItem = (isPresented, type) }
        guard !isPresented else { return }
        resetTextfieldTexts()
        Task {
            try? await Task.sleep(nanoseconds: 400_000_000) // Adds one millisecond to animation duration
            resetUpdatingItem()
        }
    }
    
    // MARK: - On Collection Items Array Change
    /// Animates the scroll position when the collection items array changes.
    /// - Parameters:
    ///   - oldValue: The previous count of collection items.
    ///   - newValue: The updated count of collection items.
    ///   - scrollPosition: A binding to the scroll position to animate.
    func onCollectionItemsArrayChange(oldValue: Int, newValue: Int, scrollPosition: Binding<ScrollPosition>) {
        guard oldValue != 0, oldValue < newValue else { return }
        withAnimation { scrollPosition.wrappedValue.scrollTo(edge: .bottom) }
    }
    
    // MARK: PRIVATE FUNCTIONS
    
    // MARK: - Get API Access Key
    private func getAPIAccessKey() async throws -> String {
        guard let localAPIAccessKey else {
            guard let tempAPIAccessKey: String = await apiAccessKeyManager.getAPIAccessKeyFromUserDefaults() else {
                throw CollectionsViewModelErrorModel.apiAccessKeyNotFound
            }
            
            localAPIAccessKey = tempAPIAccessKey
            return tempAPIAccessKey
        }
        
        return localAPIAccessKey
    }
    
    // MARK: - Add Initial Collections Array to Swift Data
    /// Adds an array of initial collection items to persistent storage.
    /// - Parameter array: An array of `CollectionModel` instances to be added.
    /// - Throws: An error if any item fails to be added to persistent storage.
    private func addInitialCollectionsArrayToSwiftData(_ array: [CollectionModel]) throws {
        for item in array {
            try swiftDataManager.addCollectionItemModel(item)
        }
    }
    
    // MARK: - getAPIAccessKeyFromUserDefaults
    /// Retrieves the API access key stored in UserDefaults.
    /// - Returns: The stored API access key as a `String`, or `nil` if not found.
    private func getAPIAccessKeyFromUserDefaults() async -> String? {
        guard let apiAccessKey: String = await defaults.get(key: .apiAccessKey) as? String else {
            return nil
        }
        
        return apiAccessKey
    }
    
    // MARK: - Check Collection Name Duplications
    /// Checks if a collection name already exists in the `collectionItemsArray`.
    /// - Parameter collectionName: The name of the collection to check.
    /// - Returns: `true` if a collection with the same name exists, otherwise `false`.
    private func checkCollectionNameDuplications(_ collectionName: String) -> Bool {
        let isExist: Bool = collectionItemsArray.contains(where: { $0.collectionName.lowercased() == collectionName.lowercased() })
        return isExist
    }
    
    // MARK: - Reset Collection Name Textfield Text
    /// Resets the text fields for collection name input (`collectionNameTextfieldText` and `collectionRenameTextfieldText`) to empty strings.
    private func resetTextfieldTexts() {
        collectionNameTextfieldText = ""
        collectionRenameTextfieldText = ""
    }
    
    // MARK: - Reset Updating Item
    /// Resets the `updatingItem` property to `nil`.
    private func resetUpdatingItem() {
        updatingItem = nil
    }
}
