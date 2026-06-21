//
//  UnsplashImageAPIServiceErrorModel.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-03.
//

import Foundation

enum UnsplashImageAPIServiceErrorModel: LocalizedError {
    case failedToFetchAPIKey(_ error: Error)
    case failedToFetchRandomImage(_ error: Error)
    case failedToFetchQueryImages(_ error: Error)
    
    var errorDescription: String? {
        switch self {
        case .failedToFetchAPIKey(let error):
            return "❌: Validating api key. \(error.localizedDescription)"
        case .failedToFetchRandomImage(let error):
            return "❌: Failed to fetch a random image. \(error.localizedDescription)"
        case .failedToFetchQueryImages(let error):
            return "❌: Failed to fetch a query images. \(error.localizedDescription)"
        }
    }
}
