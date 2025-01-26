//
//  RecentsTabViewModel.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-27.
//

import Foundation

@MainActor
@Observable
final class RecentsTabViewModel {
    // MARK: - INJECTED PROPERTIES
    let recentManager: RecentManager
    
    // MARK: - ASSIGNED PROPERTIES
    private(set) var recentsArray: [Recent] = []
    private let maxRecentsCount: Int = 102
    let vmError: RecentsTabViewModelError.Type = RecentsTabViewModelError.self
    
    // MARK: - INITIALIZER
    init(recentManager: RecentManager) {
        self.recentManager = recentManager
    }
    
    // MARK: - INTERNAL FUNCTIONS
    
    /// Initializes the `Recents Tab View Model`.
    ///
    /// This function is responsible for fetching recent items from the local database, ensuring
    /// that the total count does not exceed the maximum allowed (`maxRecentsCount`). If the count
    /// exceeds the limit, the excess items are removed, and the modified array is saved back to the
    /// database. Finally, the processed array is assigned to the `recentsArray` property.
    ///
    /// - Throws: An error if fetching or saving recent items fails.
    /// - Note: This ensures that the recents tab is properly initialized with up-to-date and valid data.
    func initializeRecentsTabViewModel() async {
        do {
            // First fetch the `Recent` items from local database
            var tempRecentsArray: [Recent] = try await recentManager.getRecents()
          
            let recentsArrayCount: Int = tempRecentsArray.count
            
            // Make sure not to exceed 102 max items.
            if tempRecentsArray.count > maxRecentsCount {
                // Remove the exceeded items from the temp recents array.
                let exceededItemsCount: Int = recentsArrayCount - maxRecentsCount
                tempRecentsArray.removeLast(exceededItemsCount)
            }
            
            // First, assign the modified array to recents array.
            recentsArray = tempRecentsArray
            
            // Then save the changes to local database.
            try await recentManager.updateRecents()
            
            Logger.log("✅: `Recents Tab View Model` has been initialized")
        } catch {
            Logger.log(vmError.initializationFailed(error).localizedDescription)
        }
    }
    
    /// Adds a new recent item to the `Recents Tab View Model`.
    ///
    /// This function encodes the provided image type, creates a new `Recent` item, and updates
    /// the `recentsArray` by ensuring the total count does not exceed the maximum limit. The
    /// updated array is fetched by appending the new item, removing any exceeded items, and
    /// saving the changes to the local database.
    ///
    /// - Parameters:
    ///   - type: The type of the recent image, represented by a `UnsplashImage`.
    ///   - imageEncoded: The encoded data of the image to be added as a recent item.
    ///
    /// - Note: This function ensures thread safety and handles database updates to maintain the integrity of the recents array.
    func addRecent(imageEncoded: Data) async {
        do {
            // Create new `Recent` item.
            let newRecentItem: Recent = .init(imageEncoded: imageEncoded)
            
            // Get a recents array by appending, inserting, removing, and deleting exceeded items through the local database.
            let adjustedArray: [Recent] = try await insertAndDeleteExceededRecents(newRecentItem)
            recentsArray = adjustedArray
        } catch {
            Logger.log(vmError.failedToAddRecentsArray(error).localizedDescription)
        }
    }
    
    // MARK: - PRIVATE FUNCTIONS
    
    /// Appends a new `Recent` item and ensures that the recents array does not exceed the maximum limit of items.
    ///
    /// - Parameter newItem: The new `Recent` item to be added.
    /// - Returns: The adjusted recents array after handling the exceeded items.
    /// - Throws: If the exceeded items can't be deleted or added to the local database.
    private func insertAndDeleteExceededRecents(_ newItem: Recent) async throws -> [Recent] {
        // Append the new item to a temporary array for further processing.
        var tempRecentsArray: [Recent] = recentsArray
        tempRecentsArray.insert(newItem, at: 0)
        
        let tempRecentsArrayCount: Int = tempRecentsArray.count
        
        do {
            // Make sure not to exceed 102 max items.
            if tempRecentsArrayCount > maxRecentsCount {
                // Get the exceeded items count
                let exceededItemsCount: Int = tempRecentsArrayCount - maxRecentsCount
                
                // Filter the exceeded items.
                let exceededRecentItemsArray: [Recent] = tempRecentsArray.suffix(exceededItemsCount)
                
                // First, remove the exceeded items from the recents array.
                tempRecentsArray.removeLast(exceededItemsCount)
                
                // Then delete the exceeded items from the local database.
                try await recentManager.deleteRecents(at: exceededRecentItemsArray)
                Logger.log("✅: Exceeded recent items has been removed")
            }
            
            // Add the new recent item to local database.
            try await recentManager.addRecent(newItem)
            Logger.log("✅: A `Recent` item has been added to local database")
            
            // Finally, return the adjusted array.
            return tempRecentsArray
        } catch {
            Logger.log(vmError.failedToValidateExceededRecentItems(error).localizedDescription)
            throw error
        }
    }
}
