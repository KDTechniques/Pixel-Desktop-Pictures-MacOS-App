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
    case failedToUpdateCollectionThumbnailImage
    case failedToUpdateCollectionSelection
    case failedToDeleteCollection
    case emptyCollectionName
    case failedSomethingOnQueryImages
    case somethingWentWrong
    
    var title: String {
        switch self {
        case .duplicateCollectionNameFound:
            return "Duplicate collection name found. Please choose a unique name."
        case .failedToCreateCollection:
            return "Failed to create collection."
        case .failedToUpdateCollectionName:
            return "Failed to update collection name."
        case .failedToUpdateCollectionThumbnailImage:
            return "Failed to update collection thumbnail image."
        case .failedToUpdateCollectionSelection:
            return "Failed to select/deselect collection."
        case .failedToDeleteCollection:
            return "Failed to delete collection."
        case .emptyCollectionName:
            return "You forgot to enter the collection name."
        case .failedSomethingOnQueryImages:
            return "Something went wrong.\nYou may not be able to set collection based desktop pictures."
        case .somethingWentWrong:
            return "Something went wrong. Please try again later."
        }
    }
}
