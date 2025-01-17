//
//  CollectionLocalDatabaseManagerErrors.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-11.
//

import Foundation

enum CollectionLocalDatabaseManagerErrors: LocalizedError {
    // Create Operation Errors
    case failedToCreateCollection(_ error: Error)
    
    // Read Operation Errors
    case failedToFetchCollections(_ error: Error)
    
    // Update Operation Errors
    case failedToUpdateCollections(_ error: Error)
    
    // Delete Operation Errors
    case failedToDeleteCollection(_ error: Error)
    
    var errorDescription: String? {
        switch self {
            // Create Operation Errors
        case .failedToCreateCollection(let error):
            return "Error: Failed to create collection. \(error.localizedDescription)"
            
            // Read Operation Errors
        case .failedToFetchCollections(let error):
            return "Error: Failed to fetch collections from context. \(error.localizedDescription)"
            
            // Update Operation Errors
        case .failedToUpdateCollections(let error):
            return "Error: failed to update collections. \(error.localizedDescription)"
            
            // Delete Operation Errors
        case .failedToDeleteCollection(let error):
            return "Error: Failed to delete collection from context. \(error.localizedDescription)"
        }
    }
}
