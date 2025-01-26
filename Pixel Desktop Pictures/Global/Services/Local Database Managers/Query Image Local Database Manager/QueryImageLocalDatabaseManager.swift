//
//  QueryImageLocalDatabaseManager.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-11.
//

import Foundation
import SwiftData

/**
 A thread-safe actor responsible for managing local database operations for `QueryImage` entities.
 It provides methods for adding, fetching, and updating `QueryImage` items in the local database.
 This actor ensures that all database operations are performed in a thread-safe manner, leveraging Swift's concurrency model.
 */
actor QueryImageLocalDatabaseManager {
    // MARK: - INJECTED PROPERTIES
    let localDatabaseManager: LocalDatabaseManager
    
    // MARK: - INITIALIZER
    init(localDatabaseManager: LocalDatabaseManager) {
        self.localDatabaseManager = localDatabaseManager
    }
    
    // MARK: FUNCTIONS
    
    // MARK: - Create Operations
    
    /// Adds a list of `QueryImage` items to the local database.
    /// - Parameter newItems: An array of `QueryImage` objects to be added to the database.
    /// - Throws: An error if the operation fails, such as if the context cannot be saved.
    @MainActor
    func addQueryImages(_ newItems: [QueryImage]) async throws {
        do {
            for object in newItems {
                await localDatabaseManager.container.mainContext.insert(object)
            }
            
            try await localDatabaseManager.saveContext()
        } catch {
            Logger.log(QueryImageLocalDatabaseManagerError.failedToCreateQueryImages(error).localizedDescription)
            throw error
        }
    }
    
    // MARK: - Read Operations
    
    /// Fetches `QueryImage` items from the local database for the specified collection names.
    /// - Parameter collectionNames: An array of collection names (queries) to filter the `QueryImage` items.
    /// - Returns: An array of `QueryImage` objects that match the specified collection names.
    /// - Throws: An error if the operation fails, such as if the fetch request cannot be executed.
    @MainActor
    func fetchQueryImages(for collectionNames: [String]) async throws -> [QueryImage] {
        do {
            let descriptor = FetchDescriptor<QueryImage>(
                predicate: #Predicate<QueryImage> { collectionNames.contains($0.query) }
            )
            
            let queryImages: [QueryImage] = try await localDatabaseManager.container.mainContext.fetch(descriptor)
            return queryImages
        } catch {
            Logger.log(QueryImageLocalDatabaseManagerError.failedToFetchQueryImages(error).localizedDescription)
            throw error
        }
    }
    
    // MARK: - Update Operations
    
    /// Saves any changes made to the `QueryImage` items in the local database.
    /// - Throws: An error if the operation fails, such as if the context cannot be saved.
    func updateQueryImages() async throws {
        do {
            try await localDatabaseManager.saveContext()
        } catch {
            Logger.log(QueryImageLocalDatabaseManagerError.failedToUpdateQueryImages(error).localizedDescription)
            throw error
        }
    }
}
