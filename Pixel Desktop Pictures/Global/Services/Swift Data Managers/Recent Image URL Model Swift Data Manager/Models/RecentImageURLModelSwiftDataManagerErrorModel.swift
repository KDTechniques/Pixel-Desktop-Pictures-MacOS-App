//
//  RecentImageURLModelSwiftDataManagerErrorModel.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-11.
//

import Foundation

enum RecentImageURLModelSwiftDataManagerErrorModel: LocalizedError {
    // Create Operation Errors
    case recentImageURLModelCreationFailed(_ error: Error)
    
    // Read Operation Errors
    case recentImageURLModelsArrayFetchFailed(_ error: Error)
    
    // Update Operation Errors
    case recentImageURLModelUpdateFailed(_ error: Error)
    
    // Delete Operation Errors
    case recentImageURLModelDeletionFailed(_ error: Error)
    
    var errorDescription: String? {
        switch self {
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
        }
    }
}
