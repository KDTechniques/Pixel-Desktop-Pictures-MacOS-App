//
//  ImageQueryURLModelSwiftDataManagerErrorModel.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-11.
//

import Foundation

enum ImageQueryURLModelSwiftDataManagerErrorModel: LocalizedError {
    case modelContainerInitializationFailed(_ error: Error)
    case contextSaveFailed(_ error: Error)
    
    // Create Operation Errors
    case imageQueryURLModelCreationFailed(_ error: Error)
    
    // Read Operation Errors
    case imageQueryURLModelsArrayFetchFailed(_ error: Error)
    
    // Update Operation Errors
    case imageQueryURLModelUpdateFailed(_ error: Error)
    
    // Delete Operation Errors
    case imageQueryURLModelDeletionFailed(_ error: Error)
    case eraseAllDataFailed(_ error: Error)
    
    var errorDescription: String? {
        switch self {
        case .modelContainerInitializationFailed(let error):
            return "Error: Failed to initialize model container. \(error.localizedDescription)"
        case .contextSaveFailed(let error):
            return "Error: Failed to save context to container. \(error.localizedDescription)"
            
            // Create Operation Errors
        case .imageQueryURLModelCreationFailed(let error):
            return "Error: Failed to create an image query url model. \(error.localizedDescription)"
            
            // Read Operation Errors
        case .imageQueryURLModelsArrayFetchFailed(let error):
            return "Error: Failed to fetch image query url model from context. \(error.localizedDescription)"
            
            // Update Operation Errors
        case .imageQueryURLModelUpdateFailed(let error):
            return "Error: Failed to update image query url model in context. \(error.localizedDescription)"
            
            // Delete Operation Errors
        case .imageQueryURLModelDeletionFailed(let error):
            return "Error: Failed to delete image query url model from context. \(error.localizedDescription)"
        case .eraseAllDataFailed(let error):
            return "Error: Failed to erase all data from image query url model container. \(error.localizedDescription)"
        }
    }
}
