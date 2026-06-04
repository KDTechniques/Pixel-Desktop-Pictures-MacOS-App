//
//  APIKeyManagerErrorModel.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-16.
//

import Foundation

enum APIKeyManagerErrorModel: LocalizedError {
    case apiKeyNotFound
    case apiKeyCheckupFailed
    case apiKeyValidationFailed(_ error: Error)
    
    var errorDescription: String? {
        switch self {
        case .apiKeyNotFound:
            return "❌: Failed to find api key from user defaults."
            
        case .apiKeyCheckupFailed:
            return "❌: Failed to perform an API key checkup."
            
        case .apiKeyValidationFailed(let error):
            return "❌: Failed to validate API key. \(error.localizedDescription)"
        }
    }
}
