//
//  JSONFileStorageManagerError.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-01.
//

import Foundation

enum JSONFileStorageManagerError: LocalizedError {
    case JSONFileURLConstructionFailed
    case JSONFileSavingFailed(error: Error)
    case JSONFileLoadingFailed(error: Error)
    case JSONDataToStringArrayCastingFailed
    
    var errorDescription: String? {
        switch self {
        case .JSONFileURLConstructionFailed:
            return "Error: Failed to construct requested JSON file URL in the document directory.)"
        case .JSONFileSavingFailed(let error):
            return "Error: Failed to save URLs to json file. \(error.localizedDescription)"
        case .JSONFileLoadingFailed(let error):
            return "Error: Failed to load URLs from json file. \(error.localizedDescription)"
        case .JSONDataToStringArrayCastingFailed:
            return "Error: Failed to cast JSON data to array of url strings."
        }
    }
}
