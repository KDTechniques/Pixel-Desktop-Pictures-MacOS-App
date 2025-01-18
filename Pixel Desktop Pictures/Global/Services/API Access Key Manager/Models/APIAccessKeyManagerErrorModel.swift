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
            return "❌: Failed to find api access key from user defaults."
        case .EmptyAPIAccessKey:
            return "❌: The passed API access key is empty."
        case .apiAccessKeyCheckupFailed:
            return "❌: Failed to perform an api access key checkup."
        case .apiAccessKeyStatusNotFound:
            return "❌: Failed to find api access key status from user defaults."
        }
    }
}
