//
//  UserDefaultsManager.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-28.
//

import Foundation

/**
 A lightweight helper for managing User Defaults operations.
 Provides methods for saving, retrieving, and clearing data in User Defaults,
 as well as encoding and decoding model objects.
 */
struct UserDefaultsManager {
    // MARK: - ASSIGNED PROPERTIES
    private let defaults = UserDefaults.standard
    
    // MARK: - INTERNAL FUNCTIONS
    
    /// Saves a value to User Defaults under the specified key.
    ///
    /// - Parameters:
    ///   - key: A `UserDefaultKeys` enum value representing the key under which the value will be saved.
    ///   - value: The value to save to User Defaults.
    func save(key: UserDefaultKeys, value: Any) {
        defaults.set(value, forKey: key.rawValue)
    }
    
    /// Retrieves a value from User Defaults for the specified key.
    ///
    /// - Parameter key: A `UserDefaultKeys` enum value representing the key for which the value will be retrieved.
    /// - Returns: An optional `Any` value retrieved from User Defaults, or `nil` if no value is found.
    func get(key: UserDefaultKeys) -> Any? {
        return defaults.object(forKey: key.rawValue)
    }
    
    /// Encodes and saves a model object to User Defaults under the specified key.
    ///
    /// - Parameters:
    ///   - key: A `UserDefaultKeys` enum value representing the key under which the model will be saved.
    ///   - value: The model object to be encoded and saved.
    /// - Throws: An error if encoding the model or saving to User Defaults fails.
    func saveModel<T: Encodable>(key: UserDefaultKeys, value: T) throws {
        do {
            let encodedData: Data = try JSONEncoder().encode(value)
            self.save(key: key, value: encodedData)
        } catch {
            Logger.log("❌: Error saving `\(T.self)` object to user defaults.")
            throw error
        }
    }
    
    /// Retrieves and decodes a model object from User Defaults for the specified key.
    ///
    /// - Parameters:
    ///   - key: A `UserDefaultKeys` enum value representing the key for which the model will be retrieved.
    ///   - type: The type of the model object to be retrieved and decoded.
    /// - Returns: An optional decoded model object of the specified type, or `nil` if no value is found.
    /// - Throws: An error if decoding the model fails.
    func getModel<T: Decodable>(key: UserDefaultKeys, type: T.Type) throws -> T? {
        guard let jsonData: Data = self.get(key: key) as? Data else {
            return nil
        }
        
        do {
            let loadedModel: T = try JSONDecoder().decode(type, from: jsonData)
            return loadedModel
        } catch {
            Logger.log("❌: Error retrieving `\(T.self)` object from user defaults.")
            throw error
        }
    }
    
    /// Clears all values stored in User Defaults.
    static func clearAllUserDefaults() {
        guard let bundleID = Bundle.main.bundleIdentifier else { return }
        UserDefaults.standard.removePersistentDomain(forName: bundleID)
    }
}
