//
//  DirectoryTypes.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-10-01.
//

import Foundation

enum DirectoryTypes {
    case downloads
    case documents
    
    var directory: UnsplashImageDirectoryProtocol  {
        switch self {
        case .downloads:
            return appEnvironment == .production
            ? UnsplashImageDirectory.downloadsDirectory
            : MockUnsplashImageDirectory.downloadsDirectory
            
        case .documents:
            return appEnvironment == .production
            ? UnsplashImageDirectory.documentsDirectory
            : MockUnsplashImageDirectory.documentsDirectory
        }
    }
}
