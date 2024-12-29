//
//  UserDefaultsManager.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-28.
//

import Foundation

actor UserDefaultsManager {
    private let defaults = UserDefaults.standard
    
    // Async method to save a value to UserDefaults
    func save(key: String, value: Any) async {
        defaults.set(value, forKey: key)
    }
    
    // Async method to read a value from UserDefaults
    func get(key: String) async -> Any? {
        return defaults.object(forKey: key)
    }
    
    static func clearAllUserDefaults() {
        let defaults = UserDefaults.standard
        for key in defaults.dictionaryRepresentation().keys {
            defaults.removeObject(forKey: key)
        }
        defaults.synchronize()
    }
}
