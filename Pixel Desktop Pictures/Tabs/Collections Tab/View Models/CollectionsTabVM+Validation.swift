//
//  CollectionsTabVM+Validation.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-17.
//

import Foundation

extension CollectionsTabViewModel {
    func checkCollectionNameDuplications(_ collectionName: String) async throws {
        let isExist: Bool = collectionsArray.contains(where: { $0.name.lowercased() == collectionName.lowercased() })
        if isExist {
            setShowCreateButtonProgress(false)
            setShowRenameButtonProgress(false)
            await getErrorPopupVM().addError(getErrorPopup().duplicateCollectionNameFound)
            
            throw CollectionsViewModelErrorModel.duplicateCollectionName
        }
    }
    
    func isQueryImageExistInLocalDatabase(for collectionName: String) async throws -> Bool {
        let isExist: Bool = try await !getQueryImageManager().fetchQueryImages(for: [collectionName]).isEmpty
        return isExist
    }
    
    func handleEmptyCollectionName(_ name: String) async -> Bool {
        // Early exit to avoid errors when creating a collection with an empty value.
        guard !name.isEmpty else {
            await getErrorPopupVM().addError(getErrorPopup().emptyCollectionName)
            return false
        }
        
        return true
    }
}
