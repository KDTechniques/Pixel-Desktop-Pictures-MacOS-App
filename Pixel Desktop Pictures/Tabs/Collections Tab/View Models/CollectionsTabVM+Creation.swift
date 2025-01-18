//
//  CollectionsTabVM+Creation.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-16.
//

import Foundation

// Create Collections Related
extension CollectionsTabViewModel {
    func createCollection() {
        // Collection name capitalization for processing and saving to local database.
        let collectionName: String = nameTextfieldText.capitalized
        
        Task {
            // Early exit to avoid errors when creating a collection with an empty value.
            guard await handleEmptyCollectionName(collectionName) else { return }
            
            do {
                let imageQualityURLStringsEncoded: Data = try await prepareCollectionUpdate(
                    name: collectionName,
                    for: .onCollectionCreation
                )
                
                // Create the `Collection` item.
                let collectionItem: Collection = .init(
                    name: collectionName,
                    imageQualityURLStringsEncoded: imageQualityURLStringsEncoded
                )
                
                // First, add the new item to local database for better UX.
                try await getCollectionManager().addCollections([collectionItem])
                
                // Then, add the item to the collections array for the user to interact with.
                var tempCollectionsArray: [Collection] = collectionsArray
                tempCollectionsArray.append(collectionItem)
                setCollectionsArray(tempCollectionsArray)
                
                // Dismiss progress and popup after successful collection creation.
                setShowCreateButtonProgress(false)
                presentPopup(false, for: .collectionCreationPopOver)
            } catch {
                setShowCreateButtonProgress(false)
                await getErrorPopupVM().addError(getErrorPopup().failedToCreateCollection)
                getAPIAccessKeyManager().handleURLError(error)
                print("Error: Failed to create collection. \(error.localizedDescription)")
            }
        }
    }
}
