//
//  CollectionLocalDatabaseManager.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-11.
//

import Foundation
import SwiftData

/**
 A thread-safe actor responsible for managing local database operations for `Collection` entities.
 It provides methods for creating, reading, updating, and deleting `Collection` items in the local database.
 This actor ensures that all database operations are performed in a thread-safe manner, leveraging Swift's concurrency model.
 */
actor CollectionLocalDatabaseManager {
    // MARK: - SINGLETON
    static let shared: CollectionLocalDatabaseManager = .init()
    
    // MARK: - INITIALIZER
    private init() { }
    
    // MARK: - ASSIGNED PROPERTIES
    let localDatabaseManager: LocalDatabaseManager = .shared
    
    // MARK: PUBLIC FUNCTIONS
    
    // MARK: - Create Operations
    
    /// Adds a list of `Collection` items to the local database.
    /// - Parameter newItems: An array of `Collection` objects to be added to the database.
    /// - Throws: An error if the operation fails, such as if the context cannot be saved.
    @MainActor
    func addCollections(_ newItems: [Collection]) throws {
        for item in newItems {
            localDatabaseManager.insertToContext(item)
        }
        
        do {
            try localDatabaseManager.saveContext()
        } catch {
            Logger.log(CollectionLocalDatabaseManagerError.failedToCreateCollection(error).localizedDescription)
            throw error
        }
    }
    
    // MARK: - Read Operations
    
    /// Fetches all `Collection` items from the local database, sorted by their timestamp in ascending order.
    /// - Returns: An array of `Collection` objects fetched from the database.
    /// - Throws: An error if the operation fails, such as if the fetch request cannot be executed.
    @MainActor
    func fetchCollections() throws -> [Collection] {
        do {
            let descriptor: FetchDescriptor = FetchDescriptor<Collection>(
                sortBy: [SortDescriptor(\.timestamp, order: .forward)] // Ascending order
            )
            let collectionsArray: [Collection] = try localDatabaseManager.fetchFromContext(descriptor)
            
            return collectionsArray
        } catch {
            Logger.log(CollectionLocalDatabaseManagerError.failedToFetchCollections(error).localizedDescription)
            throw error
        }
    }
    
    // MARK: - Update Operations
    
    /// Saves any changes made to the `Collection` items in the local database.
    /// - Throws: An error if the operation fails, such as if the context cannot be saved.
    @MainActor
    func updateCollection() throws {
        do {
            try localDatabaseManager.saveContext()
        } catch {
            Logger.log(CollectionLocalDatabaseManagerError.failedToUpdateCollections(error).localizedDescription)
            throw error
        }
    }
    
    // MARK: - Delete Operations
    
    /// Deletes a specific `Collection` item from the local database.
    /// - Parameter item: The `Collection` object to be deleted.
    /// - Throws: An error if the operation fails, such as if the context cannot be saved after deletion.
    @MainActor
    func deleteCollection(at item: Collection) throws {
        localDatabaseManager.deleteFromContext(item)
        do {
            try localDatabaseManager.saveContext()
        } catch {
            Logger.log(CollectionLocalDatabaseManagerError.failedToDeleteCollection(error).localizedDescription)
            throw error
        }
    }
}
