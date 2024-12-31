//
//  JSONFileStorageManagerProtocol.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-28.
//

import Foundation

protocol JSONFileStorageManagerProtocol {
    // MARK: FUNCTIONS
    
    // MARK: - Save URLs to a JSON File
    /// Saves a set of URLs to a JSON file at a specific location.
    /// if `loadURL` function returns an empty array, fetch more url from the image api service and save them to a json file by this function.
    func saveURLs(on urlFileType: ImageURLsJSONFileTypes, for queryText: String, urls: Set<String>) async throws
    
    // MARK: - Load URLs from a JSON File
    /// Loads a set of URLs from a JSON file.
    ///
    ///  So, it helps reading file overhead all the time for each url.
    func loadURLs(on urlFileType: ImageURLsJSONFileTypes, for queryText: String) async throws -> Set<String>
}
