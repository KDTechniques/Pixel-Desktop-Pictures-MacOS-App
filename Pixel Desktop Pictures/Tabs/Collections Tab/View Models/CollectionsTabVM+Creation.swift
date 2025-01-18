//
//  CollectionsTabVM+Creation.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-16.
//

import Foundation

// Create Collections Related
extension CollectionsTabViewModel {
    /// Creates a new collection and updates related components.
    ///
    /// This function handles the creation of a new collection by capitalizing the collection name,
    /// preparing the necessary data (including image quality URL strings), and saving the collection
    /// to both the local database and the collections array. It also manages UI updates for success or failure.
    ///
    /// - Note: Ensures that the collection name is valid and prevents creation of collections with empty names.
    /// - Throws: An error if the collection creation process fails, including issues with preparing data or database operations.
    func createCollection() async {
        // Collection name capitalization for processing and saving to local database.
        let collectionName: String = nameTextfieldText.capitalized
        
        // Early exit to avoid errors when creating a collection with an empty value.
        guard await handleEmptyCollectionName(collectionName) else { return }
        
        do {
            // Handle query images and get encoded collection image quality url strings
            let imageQualityURLStringsEncoded: Data = try await prepareCollectionUpdate(
                name: collectionName,
                for: .onCollectionCreation
            )
            
            // Create the `Collection` item.
            let collectionItem: Collection = .init(
                name: collectionName,
                imageQualityURLStringsEncoded: imageQualityURLStringsEncoded
            )
            
            // First, add the new item to local database.
            try await getCollectionManager().addCollections([collectionItem])
            
            // Then, add the item to the collections array.
            appendCollectionsArray(collectionItem)
            
            // Handle successful creation.
            setShowCreateButtonProgress(false)
            presentPopup(false, for: .collectionCreationPopOver)
            print("✅: `\(collectionName)` collection has been created successfully.")
        } catch {
            setShowCreateButtonProgress(false)
            print(getVMError().failedToCreateCollection(collectionName: collectionName, error).localizedDescription)
            await getErrorPopupVM().addError(getErrorPopup().failedToCreateCollection)
            getAPIAccessKeyManager().handleURLError(error)
        }
    }
}
