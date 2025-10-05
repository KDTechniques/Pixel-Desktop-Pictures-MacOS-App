//
//  RecentManager.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-19.
//

import Foundation

/**
 A thread-safe actor responsible for managing recently viewed images (`Recent` entities) in the local database.
 It provides methods for adding, fetching, updating, and deleting `Recent` items, as well as retrieving image URLs.
 This actor ensures that all operations are performed in a thread-safe manner, leveraging Swift's concurrency model.
 */
actor RecentManager {
    // MARK: - SINGLETON
    static let shared: RecentManager = .init()
    
    // MARK: - INITIALIZER
    private init() {
        
    }
    
    // MARK: - ASSIGNED PROPERTIES
    private let recentDatabaseManager: RecentLocalDatabaseManager = .shared
    private let managerError = RecentLocalDatabaseManagerError.self
    
    // MARK: PUBLIC FUNCTIONS
    
    // MARK: - Create Operations
    
    /// Adds a new `Recent` item to the local database.
    /// - Parameter newItem: The `Recent` object to be added.
    /// - Throws: An error if the operation fails, such as if the context cannot be saved.
    func addRecent(_ newItem: Recent) async throws {
        do {
            try await recentDatabaseManager.addRecent(newItem)
        } catch {
            Logger.log(managerError.failedToCreateRecent(error).localizedDescription)
            throw error
        }
    }
    
    // MARK: - Read Operations
    
    /// Fetches all `Recent` items from the local database.
    /// - Returns: An array of `Recent` objects fetched from the database.
    /// - Throws: An error if the operation fails, such as if the fetch request cannot be executed.
    func getRecents() async throws -> [Recent] {
        do {
            let recents: [Recent] = try await recentDatabaseManager.fetchRecents()
            return recents
        } catch {
            Logger.log(managerError.failedToFetchRecents(error).localizedDescription)
            throw error
        }
    }
    
    /// Retrieves the image URLs for a specific `Recent` item.
    /// - Parameter item: The `Recent` object for which to retrieve image URLs.
    /// - Returns: An `UnsplashImageResolution` object containing the image URLs.
    /// - Throws: An error if the operation fails, such as if the data cannot be decoded.
    func getImageURLs(from item: Recent) async throws -> UnsplashImageResolution {
        // First, decode data.
        let imageDecoded: UnsplashImage = try JSONDecoder().decode(UnsplashImage.self, from: item.imageEncoded)
        
        // Assign `imageQualityURLStrings` to a temp property to avoid making changes to local database.
        var tempImageQualityURLStrings: UnsplashImageResolution = imageDecoded.imageQualityURLStrings
        
        // Then modify thumbnail sizing.
        let updatedThumbURL: String = tempImageQualityURLStrings.thumb.replacingOccurrences( // Note: If this 50 width has no impact on UX, remove this line
            of: "(?<=\\b)w=200(?=&|$)",
            with: "w=50",
            options: .regularExpression
        )
        
        tempImageQualityURLStrings.thumb = updatedThumbURL
        
        // Return modified `UnsplashImageResolution` item.
        return tempImageQualityURLStrings
    }
    
    // MARK: - Update Operations
    
    /// Saves any changes made to the `Recent` items in the local database.
    /// - Throws: An error if the operation fails, such as if the context cannot be saved.
    func updateRecents() async throws {
        do {
            try await recentDatabaseManager.updateRecents()
        } catch {
            Logger.log(managerError.failedToUpdateRecents(error).localizedDescription)
            throw error
        }
    }
    
    // MARK: - Delete Operations
    
    /// Deletes a list of `Recent` items from the local database.
    /// - Parameter items: An array of `Recent` objects to be deleted.
    /// - Throws: An error if the operation fails, such as if the context cannot be saved after deletion.
    func deleteRecents(at items: [Recent]) async throws {
        do {
            try await recentDatabaseManager.deleteRecents(at: items)
        } catch {
            Logger.log(managerError.failedToDeleteRecent(error).localizedDescription)
            throw error
        }
    }
    
#if DEBUG
    /// Deletes all `Recent` items from the local database.
    /// First, fetches all available `Recent` items, then deletes them.
    /// This function is only available in debug builds for testing purposes.
    func deleteAllRecents() async {
        do {
            let recentItems: [Recent] = try await recentDatabaseManager.fetchRecents()
            try await recentDatabaseManager.deleteRecents(at: recentItems)
        } catch {
            Logger.log(RecentLocalDatabaseManagerError.failedToDeleteRecent(error).localizedDescription)
        }
    }
#endif
}
