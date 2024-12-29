//
//  JSONFileStorageManager.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-28.
//

import Foundation

actor JSONFileStorageManager {
    // MARK: - PROPERTIES
    let fileManager: FileManager = .default
    
    // MARK: FUNCTIONS
    
    // MARK: INTERNAL FUNCTIONS
    
    // MARK: - Write Data
    func saveURLs(_ urlFileType: ImageURLsJSONFileTypes, _ queryText: String, _ urls: Set<String>) async throws {
        
        
        
        
        guard let fileURL = try? await getJSONFileURL(on: urlFileType, for: queryText) else {
            throw NSError(domain: "FileStorage", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to get file URL"])
        }
        let jsonData = try JSONSerialization.data(withJSONObject: Array(urls), options: .prettyPrinted)
        try jsonData.write(to: fileURL)
    }
    
    // MARK: - Read Data
    func loadURLs(_ urlFileType: ImageURLsJSONFileTypes, _ queryText: String) async throws -> Set<String> {
        guard let fileURL = try? await getJSONFileURL(on: urlFileType, for: queryText),
              FileManager.default.fileExists(atPath: fileURL.path) else {
            return [] // Return an empty Set if the file doesn't exist
        }
        let jsonData = try Data(contentsOf: fileURL)
        if let urls = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String] {
            return Set(urls)
        } else {
            throw NSError(domain: "FileStorage", code: 2, userInfo: [NSLocalizedDescriptionKey: "Invalid data format"])
        }
    }
    
    // MARK: PRIVATE FUNCTIONS
    
    // MARK: - Get JSON File URL in Document Directory
    /// Retrieves the URL for a JSON file based on the provided type and query text.
    ///
    /// This function constructs a URL pointing to a JSON file stored in the user's document directory.
    /// The type of the URL file is determined by the `urlFileType` parameter, which specifies the subdirectory
    /// and filename format. The `queryText` parameter is used to generate the specific filename within the directory.
    ///
    /// Example 1: UnsplashPreSavedImageURLs/Nature.json
    /// - "https://www.example.com/Nature/image5"  ---> (Nature / image5)
    /// - "https://www.example.com/Nature/image6"  ---> (Nature / image6)
    /// - "https://www.example.com/Nature/image7"  ---> (Nature / image7)
    ///
    /// Example 2: UnsplashQueryURLs/Nature.json
    /// - "https://api.unsplash.com/search/photos?orientation=landscape&page=3&per_page=10&query=Nature"  ---> (page=4), (query=Nature)
    /// - "https://api.unsplash.com/search/photos?orientation=landscape&page=4&per_page=10&query=Nature"  ---> (page=5), (query=Nature)
    ///
    /// - Parameters:
    ///    - urlFileType: An `ImageURLsJSONFileTypes` enum value that determines the subdirectory and filename format
    ///      for the JSON file.
    ///    - queryText: A `String` representing the query text used to generate the filename within the specified subdirectory.
    ///
    /// - Throws: `JSONFileStorageManagerError.JSONFileURLConstructionFailed` if the URL construction fails.
    ///
    /// - Returns: A `URL` pointing to the specified JSON file in the document directory.
    private func getJSONFileURL(on urlFileType: ImageURLsJSONFileTypes, for queryText: String) async throws -> URL {
        guard let url: URL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent(urlFileType.fileName(queryText)) else {
            throw JSONFileStorageManagerError.JSONFileURLConstructionFailed
        }
        
        return url
    }
    
}

// add the following model to the models folder later
enum JSONFileStorageManagerError: Error, LocalizedError {
    case JSONFileURLConstructionFailed
    
    var errorDescription: String? {
        switch self {
        case .JSONFileURLConstructionFailed:
            return "Error: Failed to construct requested JSON file URL in the document directory.)"
        }
    }
}


/*
 enum UtilityErrorModel: Error, LocalizedError {
 case userDefaultsEncodingFailed(object: String?, key: String?, error: Error?)
 
 var errorDescription: String? {
 switch self {
 case .userDefaultsEncodingFailed(let object, let key, let error):
 return "Error: Failed to save object(\(object ?? "Unknown")) to User Defaults key(\(key ?? "Unknown")) during encoding. \(error?.localizedDescription ?? "No further details available.")"
 }
 }
 }
 
 */
