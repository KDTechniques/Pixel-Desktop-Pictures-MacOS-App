//
//  RecentLocalDatabaseManagerError.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-19.
//

import Foundation

enum RecentLocalDatabaseManagerError: LocalizedError {
    case failedToCreateRecent(_ error: Error)
    case failedToFetchRecents(_ error: Error)
    case failedToUpdateRecents(_ error: Error)
    case failedToDeleteRecent(_ error: Error)
    
    var errorDescription: String? {
        switch self {
        case .failedToCreateRecent(let error):
            return "❌: Failed to create recent. \(error.localizedDescription)"
        case .failedToFetchRecents(let error):
            return "❌: Failed to fetch recents from context. \(error.localizedDescription)"
        case .failedToUpdateRecents(let error):
            return "❌: Failed to update recents in context. \(error.localizedDescription)"
        case .failedToDeleteRecent(let error):
            return "❌: Failed to delete recent from context. \(error.localizedDescription)"
        }
    }
}
