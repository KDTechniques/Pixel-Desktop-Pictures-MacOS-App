//
//  APIAccessKeyManager_UserDefaults.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-10-01.
//

import Foundation

extension APIAccessKeyManager {
    /// Retrieves the API access key from UserDefaults.
    ///
    /// - Returns: The stored API access key or nil if not found.
    /// - Updates the access key status if no key is present.
    func getAPIAccessKeyFromUserDefaults() async -> String? {
        guard let apiAccessKey: String = await defaults.get(key: .apiAccessKey) as? String else {
            Logger.log(errorModel.apiAccessKeyNotFound.localizedDescription)
            return nil
        }
        
        Logger.log("✅: Returned API access key.")
        return apiAccessKey
    }
    
    /// Saves the API access key to UserDefaults.
    ///
    /// - Parameter key: The API access key to be stored.
    func saveAPIAccessKeyToUserDefaults(_ key: String) async {
        await defaults.save(key: .apiAccessKey, value: key)
        Logger.log("✅: Saved API access key to user defaults.")
    }
}
