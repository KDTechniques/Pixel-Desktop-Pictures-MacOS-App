//
//  CollectionModelSwiftDataManagerErrorModel.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-11.
//

import Foundation

enum CollectionModelSwiftDataManagerErrorModel: LocalizedError {
    case modelContainerInitializationFailed(_ error: Error)
    case contextSaveFailed(_ error: Error)
    
    // Create Operation Errors
    case collectionItemModelCreationFailed(_ error: Error)
    
    // Read Operation Errors
    case collectionItemModelsArrayFetchFailed(_ error: Error)
    
    // Update Operation Errors
    case collectionItemModelUpdateFailed(_ error: Error)
    
    // Delete Operation Errors
    case collectionItemModelDeletionFailed(_ error: Error)
    case eraseAllDataFailed(_ error: Error)
    
    var errorDescription: String? {
        switch self {
        case .modelContainerInitializationFailed(let error):
            return "Error: Failed to initialize model container. \(error.localizedDescription)"
        case .contextSaveFailed(let error):
            return "Error: Failed to save context to container. \(error.localizedDescription)"
            
            // Create Operation Errors
        case .collectionItemModelCreationFailed(let error):
            return "Error: Failed to create a collection item model. \(error.localizedDescription)"
            
            // Read Operation Errors
        case .collectionItemModelsArrayFetchFailed(let error):
            return "Error: Failed to fetch collection item model from context. \(error.localizedDescription)"
            
            // Update Operation Errors
        case .collectionItemModelUpdateFailed(let error):
            return "Error: failed to update collection item model in context. \(error.localizedDescription)"
            
            // Delete Operation Errors
        case .collectionItemModelDeletionFailed(let error):
            return "Error: Failed to delete collection item model from context. \(error.localizedDescription)"
        case .eraseAllDataFailed(let error):
            return "Error: Failed to erase all data from collection model container. \(error.localizedDescription)"
        }
    }
}
