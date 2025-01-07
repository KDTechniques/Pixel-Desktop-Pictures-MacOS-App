//
//  UserDefaultsManager.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-28.
//

import Foundation

actor UserDefaultsManager {
    // MARK: - PROPERTIES
    private let defaults = UserDefaults.standard
    
    // MARK: FUNCTIONS
    
    // MARK: - Save Value to User Defaults
    func save(key: UserDefaultKeys, value: Any) async {
        defaults.set(value, forKey: key.rawValue)
    }
    
    // MARK: - Get Value from User Defaults
    func get(key: UserDefaultKeys) async -> Any? {
        return defaults.object(forKey: key.rawValue)
    }
    
    // MARK: - Save Model Object to User Defaults
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
    static func clearAllUserDefaults() {
        let defaults = UserDefaults.standard
        for key in defaults.dictionaryRepresentation().keys {
            defaults.removeObject(forKey: key)
        }
    }
}
