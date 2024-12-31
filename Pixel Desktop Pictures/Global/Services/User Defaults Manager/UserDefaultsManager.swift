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
    func save(key: String, value: Any) async {
        defaults.set(value, forKey: key)
    }
    
    // MARK: - Get Value from User Defaults
    func get(key: String) async -> Any? {
        return defaults.object(forKey: key)
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
