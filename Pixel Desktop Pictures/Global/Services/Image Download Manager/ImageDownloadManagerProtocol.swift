//
//  ImageDownloadManagerProtocol.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-28.
//

import Foundation

protocol ImageDownloadManagerProtocol {
    // MARK: FUNCTIONS
    
    // MARK: - Download
    func downloadImage(_ url: URL) async throws -> URL
    
    // MARK: - File Storage
    func createDocumentsDirectoryIfNeeded() async throws -> URL
    func getDocumentDirectoryImageURL() async throws -> URL
}
