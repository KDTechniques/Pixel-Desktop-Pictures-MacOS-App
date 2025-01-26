//
//  Utilities.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-23.
//

import Foundation

struct Utilities {
    /// Retrieves the app's version and build number from the main bundle.
    /// - Returns: A formatted string containing the app version and build number (e.g., "1.0.0 (123)"), or `nil` if the version or build number cannot be retrieved.
    static func appVersion() -> String? {
        guard let version: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
              let build: String = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else { return nil }
        
        return "\(version) (\(build))"
    }
    
    /// Converts a MIME type string to its corresponding file extension.
    /// - Parameter mimeType: The MIME type string (e.g., "image/jpeg").
    /// - Returns: The corresponding file extension (e.g., "jpg"). Defaults to "jpg" if the MIME type is not recognized.
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
