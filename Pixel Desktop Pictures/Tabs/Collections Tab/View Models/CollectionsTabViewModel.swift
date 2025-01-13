//
//  CollectionsTabViewModel.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-23.
//

import SwiftUICore

@MainActor
@Observable final class CollectionsTabViewModel {
    // MARK: - INJECTED PROPERTIES
    let collectionModelSwiftDataManager: CollectionModelSwiftDataManager
    let imageQueryURLModelSwiftDataManager: ImageQueryURLModelSwiftDataManager
    let apiAccessKeyManager: APIAccessKeyManager
    let errorPopupVM: ErrorPopupViewModel
    
    // MARK: - ASSIGNED PROPERTIES
    let defaults: UserDefaultsManager = .shared
    var collectionNameTextfieldText: String = ""
    var collectionRenameTextfieldText: String = ""
    var collectionItemsArray: [CollectionModel] = [] { didSet { getNSetImageQueryModelsArray() } }
    var showCreateButtonProgress: Bool = false
    var showRenameButtonProgress: Bool = false
    var showChangeThumbnailButtonProgress: Bool = false
    private(set) var popOverItem: (isPresented: Bool, type: CollectionsViewPopOverModel) = (false, .collectionCreationPopOver)
    var updatingItem: CollectionModel?
    private(set) var localAPIAccessKey: String?
    let errorPopupModel = CollectionsTabErrorPopupModel.self
    let encoder: JSONEncoder = .init()
    let decoder: JSONDecoder = .init()
    
    /// get a random index object and pass it to model manager to get an image
    var imageQueryURLModelsArray: [ImageQueryURLModel] = []
    
    // MARK: - INITIALIZER
    /// Initializes the CollectionsTabViewModel with a SwiftDataManager instance.
    /// - Parameter collectionModelSwiftDataManager: The instance of SwiftDataManager used for data management.
    init(
        apiAccessKeyManager: APIAccessKeyManager,
        collectionModelSwiftDataManager: CollectionModelSwiftDataManager,
        imageQueryURLModelSwiftDataManager: ImageQueryURLModelSwiftDataManager,
        errorPopupVM: ErrorPopupViewModel
    ) {
        self.apiAccessKeyManager = apiAccessKeyManager
        self.collectionModelSwiftDataManager = collectionModelSwiftDataManager
        self.imageQueryURLModelSwiftDataManager = imageQueryURLModelSwiftDataManager
        self.errorPopupVM = errorPopupVM
    }
    
    // MARK: FUNCTIONS
    
    // MARK: INTERNAL FUNCTIONS
    
    // MARK: - Initialize Collections View Model
    /// Initializes the view model by fetching existing collection items or creating default ones if none exist.
    func initializeCollectionsViewModel() async {
        localAPIAccessKey = await apiAccessKeyManager.getAPIAccessKeyFromUserDefaults()
        
        do {
            // Try to fetch collection items from SwiftData, if available.
            let fetchedCollectionItemsArray: [CollectionModel] = try collectionModelSwiftDataManager.fetchCollectionItemModelsArray()
            
            // Handle the case where no data is found in SwiftData.
            guard !fetchedCollectionItemsArray.isEmpty else {
                // Use the default values as the initial data or fallback option.
                let defaultCollectionItemsArray: [CollectionModel] = try CollectionModel.getDefaultCollectionsArray()
                
                // Filter Non `RANDOM` collection models and get only collection names for processing
                let collectionNamesArray: [String] = defaultCollectionItemsArray
                    .filter { $0.collectionName != CollectionModel.randomKeywordString }
                    .map({ $0.collectionName })
                
                // Fetch and Add Initial `ImageQueryURLModel`s to swift data
                try await fetchNAddImageQueryURLModel(with: collectionNamesArray)
                
                // Prepare the `collectionItemsArray` and save it to SwiftData.
                collectionItemsArray = defaultCollectionItemsArray
                try addInitialCollectionsArrayToSwiftData(defaultCollectionItemsArray)
                return
            }
            
            // After the initial launch, SwiftData is available for use.
            collectionItemsArray = fetchedCollectionItemsArray
            print("`Collections Tab View Model` has been initialized!")
        } catch {
            print("Error: Failed to initialize `Collections View Model`: \(error.localizedDescription)")
            
            do {
                collectionItemsArray = try CollectionModel.getDefaultCollectionsArray()
            } catch {
                collectionItemsArray = [] // Window error will be taken care of from view level
            }
        }
    }
    
    // MARK: - Create Collection
    /// Creates a new collection with the name provided in `collectionNameTextfieldText`.
    /// - Validates the collection name, checks for duplications, fetches an image from Unsplash API,
    ///   and saves the collection to persistent storage.
    func createCollection() {
        // Assign the collection name to a temporary property in case it changes before this function finishes.
        let collectionName: String = collectionNameTextfieldText.capitalized
        
        // Early exit to avoid errors when creating a collection with an empty value.
        guard !collectionName.isEmpty else { return }
        
        Task {
            do {
                // Since the collection name must be unique in the SwiftData model, duplication must be avoided.
                try await checkCollectionNameDuplications(collectionName)
                showCreateButtonProgress = true
                
                // Create image API service instance to fetch data for the new collection
                let apiAccessKey: String = try await getAPIAccessKey()
                let imageAPIService: UnsplashImageAPIService = .init(apiAccessKey: apiAccessKey)
                
                // Check whether the image query url model exist or not to avoid updating existing data with initial values.
                let isImageQueryURLModelExist: Bool = try !imageQueryURLModelSwiftDataManager.fetchImageQueryURLModelsArray(for: [collectionName]).isEmpty
                
                // Collection creation requires only one image URL model to work with.
                let model: UnsplashQueryImageModel = try await imageAPIService.getQueryImageModel(
                    queryText: collectionName,
                    pageNumber: 1,
                    imagesPerPage: isImageQueryURLModelExist ? 1 : UnsplashImageAPIService.imagesPerPage
                )
                
                // Get the first result, as there are more results.
                guard let imageURLs: UnsplashImageURLsModel = model.results.first?.imageQualityURLStrings else {
                    throw URLError(.badServerResponse)
                }
                
                // Create the `CollectionModel` object.
                let imageURLsData: Data = try encoder.encode(imageURLs)
                let object: CollectionModel = .init(collectionName: collectionName, imageURLsData: imageURLsData)
                
                if !isImageQueryURLModelExist {
                    // Create the `ImageQueryURLModel` object relevant to the collection name.
                    let queryResultsDataArray: Data = try encoder.encode(model.results)
                    let imageQueryURLObject: ImageQueryURLModel = .init(queryText: collectionName, queryResultsDataArray: queryResultsDataArray)
                    
                    // Save the `ImageQueryURLModel` object to swift data
                    try imageQueryURLModelSwiftDataManager.addImageQueryURLModel([imageQueryURLObject])
                }
                
                // First, add the new object to SwiftData for better UX.
                try collectionModelSwiftDataManager.addCollectionItemModel(object)
                
                // Then, add the object to the collections array for the user to interact with.
                collectionItemsArray.append(object)
                
                // Dismiss progress and popup after successful collection creation.
                showCreateButtonProgress = false
                presentPopup(false, for: .collectionCreationPopOver)
            } catch {
                showCreateButtonProgress = false
                await errorPopupVM.addError(errorPopupModel.failedToCreateCollection)
                handleURLError(error)
                print("Error: Failed to create collection. \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Update Collection Name
    /// Updates the name of an existing collection.
    /// - Uses `collectionRenameTextfieldText` for the new name and updates it in persistent storage.
    func updateCollectionName() {
        Task {
            // Check updating item before proceeding.
            let newCollectionName: String = collectionRenameTextfieldText.capitalized
            guard !newCollectionName.isEmpty,
                  let item: CollectionModel = updatingItem else {
                await errorPopupVM.addError(errorPopupModel.somethingWentWrong)
                print("Error: Either collection name or updating item is nil.")
                return
            }
            
            do {
                // To avoid updating collection names to already exist one.
                try await checkCollectionNameDuplications(newCollectionName)
                showRenameButtonProgress = true
                
                // Create instance of image API service to fetch new data according to new collection name.
                let apiAccessKey: String = try await getAPIAccessKey()
                let imageAPIService: UnsplashImageAPIService = .init(apiAccessKey: apiAccessKey)
                
                if try imageQueryURLModelSwiftDataManager.fetchImageQueryURLModelsArray(for: [newCollectionName]).isEmpty {
                    // Fetch query image data from Unsplash and encode it
                    let queryResults: UnsplashQueryImageModel = try await imageAPIService.getQueryImageModel(queryText: newCollectionName, pageNumber: 1)
                    let queryResultsDataArray: Data = try encoder.encode(queryResults.results)
                    
                    // Create new image query url model object and save to swift data.
                    let imageQueryURLObject: ImageQueryURLModel = .init(queryText: newCollectionName, queryResultsDataArray: queryResultsDataArray)
                    try imageQueryURLModelSwiftDataManager.addImageQueryURLModel([imageQueryURLObject])
                }
                
                // Update collection name in swift data
                try await collectionModelSwiftDataManager.updateCollectionName(in: item, newCollectionName: newCollectionName, imageAPIServiceReference: imageAPIService)
                
                // Handle success update
                showRenameButtonProgress = false
                resetTextfieldTexts()
            } catch {
                showRenameButtonProgress = false
                await errorPopupVM.addError(errorPopupModel.failedToUpdateCollectionName)
                handleURLError(error)
                print("Error: Failed to update collection name. \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Update Collection Image URL String
    /// Updates the image URL for a specific collection item.
    /// - Parameter item: The collection item to update.
    func updateCollectionImageURLString(item: CollectionModel) async {
        showChangeThumbnailButtonProgress = true
        
        do {
            // Create an instance of image API service to fetch new image URLs for the desired collection.
            let apiAccessKey: String = try await getAPIAccessKey()
            let imageAPIService: UnsplashImageAPIService = .init(apiAccessKey: apiAccessKey)
            
            // Save new image urls to swift data.
            try await collectionModelSwiftDataManager.updateCollectionImageURLString(in: item, imageAPIServiceReference: imageAPIService)
            
            // Handle success
            showChangeThumbnailButtonProgress = false
        } catch {
            showChangeThumbnailButtonProgress = false
            await errorPopupVM.addError(errorPopupModel.failedToUpdateCollectionThumbnail)
            handleURLError(error)
            print("Error: Failed to update collection thumbnail. \(error.localizedDescription)")
        }
    }
    
    // MARK: - Update Collection Selection
    /// Handles the tap action on a collection item.
    /// - Ensures appropriate selection and deselection of items, including the random collection item.
    func updateCollectionSelection(item: CollectionModel) {
        let randomCollectionName: String = CollectionModel.randomKeywordString
        
        do {
            // Handle case where the tapped item is the random collection.
            guard item.collectionName != randomCollectionName else {
                // Select the random collection and deselect others.
                collectionItemsArray.forEach { $0.isSelected = $0.collectionName == randomCollectionName }
                
                // Remove previously selected collections related image query url models from it's array
                resetImageQueryURLModelsArray()
                
                try collectionModelSwiftDataManager.swiftDataManager.saveContext()
                return
            }
            
            // Toggle the tapped item's selection state.
            item.isSelected = !item.isSelected
            try collectionModelSwiftDataManager.swiftDataManager.saveContext()
            
            // Add collection item to image query url model array if the collection is selected otherwise remove it
            item.isSelected ? getNSetImageQueryModelsArray() : removeImageQueryURLModelFromArray(collectionName: item.collectionName)
            
            // Deselect the random collection if tapped item is not the random collection.
            guard let randomCollectionItem: CollectionModel = collectionItemsArray.first(where: { $0.collectionName == randomCollectionName }) else { return }
            randomCollectionItem.isSelected = false
            try collectionModelSwiftDataManager.swiftDataManager.saveContext()
            
            // Ensure at least one item is selected
            guard let _ = collectionItemsArray.first(where: { $0.isSelected }) else {
                // If no item is selected, reselect the random collection.
                randomCollectionItem.isSelected = true
                try collectionModelSwiftDataManager.swiftDataManager.saveContext()
                return
            }
        } catch {
            Task { await errorPopupVM.addError(errorPopupModel.failedToUpdateCollectionSelection) }
            print("Error: Failed to update collection selection. \(error.localizedDescription)")
        }
    }
    
    // MARK: - Delete Collection
    /// Deletes a specific collection.
    /// - Parameter item: The collection item to delete.
    /// - Throws: An error if the deletion fails.
    func deleteCollection(item: CollectionModel) {
        do {
            // Remove collection from swift data
            try collectionModelSwiftDataManager.deleteCollectionItemModel(at: item)
            
            // Handle success deletion
            presentPopup(false, for: .collectionUpdatePopOver)
            withAnimation(.smooth(duration: 0.3)) {
                collectionItemsArray.removeAll(where: { $0 == item })
            }
        } catch {
            Task { await errorPopupVM.addError(errorPopupModel.failedToDeleteCollection) }
            print("Error: Failed to delete collection. \(error.localizedDescription)")
        }
    }
    
    // MARK: - Present & Dismiss Popup
    /// Presents or dismisses a popup with a specified type.
    /// - Parameters:
    ///   - isPresented: A Boolean value indicating whether the popup should be presented.
    ///   - type: The type of popup to present.
    func presentPopup(_ isPresented: Bool, for type: CollectionsViewPopOverModel) {
        withAnimation(.smooth(duration: 0.4)) { popOverItem = (isPresented, type) }
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
    
    // MARK: - handle URL Error
    /// Handles URL-related errors and updates the API access key status based on the error type.
    ///
    /// This function processes a given `Error` to identify URL-specific issues, particularly handling `URLError` codes.
    /// It updates the API access key status according to the error type. For example, it will mark the API key as rate-limited
    /// or invalid depending on the specific error code.
    ///
    /// - Parameter error: An optional `Error` object that represents the URL-related error to be handled.
    /// - If the error is a `URLError`, it checks for specific error codes and updates the `apiAccessKeyManager` accordingly:
    ///   - `.clientCertificateRejected`: Sets the API access key status to `.rateLimited`.
    ///   - `.userAuthenticationRequired`: Sets the API access key status to `.invalid`.
    ///   - For other errors, it prints the error description.
    private func handleURLError(_ error: Error?) {
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
    }
    
    // MARK: - Get API Access Key
    /// Retrieves the API access key, either from a local variable or user defaults.
    ///
    /// This function checks if a local API access key exists. If it does, the function returns it.
    /// If not, it attempts to fetch the API access key from user defaults asynchronously. If the key is found,
    /// it stores it in the local variable for future use. If the key is not available, it throws an error.
    ///
    /// - Throws: `CollectionsViewModelErrorModel.apiAccessKeyNotFound` if the API access key is not available in either the local variable or user defaults.
    /// - Returns: The API access key as a `String`.
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
            try collectionModelSwiftDataManager.addCollectionItemModel(item)
        }
    }
    
    // MARK: - Check Collection Name Duplications
    /// Checks if a collection name already exists in the collection items array.
    ///
    /// This function checks if the given collection name already exists in the `collectionItemsArray`,
    /// ignoring case differences. If a duplicate is found, it updates the progress indicators and displays
    /// an error message. It then throws a `CollectionsViewModelErrorModel.duplicateCollectionName` error.
    ///
    /// - Parameter collectionName: The name of the collection to check for duplication.
    ///
    /// - Throws: `CollectionsViewModelErrorModel.duplicateCollectionName` if the collection name is already in the collection items array.
    ///
    /// - Updates:
    ///   - Sets `showCreateButtonProgress` and `showRenameButtonProgress` to `false` if a duplicate is found.
    ///   - Adds an error to the error popup view model (`errorPopupVM`) to notify the user of the duplication.
    private func checkCollectionNameDuplications(_ collectionName: String) async throws {
        let isExist: Bool = collectionItemsArray.contains(where: { $0.collectionName.lowercased() == collectionName.lowercased() })
        if isExist {
            showCreateButtonProgress = false
            showRenameButtonProgress = false
            await errorPopupVM.addError(errorPopupModel.duplicateCollectionNameFound)
            throw CollectionsViewModelErrorModel.duplicateCollectionName
        }
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
    
    // MARK: - Fetch and Add Image Query URL Model
    private func fetchNAddImageQueryURLModel(with collectionNamesArray: [String]) async throws {
        // Create image API service instance to fetch data for each `ImageQueryURLModel` on collection name
        let apiAccessKey: String = try await getAPIAccessKey()
        let imageAPIService: UnsplashImageAPIService = .init(apiAccessKey: apiAccessKey)
        
        // Using withTaskGroup for concurrency
        let queryResultsArray: [(String, UnsplashQueryImageModel)] = try await withThrowingTaskGroup(of: (String, UnsplashQueryImageModel).self) { taskGroup in
            for collectionName in collectionNamesArray {
                taskGroup.addTask {
                    // Fetch data for each collection name
                    do {
                        print("Fetching data for \(collectionName)...")
                        let queryResults: UnsplashQueryImageModel = try await imageAPIService.getQueryImageModel(queryText: collectionName, pageNumber: 1)
                        print("Successfully fetched data for \(collectionName).")
                        return (collectionName, queryResults)
                    } catch {
                        print("Error: Failed fetch data for \(collectionName). \(error)")
                        throw error
                    }
                }
            }
            
            // Collect results
            var tempQueryResultsArray: [(String, UnsplashQueryImageModel)] = []
            for try await result in taskGroup {
                tempQueryResultsArray.append(result)
            }
            
            return tempQueryResultsArray
        }
        
        print("All tasks completed. Query results: \(queryResultsArray)")
        
        // Create `ImageQueryURLModel` objects once all tasks are complete
        var imageQueryURLsArray: [ImageQueryURLModel] = []
        let encoder: JSONEncoder = .init()
        
        for queryResult in queryResultsArray {
            do {
                let queryResultsDataArray: Data = try encoder.encode(queryResult.1)
                let imageQueryURLObject: ImageQueryURLModel = .init(queryText: queryResult.0, queryResultsDataArray: queryResultsDataArray)
                imageQueryURLsArray.append(imageQueryURLObject)
            } catch {
                print("Error: Failed to encode data for \(queryResult.0). \(error)")
                throw error
            }
        }
        
        // Save created `ImageQueryURLModel` objects to swift data
        print("All tasks completed. Saving \(imageQueryURLsArray.count) `ImageQueryURLModel`s to SwiftData...")
        try imageQueryURLModelSwiftDataManager.addImageQueryURLModel(imageQueryURLsArray)
    }
    
    // MARK: - Get and Set Image Query Models Array
    private func getNSetImageQueryModelsArray() {
        /// Filter the selected ones and get their names.
        /// Then pass them to the SwiftDataManager class to fetch an array of [ImageQueryURLModel].
        /// Finally, assign the result to imageQueryURLModelsArray.
        let selectedCollectionNamesArray: [String] = collectionItemsArray.filter({ $0.isSelected }).map({ $0.collectionName })
        
        do {
            let imageQueryModelsArray: [ImageQueryURLModel] = try imageQueryURLModelSwiftDataManager.fetchImageQueryURLModelsArray(for: selectedCollectionNamesArray)
            self.imageQueryURLModelsArray = imageQueryModelsArray
        } catch {
            print("Error: Failed to set `ImageQueryURLModels` to an array. \(error.localizedDescription)")
        }
    }
    
    // MARK: - Reset Image Query URL Models Array
    private func resetImageQueryURLModelsArray() {
        imageQueryURLModelsArray = []
    }
    
    // MARK: - Remove Image Query URL Model from Array
    private func removeImageQueryURLModelFromArray(collectionName: String) {
        imageQueryURLModelsArray.removeAll(where: { $0.queryText == collectionName })
    }
}
