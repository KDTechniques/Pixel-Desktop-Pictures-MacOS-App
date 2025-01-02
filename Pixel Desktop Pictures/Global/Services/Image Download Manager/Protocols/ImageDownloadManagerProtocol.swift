//
//  ImageDownloadManagerProtocol.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-28.
//

import Foundation

protocol ImageDownloadManagerProtocol {
    // MARK: FUNCTIONS
    
    // MARK: - Download Image
    /// Downloads an image from a given URL and saves it to the specified directory.
    func downloadImage(url: String, to directory: UnsplashImageDirectoryModel) async throws -> URL
}
