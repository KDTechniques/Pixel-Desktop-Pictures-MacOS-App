//
//  QueryImageLocalDatabaseManagerErrors.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-11.
//

import Foundation

enum QueryImageLocalDatabaseManagerErrors: LocalizedError {
    // Create Operation Errors
    case failedToCreateQueryImages(_ error: Error)
    
    // Read Operation Errors
    case failedToFetchQueryImages(_ error: Error)
    
    // Update Operation Errors
    case failedToUpdateQueryImages(_ error: Error)
    
    var errorDescription: String? {
        switch self {
            // Create Operation Errors
        case .failedToCreateQueryImages(let error):
            return "❌: Failed to create query images. \(error.localizedDescription)"
            
            // Read Operation Errors
        case .failedToFetchQueryImages(let error):
            return "❌: Failed to fetch query images from context. \(error.localizedDescription)"
            
            // Update Operation Errors
        case .failedToUpdateQueryImages(let error):
            return "❌: Failed to update query images from context. \(error.localizedDescription)"
        }
    }
}
