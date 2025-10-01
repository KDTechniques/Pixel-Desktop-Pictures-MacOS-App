//
//  DirectoryTypes.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-10-01.
//

import Foundation

enum DirectoryTypes {
    case downloads(_ environment:  AppEnvironment)
    case documents(_ environment:  AppEnvironment)
    
    var directory: UnsplashImageDirectoryProtocol  {
        switch self {
        case .downloads(let environment):
            return environment == .production
            ? UnsplashImageDirectory.downloadsDirectory
            : MockUnsplashImageDirectory.downloadsDirectory
            
        case .documents(let environment):
            return environment == .production
            ? UnsplashImageDirectory.documentsDirectory
            : MockUnsplashImageDirectory.documentsDirectory
        }
    }
}
