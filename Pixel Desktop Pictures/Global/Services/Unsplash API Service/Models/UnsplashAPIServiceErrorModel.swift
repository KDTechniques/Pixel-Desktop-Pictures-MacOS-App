//
//  UnsplashAPIServiceErrorModel.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-03.
//

import Foundation

enum UnsplashAPIServiceErrorModel: LocalizedError {
    case apiAccessKeyValidationFailed(_ error: Error)
    case randomImageModelFetchFailed(_ error: Error)
    case queryImageModelFetchFailed(_ error: Error)
    
    var errorDescription: String? {
        switch self {
        case .apiAccessKeyValidationFailed(let error):
            return "Error: Validating api access key. \(error.localizedDescription)"
        case .randomImageModelFetchFailed(let error):
            return "Error: Failed to fetch a random image model. \(error.localizedDescription)"
        case .queryImageModelFetchFailed(let error):
            return "Error: Failed to fetch a query image model. \(error.localizedDescription)"
        }
    }
}
