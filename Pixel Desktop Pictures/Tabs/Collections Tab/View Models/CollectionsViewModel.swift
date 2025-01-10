//
//  CollectionsViewModel.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-23.
//

import SwiftUICore

enum CollectionsViewPopOverModel: CaseIterable {
    case collectionCreationPopOver
    case collectionUpdatePopOver
}

@MainActor
@Observable final class CollectionsViewModel {
    // MARK: - INJECTED PROPERTIES
    let swiftDataManager: SwiftDataManager
    
    // MARK: - ASSIGNED PROPERTIES
    let defaults: UserDefaultsManager = .shared
    var collectionNameTextfieldText: String = ""
    var collectionRenameTextfieldText: String = ""
    var collectionItemsArray: [CollectionItemModel] = []
    var showCreateButtonProgress: Bool = false
    var showRenameButtonProgress: Bool = false
    var showChangeThumbnailButtonProgress: Bool = false
    private(set) var popOverItem: (isPresented: Bool, type: CollectionsViewPopOverModel) = (false, .collectionCreationPopOver)
    var updatingItem: CollectionItemModel?
    
    
    // MARK: - INITIALIZER
    init(swiftDataManager: SwiftDataManager) {
        self.swiftDataManager = swiftDataManager
    }
    
    // MARK: FUNCTIONS
    
    // MARK: INTERNAL FUNCTIONS
    
    func initializeCollectionsViewModel() {
        do {
            let fetchedCollectionItemsArray: [CollectionItemModel] = try swiftDataManager.fetchCollectionItemModelsArray()
            guard !fetchedCollectionItemsArray.isEmpty else {
                let defaultCollectionItemsArray: [CollectionItemModel] = CollectionItemModel.defaultCollectionsArray
                collectionItemsArray = defaultCollectionItemsArray
                try addInitialCollectionsArrayToSwiftData(defaultCollectionItemsArray)
                return
            }
            
            collectionItemsArray = fetchedCollectionItemsArray
            print("Collections View Model is initialized!")
        } catch {
            print(error.localizedDescription)
            collectionItemsArray = CollectionItemModel.defaultCollectionsArray
        }
    }
    
    // MARK: - Create Collection
    func createCollection() {
        let collectionName: String = collectionNameTextfieldText
        guard !collectionName.isEmpty else { return }
        showCreateButtonProgress = true
        
        Task {
            do {
                guard !checkCollectionNameDuplications(collectionName) else {
                    throw CollectionsViewModelErrorModel.duplicateCollectionName
                }
                
                guard let apiAccessKey: String = await getAPIAccessKeyFromUserDefaults() else {
                    throw CollectionsViewModelErrorModel.apiAccessKeyNotFound
                }
                
                let imageAPIService: UnsplashImageAPIService = .init(apiAccessKey: apiAccessKey)
                
                let model: UnsplashQueryImageModel = try await imageAPIService.getQueryImageModel(
                    queryText: collectionName,
                    pageNumber: 1,
                    imagesPerPage: 1
                )
                
                guard let imageURLs: UnsplashImageURLsModel = model.results.first?.imageQualityURLStrings else {
                    throw URLError(.badServerResponse)
                }
                
                let object: CollectionItemModel = .init(collectionName: collectionName, imageURLs: imageURLs)
                try swiftDataManager.addCollectionItemModel(object)
                collectionItemsArray.append(object)
                showCreateButtonProgress = false
                presentPopup(false, for: .collectionCreationPopOver)
                // show success alert here...
            } catch {
                showCreateButtonProgress = false
                // show an alert based on the throwing error here...
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Update Collection Name
    func updateCollectionName() {
        let newCollectionName: String = collectionRenameTextfieldText
        guard !newCollectionName.isEmpty,
              let item: CollectionItemModel = updatingItem else {
            return
        }
        
        showRenameButtonProgress = true
        
        Task {
            do {
                guard !checkCollectionNameDuplications(newCollectionName) else {
                    throw CollectionsViewModelErrorModel.duplicateCollectionName
                }
                
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
    
    func updateCollectionImageURLString(item: CollectionItemModel) async {
        showChangeThumbnailButtonProgress = true
        do {
            guard let apiAccessKey: String = await getAPIAccessKeyFromUserDefaults() else {
                throw CollectionsViewModelErrorModel.apiAccessKeyNotFound
            }
            
            let imageAPIService: UnsplashImageAPIService = .init(apiAccessKey: apiAccessKey)
            try await swiftDataManager.updateCollectionImageURLString(item, imageAPIServiceReference: imageAPIService)
            showChangeThumbnailButtonProgress = false
        } catch {
            showChangeThumbnailButtonProgress = false
            print("Error: Updating collection item's image url string. \(error.localizedDescription)")
        }
    }
    
    // MARK: - Update Collection Selection Status
    func updateCollectionSelectionStatus(item: CollectionItemModel, isSelected: Bool) {
        do {
            try swiftDataManager.updateCollectionSelectionState(item, isSelected: isSelected)
        } catch {
            print("Error: Updating collection selection status to `\(isSelected)`. \(error.localizedDescription)")
        }
    }
    
    // MARK: - Delete Collection
    func deleteCollection(item: CollectionItemModel) throws {
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
    func presentPopup(_ isPresented: Bool, for type: CollectionsViewPopOverModel) {
        withAnimation(.smooth(duration: 0.3)) { popOverItem = (isPresented, type) }
        guard !isPresented else { return }
        resetTextfieldTexts()
        Task {
            try? await Task.sleep(nanoseconds: 400_000_000) // Adds one millisecond to animation duration
            resetUpdatingItem()
        }
    }
    
    // MARK: PRIVATE FUNCTIONS
    
    // MARK: - Add Initial Collections Array to Swift Data
    private func addInitialCollectionsArrayToSwiftData(_ array: [CollectionItemModel]) throws {
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
    private func checkCollectionNameDuplications(_ collectionName: String) -> Bool {
        let isExist: Bool = collectionItemsArray.contains(where: { $0.collectionName.lowercased() == collectionName.lowercased() })
        return isExist
    }
    
    // MARK: - Reset Collection Name Textfield Text
    private func resetTextfieldTexts() {
        collectionNameTextfieldText = ""
        collectionRenameTextfieldText = ""
    }
    
    // MARK: - Reset Updating Item
    private func resetUpdatingItem() {
        updatingItem = nil
    }
}
