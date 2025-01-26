//
//  ImageDownloadManager.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-28.
//

import Foundation

/**
 The `ImageDownloadManager` actor is responsible for downloading images from a given URL and saving them to a specified directory. This class ensures that the image download process is thread-safe and efficient by using the actor model.
 */
actor ImageDownloadManager {
    // MARK: - SINGLETON
    static let shared: ImageDownloadManager = .init()
    
    // MARK: - INITIALIZER
    private init() {}
    
    // MARK: - INTERNAL FUNCTIONS
    
    /// Downloads an image from a given URL and saves it to the specified directory.
    ///
    /// - Parameters:
    ///   - url: A string representing the URL of the image to be downloaded.
    ///   - directory: An enum representing the target directory (`downloadsDirectory` or `documentsDirectory`) where the image will be saved.
    ///
    /// - Throws: `URLError`: If the URL string is invalid or there are issues during the network request or response handling.
    /// `UnsplashImageDirectoryModelError`: If there is an issue with constructing the file URL or saving the image to the directory.
    ///
    /// - Returns:
    ///   A `URL` object representing the location where the image file has been saved.
    func downloadImage(url: String, to directory: UnsplashImageDirectoryProtocol) async throws -> String {
        // Safe Unwrapping of URL String to URL
        guard let url: URL = URL(string: url) else {
            throw URLError(.badURL)
        }
        
        // Download Data via URL Session
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Determine the File Extension from the Response MIME Type
        guard let httpResponse: HTTPURLResponse = response as? HTTPURLResponse,
              let mimeType: String = httpResponse.value(forHTTPHeaderField: "Content-Type") else {
            throw URLError(.badServerResponse)
        }
        
        // Map MIME Type to File Extension
        let fileExtension: String = Utilities.mimeTypeToFileExtension(mimeType)
        
        // Create File Path in the Desired Directory
        let fileURL: URL = try directory.fileURL(extension: fileExtension)
        
        try directory.deletePreviousDesktopPictures()
        
        // Save the File in the Desired Directory Path
        try data.write(to: fileURL)
        
        Logger.log("✅: Image file has been downloaded to \(fileURL.path()), and returned.")
        return fileURL.absoluteString
    }
}
