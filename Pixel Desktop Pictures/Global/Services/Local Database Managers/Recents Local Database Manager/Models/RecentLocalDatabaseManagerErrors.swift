//
//  RecentLocalDatabaseManagerErrors.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-19.
//

import Foundation

enum RecentLocalDatabaseManagerErrors: LocalizedError {
    // Create Operation Errors
    case failedToCreateRecent(_ error: Error)
    
    // Read Operation Errors
    case failedToFetchRecents(_ error: Error)
    
    // Delete Operation Errors
    case failedToDeleteRecent(_ error: Error)
    
    var errorDescription: String? {
        switch self {
            // Create Operation Errors
        case .failedToCreateRecent(let error):
            return "❌: Failed to create recent. \(error.localizedDescription)"
            
            // Read Operation Errors
        case .failedToFetchRecents(let error):
            return "❌: Failed to fetch recents from context. \(error.localizedDescription)"
            
            // Delete Operation Errors
        case .failedToDeleteRecent(let error):
            return "❌: Failed to delete recent from context. \(error.localizedDescription)"
        }
    }
}
