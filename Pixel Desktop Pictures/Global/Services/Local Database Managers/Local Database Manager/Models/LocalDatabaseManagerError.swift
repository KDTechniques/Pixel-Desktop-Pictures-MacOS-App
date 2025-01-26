//
//  LocalDatabaseManagerError.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-11.
//

import Foundation

enum LocalDatabaseManagerError: LocalizedError {
    case failedToInitializeModelContainer(_ error: Error)
    case failedToSaveContext(_ error: Error)
    case failedToEraseAllData(_ error: Error)
    
    var errorDescription: String? {
        switch self {
        case .failedToInitializeModelContainer(let error):
            return "❌: Failed to initialize model container. \(error.localizedDescription)"
        case .failedToSaveContext(let error):
            return "❌: Failed to save context to container. \(error.localizedDescription)"
        case .failedToEraseAllData(let error):
            return "❌: Failed to erase all data for query images from model container. \(error.localizedDescription)"
        }
    }
}
