//
//  UserDefaultsManager.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-28.
//

import Foundation

/**
 A thread-safe actor responsible for managing User Defaults operations.
 It provides methods for saving, retrieving, and clearing data in User Defaults, as well as encoding and decoding model objects.
 This actor ensures that all operations are performed in a thread-safe manner, leveraging Swift's concurrency model.
 */
actor UserDefaultsManager {
    // MARK: - SINGLETON
    static let shared: UserDefaultsManager = .init()
    
    // MARK: - INITIALIZER
    private init() {}
    
    // MARK: - ASSIGNED PROPERTIES
    private let defaults = UserDefaults.standard
    
    // MARK: - INTERNAL FUNCTIONS
    
    /// Saves a value to User Defaults under the specified key.
    ///
    /// - Parameters:
    ///   - key: A `UserDefaultKeys` enum value representing the key under which the value will be saved.
    ///   - value: The value to save to User Defaults.
    func save(key: UserDefaultKeys, value: Any) async {
        defaults.set(value, forKey: key.rawValue)
    }
    
    /// Retrieves a value from User Defaults for the specified key.
    ///
    /// - Parameter key: A `UserDefaultKeys` enum value representing the key for which the value will be retrieved.
    /// - Returns: An optional `Any` value retrieved from User Defaults, or `nil` if no value is found.
    func get(key: UserDefaultKeys) async -> Any? {
        return defaults.object(forKey: key.rawValue)
    }
    
    /// Encodes and saves a model object to User Defaults under the specified key.
    ///
    /// - Parameters:
    ///   - key: A `UserDefaultKeys` enum value representing the key under which the model will be saved.
    ///   - value: The model object to be encoded and saved.
    /// - Throws: An error if encoding the model or saving to User Defaults fails.
    func saveModel<T: Encodable>(key: UserDefaultKeys, value: T) async throws {
        do {
            let encodedData: Data = try JSONEncoder().encode(value)
            await self.save(key: key, value: encodedData)
        } catch {
            Logger.log("❌: Saving `\(T.self)` object to user defaults.")
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
    func getModel<T: Decodable>(key: UserDefaultKeys, type: T.Type) async throws -> T? {
        guard let jsonData: Data = await self.get(key: key) as? Data else {
            return nil
        }
        
        do {
            let loadedModel: T = try JSONDecoder().decode(type, from: jsonData)
            return loadedModel
        } catch {
            Logger.log("❌: Retrieving `\(T.self)` object from user defaults.")
            throw error
        }
    }
    
    /// Clears all values stored in User Defaults.
    static func clearAllUserDefaults() {
        let defaults = UserDefaults.standard
        for key in defaults.dictionaryRepresentation().keys {
            defaults.removeObject(forKey: key)
        }
    }
}
