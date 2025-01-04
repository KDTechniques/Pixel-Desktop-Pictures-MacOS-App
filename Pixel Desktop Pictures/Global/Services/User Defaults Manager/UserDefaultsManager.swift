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
    
    // MARK: - Clear All User Defaults
    static func clearAllUserDefaults() {
        let defaults = UserDefaults.standard
        for key in defaults.dictionaryRepresentation().keys {
            defaults.removeObject(forKey: key)
        }
        defaults.synchronize()
    }
}
