//
//  CollectionsTabVM+CleanUp.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-17.
//

import Foundation

extension CollectionsTabViewModel {
    /// Resets the text fields to empty strings to ensure a clean state.
    ///
    /// This function should be called when the popover is dismissed to avoid a poor user experience
    /// by ensuring the text fields are cleared when the popover reappears.
    func resetTextfieldTexts() {
        setNameTextfieldText("")
        setRenameTextfieldText("")
        Logger.log("✅: Textfields has been reset.")
    }
    
    /// Resets the updating collection item to `nil` to prevent data corruption.
    ///
    /// This function must be called when the popover is dismissed to ensure that
    /// no stale data remains associated with the updating item.
    func resetUpdatingItem() {
        setUpdatingItem(nil)
        Logger.log("✅: Updating item has been set to nil.")
    }
}
