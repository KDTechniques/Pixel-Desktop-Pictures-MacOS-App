//
//  UnsplashImageDirectoryModelProtocol.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-03.
//

import Foundation

protocol UnsplashImageDirectoryModelProtocol {
    // MARK: FUNCTIONS
    
    // MARK: - File URL
    /// Constructs a file URL with the specified file extension in the target directory.
    func fileURL(extension fileExtension: String) throws -> URL
    
    func deletePreviousDesktopPictures() throws
}
