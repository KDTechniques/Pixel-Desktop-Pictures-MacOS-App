//
//  Utilities.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-23.
//

import Foundation

struct Utilities {
    // MARK: - PROPERTIES
    static let allWindowWidth: CGFloat = 375
    static let collectionsTabWindowHeight: CGFloat = 282
    
    // MARK: FUNCTIONS
    
    // MARK: - App Version
    static func appVersion() -> String? {
        guard let version: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
              let build: String = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else { return nil }
        
        return "\(version) (\(build))"
    }
}
