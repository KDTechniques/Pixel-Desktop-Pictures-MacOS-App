//
//  UnsplashImageDirectoryModelError.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-02.
//

import Foundation

enum UnsplashImageDirectoryModelError: LocalizedError {
    case unableToReadDirectoryPath(directory: FileManager.SearchPathDirectory)
    case fileURLConstructionFailed(directory: FileManager.SearchPathDirectory, error: Error)
    
    var errorDescription: String? {
        switch self {
        case .unableToReadDirectoryPath(let directory):
            return "❌: Creating directory at \(directory)."
        case .fileURLConstructionFailed(let directory, let error):
            return "❌: Constructing file url at \(directory). \(error.localizedDescription)"
        }
    }
}
