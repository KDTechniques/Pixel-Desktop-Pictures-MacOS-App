//
//  QueryImageLocalDatabaseManagerError.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-11.
//

import Foundation

enum QueryImageLocalDatabaseManagerError: LocalizedError {
    case failedToCreateQueryImages(_ error: Error)
    case failedToFetchQueryImages(_ error: Error)
    case failedToUpdateQueryImages(_ error: Error)
    
    var errorDescription: String? {
        switch self {
        case .failedToCreateQueryImages(let error):
            return "❌: Failed to create query images. \(error.localizedDescription)"
        case .failedToFetchQueryImages(let error):
            return "❌: Failed to fetch query images from context. \(error.localizedDescription)"
        case .failedToUpdateQueryImages(let error):
            return "❌: Failed to update query images from context. \(error.localizedDescription)"
        }
    }
}
