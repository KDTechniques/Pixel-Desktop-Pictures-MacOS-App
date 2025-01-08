//
//  UserDefaultsManager.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-28.
//

import Foundation

actor UserDefaultsManager {
    // MARK: - PROPERTIES
    static let shared: UserDefaultsManager = .init()
    private let defaults = UserDefaults.standard
    
    // MARK: - INITIALIZER
    private init() {}
    
    // MARK: FUNCTIONS
    
    // MARK: - Save Value to User Defaults
    /// Saves a value to User Defaults under the specified key.
    ///
    /// - Parameters:
    ///   - key: A `UserDefaultKeys` enum value representing the key under which the value will be saved.
    ///   - value: The value to save to User Defaults.
    func save(key: UserDefaultKeys, value: Any) async {
        defaults.set(value, forKey: key.rawValue)
    }
    
    // MARK: - Get Value from User Defaults
    /// Retrieves a value from User Defaults for the specified key.
    ///
    /// - Parameter key: A `UserDefaultKeys` enum value representing the key for which the value will be retrieved.
    /// - Returns: An optional `Any` value retrieved from User Defaults, or `nil` if no value is found.
    func get(key: UserDefaultKeys) async -> Any? {
        return defaults.object(forKey: key.rawValue)
    }
    
    // MARK: - Save Model Object to User Defaults
    /// Encodes and saves a model object to User Defaults under the specified key.
    ///
    /// - Parameters:
    ///   - key: A `UserDefaultKeys` enum value representing the key under which the model will be saved.
    ///   - value: The model object to be encoded and saved.
    /// - Throws: An error if encoding the model or saving to User Defaults fails.
    func saveModel<T: Encodable>(key: UserDefaultKeys, value: T) async throws {
        let encoder = JSONEncoder()
        do {
            let encodedData: Data = try encoder.encode(value)
            await self.save(key: key, value: encodedData)
        } catch {
            print("Error: Saving `\(T.self)` object to user defaults.")
            throw error
        }
    }
    
    // MARK: - Get Model Object from User Defaults
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
        
        let decoder = JSONDecoder()
        do {
            let loadedModel: T = try decoder.decode(type, from: jsonData)
            return loadedModel
        } catch {
            print("Error: Retrieving `\(T.self)` object from user defaults.")
            throw error
        }
    }
    
    // MARK: - Clear All User Defaults
    /// Clears all values stored in User Defaults.
    static func clearAllUserDefaults() {
        let defaults = UserDefaults.standard
        for key in defaults.dictionaryRepresentation().keys {
            defaults.removeObject(forKey: key)
        }
    }
}
