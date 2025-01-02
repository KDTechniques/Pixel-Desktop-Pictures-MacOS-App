//
//  UnsplashImageDirectoryModelErrorModel.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-02.
//

import Foundation

enum UnsplashImageDirectoryModelErrorModel: LocalizedError {
    case unableToReadDirectoryPath(directory: FileManager.SearchPathDirectory)
    case fileURLConstructionFailed(directory: FileManager.SearchPathDirectory, error: Error)
    
    var errorDescription: String? {
        switch self {
        case .unableToReadDirectoryPath(let directory):
            return "Error: Creating directory at \(directory)."
        case .fileURLConstructionFailed(let directory, let error):
            return "Error: Constructing file url at \(directory). \(error.localizedDescription)"
        }
    }
}
