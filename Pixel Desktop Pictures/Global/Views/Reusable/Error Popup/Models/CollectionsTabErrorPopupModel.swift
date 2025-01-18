//
//  CollectionsTabErrorPopupModel.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-12.
//

import Foundation

enum CollectionsTabErrorPopupModel: ErrorPopupProtocol {
    case duplicateCollectionNameFound
    case failedToCreateCollection
    case failedToUpdateCollectionName
    case failedToUpdateCollectionThumbnail
    case failedToUpdateCollectionSelection
    case failedToDeleteCollection
    case emptyCollectionName
    case somethingWentWrong
    
    var title: String {
        switch self {
        case .duplicateCollectionNameFound:
            return "Duplicate collection name found. Please choose a unique name."
        case .failedToCreateCollection:
            return "Failed to create collection."
        case .failedToUpdateCollectionName:
            return "Failed to update collection name."
        case .failedToUpdateCollectionThumbnail:
            return "Failed to update collection thumbnail."
        case .failedToUpdateCollectionSelection:
            return "Failed to select/deselect collection."
        case .failedToDeleteCollection:
            return "Failed to delete collection."
        case .emptyCollectionName:
            return "You forgot to enter the collection name."
        case .somethingWentWrong:
            return "Something went wrong. Please try again later."
        }
    }
}
