//
//  CollectionsTabVM+Validation.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-17.
//

import Foundation

extension CollectionsTabViewModel {
    /// Checks for duplicate collection names in the current collections array.
    ///
    /// This function validates the uniqueness of a given collection name by comparing it (case-insensitively)
    /// against the names of existing collections. If a duplicate is found, it halts further processing, stops any ongoing progress animations,
    /// displays an error popup, and throws an error.
    ///
    /// - Parameters:
    ///   - collectionName: The name of the collection to validate for uniqueness.
    ///
    /// - Throws: `duplicateCollectionName` if the collection name already exists in the collections array.
    ///
    /// - Important: This function ensures the integrity of collection names in the app, avoiding conflicts or data corruption.
    func checkCollectionNameDuplications(_ collectionName: String) async throws {
        let isExist: Bool = collectionsArray.contains(where: { $0.name.lowercased() == collectionName.lowercased() })
        if isExist {
            setShowCreateButtonProgress(false)
            setShowRenameButtonProgress(false)
            
            print(getVMError().duplicateCollectionName.localizedDescription)
            await getErrorPopupVM().addError(getErrorPopup().duplicateCollectionNameFound)
            throw getVMError().duplicateCollectionName
        }
    }
    
    /// Checks if a `QueryImage` exists in the local database for a given collection name.
    ///
    /// This function queries the local database to verify the presence of a `QueryImage` item
    /// associated with the specified collection name. It returns `true` if a matching `QueryImage`
    /// exists, otherwise `false`.
    ///
    /// - Parameters:
    ///   - collectionName: The name of the collection to check for a corresponding `QueryImage`.
    ///
    /// - Returns: A `Bool` indicating whether a `QueryImage` exists for the specified collection name.
    ///
    /// - Throws: An error if the query operation fails.
    ///
    /// - Important: This function ensures that duplicate or redundant `QueryImage` creation is avoided.
    func isQueryImageExistInLocalDatabase(for collectionName: String) async throws -> Bool {
        let isExist: Bool = try await !getQueryImageManager().fetchQueryImages(for: [collectionName]).isEmpty
        return isExist
    }
    
    /// Handles validation for empty collection names.
    ///
    /// This function checks if the provided collection name is empty. If it is, an error popup
    /// is displayed to notify the user about the invalid input, and the function returns `false`.
    /// Otherwise, it returns `true`, allowing further processing.
    ///
    /// - Parameters:
    ///   - name: The collection name to validate.
    ///
    /// - Returns: A `Bool` indicating whether the collection name is non-empty (`true`) or empty (`false`).
    ///
    /// - Note: This function is used to ensure that empty collection names are not processed,
    /// which helps maintain data integrity and user experience.
    func handleEmptyCollectionName(_ name: String) async -> Bool {
        guard !name.isEmpty else {
            await getErrorPopupVM().addError(getErrorPopup().emptyCollectionName)
            return false
        }
        
        return true
    }
}
