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
    let swiftDataManager: SwiftDataManager
    
    // MARK: - ASSIGNED PROPERTIES
    let defaults: UserDefaultsManager = .shared
    private(set) var isPresentedPopup: Bool = false
    var collectionNameTextfieldText: String = ""
    var collectionItemsArray: [CollectionItemModel] = []
    var showCreateButtonProgress: Bool = false
    @ObservationIgnored
    var popOverAnimation: (Animation, AnyHashable) { (.smooth(duration: 0.3), isPresentedPopup) }
    
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
    func createCollection(collectionName: String) async throws {
        showCreateButtonProgress = true
        do {
            guard !checkCollectionNameDuplications(collectionName) else {
                throw CollectionsViewModelErrorModel.duplicateCollectionName
            }
            
            guard let apiAccessKey: String = await getAPIAccessKeyFromUserDefaults() else {
                throw CollectionsViewModelErrorModel.apiAccessKeyNotFound
            }
            
            let imageAPIService: UnsplashImageAPIService = .init(apiAccessKey: apiAccessKey)
            
            let model: UnsplashQueryImageModel = try await imageAPIService.getQueryImageModel(queryText: collectionName, pageNumber: 1, imagesPerPage: 1)
            guard let imageURLString: String = model.results.first?.imageQualityURLStrings.small else {
                throw URLError(.badServerResponse)
            }
            
            let object: CollectionItemModel = .init(collectionName: collectionName, imageURLString: imageURLString)
            try swiftDataManager.addCollectionItemModel(object)
            collectionItemsArray.append(object)
            showCreateButtonProgress = false
            presentPopup(false)
            // show success alert here...
        } catch {
            showCreateButtonProgress = false
            // show an alert based on the throwing error here...
            print(error.localizedDescription)
            throw error
        }
    }
    
    func updateCollectionImageURLString(item: CollectionItemModel) async {
        do {
            guard let apiAccessKey: String = await getAPIAccessKeyFromUserDefaults() else {
                throw CollectionsViewModelErrorModel.apiAccessKeyNotFound
            }
            
            let imageAPIService: UnsplashImageAPIService = .init(apiAccessKey: apiAccessKey)
            try await swiftDataManager.updateCollectionItemModel(item, isSelected: nil, imageAPIServiceReference: imageAPIService)
        } catch {
            print("Error: Updating collection item's image url string. \(error.localizedDescription)")
        }
    }
    
    // MARK: - Update Collection Selection Status
    func updateCollectionSelectionStatus(item: CollectionItemModel, isSelected: Bool) async {
        do {
            try await swiftDataManager.updateCollectionItemModel(item, isSelected: isSelected, imageAPIServiceReference: nil)
        } catch {
            print("Error: Updating collection selection status to `\(isSelected)`. \(error.localizedDescription)")
        }
    }
    
    // MARK: - Delete Collection
    func deleteCollection(_ object: CollectionItemModel) throws {
        do {
            try swiftDataManager.deleteCollectionItemModel(object)
            withAnimation(.smooth(duration: 0.3)) {
                collectionItemsArray.removeAll(where: { $0 == object })
            }
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
    
    // MARK: - Present & Dismiss Popup
    func presentPopup(_ isPresented: Bool) {
        isPresentedPopup = isPresented
        isPresented ? () : resetCollectionNameTextfieldText()
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
    private func resetCollectionNameTextfieldText() {
        collectionNameTextfieldText = ""
    }
}
