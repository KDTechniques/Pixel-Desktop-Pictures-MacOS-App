//
//  CollectionsTabVM+Deletion.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-17.
//

import SwiftUICore

extension CollectionsTabViewModel {
    func deleteCollection(at item: Collection) async {
        do {
            // Remove the collection from local database.
            try await getCollectionManager().deleteCollection(at: item)
            
            // Then remove the collection from the collections array.
            var tempCollectionsArray: [Collection] = collectionsArray
            tempCollectionsArray.removeAll(where: { $0 == item })
            withAnimation(.smooth(duration: 0.3)) {
                setCollectionsArray(tempCollectionsArray)
            }
            
            // Handle where the deleted item was the only selected item in the collections.
            if !tempCollectionsArray.contains(where: { $0.isSelected }) {
                guard let randomCollectionItem: Collection = collectionsArray.first(where: { $0.name == Collection.randomKeywordString }) else { return }
                
                // If so, select the `RANDOM` collection.
                await updateCollectionSelection(item: randomCollectionItem)
            }
            
            // Handle success deletion
            presentPopup(false, for: .collectionUpdatePopOver)
        } catch {
            Task { await getErrorPopupVM().addError(getErrorPopup().failedToDeleteCollection) }
            print("Error: Failed to delete collection. \(error.localizedDescription)")
        }
    }
}
