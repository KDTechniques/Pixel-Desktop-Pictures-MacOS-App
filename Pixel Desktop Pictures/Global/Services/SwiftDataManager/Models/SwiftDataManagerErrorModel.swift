//
//  SwiftDataManagerErrorModel.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-08.
//

import Foundation

enum SwiftDataManagerErrorModel: LocalizedError {
    case modelContainerInitializationFailed(_ error: Error)
    case contextSaveFailed(_ error: Error)
    
    // Create Operation Errors
    case imageQueryURLModelCreationFailed(_ error: Error)
    case recentImageURLModelCreationFailed(_ error: Error)
    
    // Read Operation Errors
    case imageQueryURLModelsArrayFetchFailed(_ error: Error)
    case recentImageURLModelsArrayFetchFailed(_ error: Error)
    
    // Update Operation Errors
    case imageQueryURLModelUpdateFailed(_ error: Error)
    case recentImageURLModelUpdateFailed(_ error: Error)
    
    // Delete Operation Errors
    case imageQueryURLModelDeletionFailed(_ error: Error)
    case recentImageURLModelDeletionFailed(_ error: Error)
    
    var errorDescription: String? {
        switch self {
        case .modelContainerInitializationFailed(let error):
            return "Error: Failed to initialize model container. \(error.localizedDescription)"
        case .contextSaveFailed(let error):
            return "Error: Failed to save context to container. \(error.localizedDescription)"
            
            // Create Operation Errors
        case .imageQueryURLModelCreationFailed(let error):
            return "Error: Failed to create an image query url model. \(error.localizedDescription)"
        case .recentImageURLModelCreationFailed(let error):
            return "Error: Failed to create a recent image url model. \(error.localizedDescription)"
            
            // Read Operation Errors
        case .imageQueryURLModelsArrayFetchFailed(let error):
            return "Error: Failed to fetch image query url model from context. \(error.localizedDescription)"
        case .recentImageURLModelsArrayFetchFailed(let error):
            return "Error: Failed to fetch recent image url model from context. \(error.localizedDescription)"
            
            // Update Operation Errors
        case .imageQueryURLModelUpdateFailed(let error):
            return "Error: Failed to update image query url model in context. \(error.localizedDescription)"
        case .recentImageURLModelUpdateFailed(let error):
            return "Error: failed to update recent image url model in context. \(error.localizedDescription)"
            
            // Delete Operation Errors
        case .imageQueryURLModelDeletionFailed(let error):
            return "Error: Failed to delete image query url model. \(error.localizedDescription)"
        case .recentImageURLModelDeletionFailed(let error):
            return "Error: Failed to delete recent image url model. \(error.localizedDescription)"
        }
    }
}
