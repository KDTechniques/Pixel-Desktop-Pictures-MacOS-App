//
//  RecentImageURLModelSwiftDataManagerErrorModel.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-11.
//

import Foundation

enum RecentImageURLModelSwiftDataManagerErrorModel: LocalizedError {
    case modelContainerInitializationFailed(_ error: Error)
    case contextSaveFailed(_ error: Error)
    
    // Create Operation Errors
    case recentImageURLModelCreationFailed(_ error: Error)
    
    // Read Operation Errors
    case recentImageURLModelsArrayFetchFailed(_ error: Error)
    
    // Update Operation Errors
    case recentImageURLModelUpdateFailed(_ error: Error)
    
    // Delete Operation Errors
    case recentImageURLModelDeletionFailed(_ error: Error)
    case eraseAllDataFailed(_ error: Error)
    
    var errorDescription: String? {
        switch self {
        case .modelContainerInitializationFailed(let error):
            return "Error: Failed to initialize model container. \(error.localizedDescription)"
        case .contextSaveFailed(let error):
            return "Error: Failed to save context to container. \(error.localizedDescription)"
            
            // Create Operation Errors
        case .recentImageURLModelCreationFailed(let error):
            return "Error: Failed to create a recent image url model. \(error.localizedDescription)"
            
            // Read Operation Errors
        case .recentImageURLModelsArrayFetchFailed(let error):
            return "Error: Failed to fetch recent image url model from context. \(error.localizedDescription)"
            
            // Update Operation Errors
        case .recentImageURLModelUpdateFailed(let error):
            return "Error: failed to update recent image url model in context. \(error.localizedDescription)"
            
            // Delete Operation Errors
        case .recentImageURLModelDeletionFailed(let error):
            return "Error: Failed to delete recent image url model from context. \(error.localizedDescription)"
        case .eraseAllDataFailed(let error):
            return "Error: Failed to erase all data from recent image url model container. \(error.localizedDescription)"
        }
    }
}
