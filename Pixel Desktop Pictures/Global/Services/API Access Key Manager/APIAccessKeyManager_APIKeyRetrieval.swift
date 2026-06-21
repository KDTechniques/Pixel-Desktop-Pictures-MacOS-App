//
//  APIAccessKeyManager_APIKeyRetrieval.swift
//  Pixel Desktop Pictures
//
//  Created by Mr. Kavinda Dilshan on 2026-06-21.
//

import Foundation

extension APIKeyManager {
    /// Retrieves the current API key.
    ///
    /// - Returns: The stored API key or nil if not found.
    /// - Fetches key from UserDefaults if not already in memory.
    func getAPIKey() -> String? {
        guard let apiKey else {
            guard let savedAPIKey: String = getAPIKeyFromUserDefaults() else {
                Logger.log(errorModel.apiKeyNotFound.localizedDescription)
                return nil
            }
            
            setAPIKey(savedAPIKey)
            return savedAPIKey
        }
        
        Logger.log("✅: Returned current API key.")
        return apiKey
    }
    
    func getNextAvailableAPIKey() -> String? {
        let limit = apiKeys.count
        
        // Filter the range to find numbers NOT in the set
        let availableIndexes: [Int] = (0..<limit).filter { !failedAPIKeyIndexes.contains($0) }
        
        // Safely grab a random element from the remaining choices
        guard let randomIndex: Int = availableIndexes.randomElement() else {
            // If available indexes are empty that means all the api keys have been failed.
            /// that means we have encountered the rate limited issue.
            return nil
        }
        
        Logger.log("✅: Returned the next available API key.")
        return apiKeys[randomIndex]
    }
}
