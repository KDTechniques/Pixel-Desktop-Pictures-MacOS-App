//
//  CollectionsViewModelErrorModel.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-09.
//

import Foundation

enum CollectionsViewModelErrorModel: LocalizedError {
    case apiAccessKeyNotFound
    case duplicateCollectionName
    
    var errorDescription: String? {
        switch self {
        case .apiAccessKeyNotFound:
            return "Error: Failed to create a collection item model, because api access key is not found."
        case .duplicateCollectionName:
            return "Error: Failed to create a collection item model, because it's already exist."
        }
    }
}
