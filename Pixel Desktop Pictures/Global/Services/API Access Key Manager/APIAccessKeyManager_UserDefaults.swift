//
//  APIKeyManager_UserDefaults.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-10-01.
//

import Foundation

extension APIKeyManager {
    /// Retrieves the API key from UserDefaults.
    ///
    /// - Returns: The stored API key or nil if not found.
    /// - Updates the key status if no key is present.
    func getAPIKeyFromUserDefaults() -> String? {
        guard let apiKey: String = defaults.get(key: .apiKey) as? String else {
            Logger.log(errorModel.apiKeyNotFound.localizedDescription)
            return nil
        }
        
        Logger.log("✅: Returned API key from user defaults.")
        return apiKey
    }
    
    /// Saves the API key to UserDefaults.
    ///
    /// - Parameter key: The API key to be stored.
    func saveAPIKeyToUserDefaults(_ key: String) {
        defaults.save(key: .apiKey, value: key)
        Logger.log("✅: Saved API key to user defaults.")
    }
}
