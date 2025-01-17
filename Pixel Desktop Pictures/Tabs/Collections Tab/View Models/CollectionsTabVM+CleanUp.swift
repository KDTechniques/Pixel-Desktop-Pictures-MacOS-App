//
//  CollectionsTabVM+CleanUp.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-17.
//

import Foundation

extension CollectionsTabViewModel {
    func resetTextfieldTexts() {
        setNameTextfieldText("")
        setRenameTextfieldText("")
    }
    
    func resetUpdatingItem() {
        setUpdatingItem(nil)
    }
    
    func resetQueryImagesArray() {
        setQueryImagesArray([])
    }
}
