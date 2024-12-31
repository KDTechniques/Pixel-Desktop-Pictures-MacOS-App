//
//  JSONFileStorageManager.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-28.
//

import Foundation

actor JSONFileStorageManager: JSONFileStorageManagerProtocol {
    // MARK: - PROPERTIES
    let fileManager: FileManager = .default
    
    // MARK: FUNCTIONS
    
    // MARK: INTERNAL FUNCTIONS
    
    // MARK: - Write Data to a JSON File
    /// Saves a set of URLs to a JSON file in the document directory.
    ///
    /// This function converts the given set of URLs to an array and serializes them into JSON format using pretty printing.
    /// The resulting JSON data is then written to a file at the specified location in the document directory.
    ///
    /// - Parameters:
    ///   - urlFileType: The type of file to save the URLs in, represented by an `ImageURLsJSONFileTypes` object.
    ///   - queryText: A query string used to help identify the file name for saving the JSON data.
    ///   - urls: A set of URLs to be saved as JSON data. The set is converted to an array before serialization.
    ///
    /// - Throws:
    ///   - `JSONFileStorageManagerError.JSONFileSavingFailed`: If an error occurs during the file creation, data serialization, or file writing process. The underlying error is provided for debugging purposes.
    ///
    /// - Example - ``Unsplash Pre Saved Image URLs``:
    ///   ```swift
    ///    let urls: Set<String> = [
    ///        "https://www.example.com/Nature/image5",
    ///        "https://www.example.com/Nature/image6"
    ///    ]
    ///    try await saveURLs(on: .preSavedImageURLs, for: "Nature", urls: urls)
    ///   ```
    /// - Example - ``Unsplash Query URLs``:
    ///   ```swift
    ///    let urls: Set<String> = [
    ///        "https://api.unsplash.com/search/photos?orientation=landscape&page=3&per_page=10&query=Nature",
    ///        "https://api.unsplash.com/search/photos?orientation=landscape&page=3&per_page=10&query=Nature"
    ///    ]
    ///    try await saveURLs(on: .queryURLs, for: "Nature", urls: urls)
    ///   ```
    func saveURLs(on urlFileType: ImageURLsJSONFileTypes, for queryText: String, urls: Set<String>) async throws {
        do {
            // Converting the Set of URLs to an Array of URLs for the Sake of JSON Serialization
            let urlsArray: [String] = Array(urls)
            
            // Construct Data with the Given URLs in Pretty Printed Format Via JSON Serialization
            let jsonData: Data = try JSONSerialization.data(withJSONObject: urlsArray, options: .prettyPrinted)
            
            // Get the URL from the Document Directory for the Desired JSON File
            let jsonFileURL: URL = try await getJSONFileURL(on: urlFileType, for: queryText)
            
            print("Saving URL JSON data to file at \(jsonFileURL)")
            
            // Write JSON Data to the JSON File in the Document Directory
            try jsonData.write(to: jsonFileURL)
        } catch {
            print("Error: Saving \(urlFileType.type) to \(urlFileType.fileName(queryText)) file. \(error.localizedDescription)")
            throw JSONFileStorageManagerError.JSONFileSavingFailed(error: error)
        }
    }
    
    // MARK: - Read Data from a JSON File
    /// Loads a set of URLs from a JSON file in the document directory.
    ///
    /// - Parameters:
    ///   - urlFileType: The type of file to load the URLs from, represented by an `ImageURLsJSONFileTypes` object.
    ///   - queryText: A query string used to help identify the file name from which to load the URLs.
    /// - Returns: A set of URLs as `Set<String>`. If the file does not exist or fails to load, an empty set is returned.
    /// - Throws:
    ///   - `JSONFileStorageManagerError.JSONFileLoadingFailed`: If there is an error loading or parsing the JSON data from the file.
    ///
    /// - Example - ``Unsplash Pre Saved Image URLs``:
    ///   ```swift
    ///    let preSavedImageURLsSet: Set<String> = try await loadURLs(on: .preSavedImageURLs, for: "Nature")
    ///    // Output: ["https://www.example.com/Nature/image5", "https://www.example.com/Nature/image6"]
    ///   ```
    /// - Example - ``Unsplash Query URLs``:
    ///   ```swift
    ///    let queryURLsSet: Set<String> = try await loadURLs(on: .queryURLs, for: "Nature")
    ///    // Output: ["https://api.unsplash.com/search/photos?orientation=landscape&page=3&per_page=10&query=Nature",...]
    ///   ```
    func loadURLs(on urlFileType: ImageURLsJSONFileTypes, for queryText: String) async throws -> Set<String> {
        var tempURLs: Set<String> = []
        do {
            // Get the URL from the Document Directory for the Desired JSON File
            let fileURL: URL = try await getJSONFileURL(on: urlFileType, for: queryText)
            
            // Check Whether the File Exists or Not in the Document Directory
            /// This check helps to prevent errors when attempting to read from a non-existent file.
            guard fileManager.fileExists(atPath: fileURL.path) else {
                return Set<String>() // Return an empty Set if the file doesn't exist
            }
            
            // Read File and Convert to JSON Data
            let jsonData: Data = try Data(contentsOf: fileURL)
            
            // Check If the File is Empty Before Parsing
            /// This check ensures that an empty file does not cause an error during parsing.
            guard !jsonData.isEmpty else {
                return Set<String>() // Return an empty Set if the file is empty
            }
            
            // Casting JSON Data into an Array of URL Strings
            guard let urls: [String] = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String] else {
                print(JSONFileStorageManagerError.JSONDataToStringArrayCastingFailed.errorDescription ?? "Unknown Error")
                throw JSONFileStorageManagerError.JSONDataToStringArrayCastingFailed
            }
            
            // Convert and Assign Array of URL Strings to a Set of URL Strings
            tempURLs = Set(urls)
        } catch {
            print("Error: Loading \(urlFileType.type) from \(urlFileType.fileName(queryText)) file. \(error.localizedDescription)")
            throw JSONFileStorageManagerError.JSONFileLoadingFailed(error: error)
        }
        
        // Return Either an Empty Set or Set of URL Strings
        return tempURLs
    }
    
    // MARK: PRIVATE FUNCTIONS
    
    // MARK: - Get Document Directory URL for a JSON File
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
    /// - "https://api.unsplash.com/search/photos?orientation=landscape&page=3&per_page=10&query=Nature"  ---> (page=3), (query=Nature)
    /// - "https://api.unsplash.com/search/photos?orientation=landscape&page=4&per_page=10&query=Nature"  ---> (page=4), (query=Nature)
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
