//
//  UnsplashImageDirectoryProtocol.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-03.
//

import Foundation

/// A protocol defining the requirements for managing Unsplash image directories.
protocol UnsplashImageDirectoryProtocol {
    /// Constructs a file URL with the specified file extension in the target directory.
    /// - Parameter fileExtension: The file extension to append to the file name.
    /// - Throws: An error if the file URL construction fails.
    /// - Returns: The full file URL including the extension.
    func fileURL(extension fileExtension: String) throws -> URL
    
    /// Deletes all previous desktop pictures in the target directory.
    /// - Throws: An error if the deletion process fails.
    func deletePreviousDesktopPictures() throws
}
