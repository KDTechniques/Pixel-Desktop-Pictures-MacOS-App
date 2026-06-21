//
//  APIKeyManagerErrorModel.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-16.
//

import Foundation

enum APIKeyManagerErrorModel: LocalizedError {
    case apiKeyNotFound
    case apiKeyValidationFailed(_ error: Error)
    case allRateLimited
    case invalidAPIKey
    case rateLimitedAPIKey
    case failureDetected
    case timeout
    
    var errorDescription: String? {
        switch self {
        case .apiKeyNotFound:
            return "⚠️: Failed to find api key from user defaults."
            
        case .apiKeyValidationFailed(let error):
            return "❌: Failed to validate API key. \(error.localizedDescription)"
            
        case .allRateLimited:
            return "❌: All rate limits have been hit."
            
        case .invalidAPIKey:
            return "⚠️: Invalid API key."
            
        case .rateLimitedAPIKey:
            return "⚠️: Rate limited API key."
            
        case .failureDetected:
            return "⚠️: API key failure detected."
            
        case .timeout:
            return "⚠️: API key validation request timed out."
        }
    }
}
