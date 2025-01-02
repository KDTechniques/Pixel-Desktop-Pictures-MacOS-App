//
//  ImageDownloadManager.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-28.
//

import Foundation

actor ImageDownloadManager {
    // MARK: FUNCTIONS
    
    // MARK: - Download Image
    func downloadImage(url: String, to directory: UnsplashImageDirectoryModel) async throws -> URL {
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
        
        // Save the File in the Desired Directory Path
        try data.write(to: fileURL)
        
        print("Image file is successfully downloaded to \(fileURL.path())")
        return fileURL
    }
}
