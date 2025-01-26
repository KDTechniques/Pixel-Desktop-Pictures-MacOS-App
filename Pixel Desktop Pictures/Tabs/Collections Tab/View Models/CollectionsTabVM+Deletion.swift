//
//  CollectionsTabVM+Deletion.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-17.
//

import SwiftUICore

extension CollectionsTabViewModel {
    /// Deletes a collection and updates associated states.
    ///
    /// This function removes the specified collection from the local database and updates the collections array
    /// with a smooth animation. It ensures the query images array reflects the deletion and handles scenarios
    /// where the deleted collection was the only selected item by selecting the "RANDOM" collection if necessary.
    ///
    /// - Parameter item: The collection to be deleted.
    /// - Note: The animation duration is considered to ensure proper timing for UI updates.
    /// - Throws: An error if the deletion process fails in the database or any subsequent operations encounter an issue.
    func deleteCollection(at item: Collection) async {
        let animationDuration: TimeInterval = 0.3
        
        do {
            // First, remove the collection from the local database.
            try await getCollectionManager().deleteCollection(at: item)
            
            // Dismiss popup and wait for a fully dismiss happens
            presentPopup(false, for: .collectionUpdatePopOver)
            try await Task.sleep(nanoseconds: UInt64(TabItem.bottomPopupAnimationDuration * 1_000_000_000))
            
            // Then animate the removal of the collection from the collections array with better user experience.
            withAnimation(.smooth(duration: animationDuration)) {
                removeFromCollectionsArray(item)
            }
            
            // Wait until the animation finishes before proceeding with further logic.
            try await Task.sleep(nanoseconds: UInt64(animationDuration * 1_000_000_000))
            
            // Remove the deleted collection from query images array.
            try await getAndSetQueryImagesArray()
            
            // Handle where the deleted item was the only selected item in the collections.
            if !collectionsArray.contains(where: { $0.isSelected }) {
                guard let randomCollectionItem = collectionsArray.first(where: { $0.name == Collection.randomKeywordString }) else { return }
                
                // Select the `RANDOM` collection.
                await updateCollectionSelection(item: randomCollectionItem)
            }
            
            Logger.log("✅: `\(item.name)` collection has been deleted")
        } catch {
            Logger.log(getVMError().failedToDeleteCollection(collectionName: item.name, error).localizedDescription)
            await getErrorPopupVM().addError(getErrorPopup().failedToDeleteCollection)
        }
    }
}
