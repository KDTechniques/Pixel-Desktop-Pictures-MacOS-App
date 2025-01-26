//
//  CollectionLocalDatabaseManagerError.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-11.
//

import Foundation

enum CollectionLocalDatabaseManagerError: LocalizedError {
    case failedToCreateCollection(_ error: Error)
    case failedToFetchCollections(_ error: Error)
    case failedToUpdateCollections(_ error: Error)
    case failedToDeleteCollection(_ error: Error)
    
    var errorDescription: String? {
        switch self {
        case .failedToCreateCollection(let error):
            return "❌: Failed to create collection. \(error.localizedDescription)"
        case .failedToFetchCollections(let error):
            return "❌: Failed to fetch collections from context. \(error.localizedDescription)"
        case .failedToUpdateCollections(let error):
            return "❌: failed to update collections. \(error.localizedDescription)"
        case .failedToDeleteCollection(let error):
            return "❌: Failed to delete collection from context. \(error.localizedDescription)"
        }
    }
}
