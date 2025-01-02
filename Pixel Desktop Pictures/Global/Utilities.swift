//
//  Utilities.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-23.
//

import Foundation

struct Utilities {
    // MARK: - App Version
    static func appVersion() -> String? {
        guard let version: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
              let build: String = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else { return nil }
        
        return "\(version) (\(build))"
    }
    
    // MARK: - Mime Type to File Extension
    static func mimeTypeToFileExtension(_ mimeType: String) -> String {
        let mimeMapping: [String: String] = [
            "image/jpeg": "jpg",
            "image/png": "png",
            "image/gif": "gif",
            "image/webp": "webp",
            "image/bmp": "bmp",
            "image/tiff": "tiff"
        ]
        
        return mimeMapping[mimeType] ?? "jpg"
    }
}
