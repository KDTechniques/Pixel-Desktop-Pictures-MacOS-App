//
//  MockJSONFileStorageManager.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-28.
//

import Foundation

actor MockJSONFileStorageManager: JSONFileStorageManagerProtocol {
    // Mock Properties
    var savedURLs: [String: Set<String>] = [:]
    var isFileSavedSuccessfully: Bool = true
    var isFileLoadedSuccessfully: Bool = true
    
    // MARK: - Mocked Methods
    
    // Mock Save URLs
    func saveURLs(on urlFileType: ImageURLsJSONFileTypes, for queryText: String, urls: Set<String>) async throws {
        // Simulate saving URLs by storing them in a dictionary
        if isFileSavedSuccessfully {
            savedURLs[urlFileType.fileName(queryText)] = urls
            print("Mock: Successfully saved URLs for \(queryText) at \(urlFileType.fileName(queryText))")
        } else {
            let error = NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to save URLs"])
            throw JSONFileStorageManagerError.JSONFileSavingFailed(error: error)
        }
    }
    
    // Mock Load URLs
    func loadURLs(on urlFileType: ImageURLsJSONFileTypes, for queryText: String) async throws -> Set<String> {
        // Simulate loading URLs by fetching from the mock storage
        if isFileLoadedSuccessfully {
            return savedURLs[urlFileType.fileName(queryText)] ?? Set<String>()
        } else {
            let error = NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Failed to load URLs"])
            throw JSONFileStorageManagerError.JSONFileLoadingFailed(error: error)
        }
    }
    
    // Mock Get Document Directory URL for a JSON File
    private func getJSONFileURL(on urlFileType: ImageURLsJSONFileTypes, for queryText: String) async throws -> URL {
        // Simulate returning a mock URL instead of accessing the real file system
        guard let url = URL(string: "file:///mock/path/\(urlFileType.fileName(queryText))") else {
            throw JSONFileStorageManagerError.JSONFileURLConstructionFailed
        }
        return url
    }
    
    // Utility method to reset the mock
    func reset() {
        savedURLs.removeAll()
    }
}
