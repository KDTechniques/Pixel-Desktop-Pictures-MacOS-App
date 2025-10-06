//
//  APIAccessKeyManagerError.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-16.
//

import Foundation

enum APIAccessKeyManagerError: LocalizedError {
    case apiAccessKeyNotFound
    case EmptyAPIAccessKey
    case apiAccessKeyCheckupFailed
    case apiAccessKeyValidationFailed(_ error: Error)
    
    var errorDescription: String? {
        switch self {
        case .apiAccessKeyNotFound:
            return "❌: Failed to find api access key from user defaults."
            
        case .EmptyAPIAccessKey:
            return "❌: The passed API access key is empty."
            
        case .apiAccessKeyCheckupFailed:
            return "❌: Failed to perform an API access key checkup."
            
        case .apiAccessKeyValidationFailed(let error):
            return "❌: Failed to validate API access key. \(error.localizedDescription)"
        }
    }
}
