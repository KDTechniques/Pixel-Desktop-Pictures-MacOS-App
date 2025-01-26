//
//  CollectionsTabErrorPopupModel.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-12.
//

import Foundation

enum CollectionsTabErrorPopup: ErrorPopupProtocol {
    case duplicateCollectionNameFound
    case failedToCreateCollection(_ error: Error)
    case failedToUpdateCollectionName(_ error: Error)
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
        case .failedToCreateCollection(let error):
            return "Failed to create collection.\(getReason(for: error))"
        case .failedToUpdateCollectionName(let error):
            return "Failed to update collection name.\(getReason(for: error))"
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
    
    private func getReason(for error: Error) -> String {
        var reason: String {
            let defaultReason: String = "\nSomething went wrong. Please try again later."
            guard let urlError: URLError = error as? URLError else { return defaultReason }
            
            switch urlError.code {
            case .resourceUnavailable:
                return " Please enter a valid noun."
            default:
                return defaultReason
            }
        }
        
        return reason
    }
}
