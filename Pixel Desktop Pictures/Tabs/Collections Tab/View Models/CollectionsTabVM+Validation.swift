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
}
