//
//  APIAccessKeyManagerErrorModel.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-16.
//

import Foundation

enum APIAccessKeyManagerErrorModel: LocalizedError {
    case apiAccessKeyNotFound
    case EmptyAPIAccessKey
    case apiAccessKeyCheckupFailed
    case apiAccessKeyStatusNotFound
    
    var errorDescription: String? {
        switch self {
        case .apiAccessKeyNotFound:
            return "Error: Failed to find api access key from user defaults."
        case .EmptyAPIAccessKey:
            return "Error: The passed API access key is empty."
        case .apiAccessKeyCheckupFailed:
            return "Error: Failed to perform an api access key checkup."
        case .apiAccessKeyStatusNotFound:
            return "Error: Failed to find api access key status from user defaults."
        }
    }
}
