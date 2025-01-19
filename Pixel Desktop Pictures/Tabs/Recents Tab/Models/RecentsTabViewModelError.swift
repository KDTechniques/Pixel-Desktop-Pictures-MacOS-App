//
//  RecentsTabViewModelError.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-19.
//

import Foundation

enum RecentsTabViewModelError: LocalizedError {
    case initializationFailed(_ error: Error)
    case failedToAddRecentsArray(_ error: Error)
    case failedToValidateExceededRecentItems(_ error: Error)
    
    var errorDescription: String? {
        switch self {
        case .initializationFailed(let error):
            return "❌: Failed to initialize `Recents Tab View Model`. \(error.localizedDescription)"
        case .failedToAddRecentsArray(let error):
            return "❌: Failed to add recent item to both recents array, and local database. \(error.localizedDescription)"
        case .failedToValidateExceededRecentItems(let error):
            return "❌: Failed to append, insert, remove, and delete exceeded items through the local database. \(error.localizedDescription)"
        }
    }
}
