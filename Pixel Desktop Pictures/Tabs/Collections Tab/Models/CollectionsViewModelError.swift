//
//  CollectionsViewModelError.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-09.
//

import Foundation

enum CollectionsViewModelError: LocalizedError {
    case failedToInitializeCollectionsTabVM(_ error: Error)
    case apiAccessKeyNotFound
    case duplicateCollectionName
    case failedToFetchInitialQueryImages(collectionNames: [String], _ error: Error)
    case failedSomethingOnQueryImages(_ error: Error)
    case failedToDeleteCollection(collectionName: String, _ error: Error)
    case failedToCreateCollection(collectionName: String, _ error: Error)
    case failedToFetchQueryImages(collectionName: String, _ error: Error)
    case failedToPrepareCollectionUpdate(for: CollectionNameUsage, _ error: Error)
    case failedToUpdateCollectionSelection(collectionName: String, _ error: Error)
    case failedToUpdateCollectionSelections(collectionName: String, _ error: Error)
    case failedToUpdateCollectionThumbnailImage(collectionName: String, _ error: Error)
    case updatingItemFoundNil
    case failedToRenameCollection(_ error: Error)
    
    var errorDescription: String? {
        switch self {
        case .failedToInitializeCollectionsTabVM(let error):
            return "❌: Failed to initialize `CollectionsTabViewModel`. \(error.localizedDescription)"
        case .apiAccessKeyNotFound:
            return "❌: Failed to create a collection item model, because api access key is not found."
        case .duplicateCollectionName:
            return "❌: Failed to create a collection item model, because it's already exist."
        case .failedToFetchInitialQueryImages(let collectionNames, let error):
            return "❌: Failed to fetch initial query images for [\(collectionNames.description)] collections. \(error.localizedDescription)"
        case .failedSomethingOnQueryImages(let error):
            return "❌: Failed something on `QueryImage`s. \(error.localizedDescription)"
        case .failedToDeleteCollection(let collectionName, let error):
            return "❌: Failed to delete collection for `\(collectionName)`. \(error.localizedDescription)"
        case .failedToCreateCollection(let collectionName, let error):
            return "❌: Failed to create `\(collectionName)` collection. \(error.localizedDescription)"
        case .failedToFetchQueryImages(let collectionName, let error):
            return "❌: Failed to fetch image api query images for `\(collectionName)` collection. \(error.localizedDescription)"
        case .failedToPrepareCollectionUpdate(let usage, let error):
            return "❌: Failed to prepare collection update for `\(usage.rawValue)`. \(error.localizedDescription)"
        case .failedToUpdateCollectionSelection(let collectionName, let error):
            return "❌: Failed to update selection for `\(collectionName)` collection. \(error.localizedDescription)"
        case .failedToUpdateCollectionSelections(let collectionName, let error):
            return "❌: Failed to update collection selections for false, except for `\(collectionName)` collection. \(error.localizedDescription)"
        case .failedToUpdateCollectionThumbnailImage(let collectionName, let error):
            return "❌: Failed to update thumbnail image for `\(collectionName)` collection. \(error.localizedDescription)"
        case .updatingItemFoundNil:
            return "❌: Updating item found nil."
        case .failedToRenameCollection(let error):
            return "❌: Failed to rename collection. \(error.localizedDescription)"
        }
    }
}
