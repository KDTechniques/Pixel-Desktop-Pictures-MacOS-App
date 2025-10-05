//
//  LocalDatabaseManager.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-11.
//

import Foundation
import SwiftData

/**
 A thread-safe actor responsible for managing the local database operations.
 It provides methods for initializing the database, erasing all data, and saving changes to the context.
 This actor ensures that all database operations are performed in a thread-safe manner, leveraging Swift's concurrency model.
 */
actor LocalDatabaseManager {
    // MARK: SINGLETON
    static let shared: LocalDatabaseManager = .init()
    
    // MARK: - INJECTED PROPERTIES
    private(set) var container: ModelContainer
    
    // MARK: - INITIALIZER
    private init() {
        do {
            container = try ModelContainer(
                for: Collection.self, QueryImage.self, Recent.self,
                configurations: .init(isStoredInMemoryOnly: appEnvironment == .mock)
            )
            Logger.log("✅: Initialized `LocalDatabaseManager`.")
        } catch {
            Logger.log(LocalDatabaseManagerError.failedToInitializeModelContainer(error).localizedDescription)
            fatalError()
        }
    }
    
    // MARK: PUBLIC FUNCTIONS
    
    /// Erases all data from the local database.
    /// - Throws: An error if the operation fails, such as if the database cannot be erased.
    func eraseAllData() async throws {
        do {
            try container.erase()
        } catch {
            Logger.log(LocalDatabaseManagerError.failedToEraseAllData(error).localizedDescription)
            throw error
        }
    }
    
    /// Saves changes made to the local database context.
    /// - Throws: An error if the operation fails, such as if the context cannot be saved.
    /// - Note: If saving fails, the context will roll back any unsaved changes.
    @MainActor
    func saveContext() async throws {
        do {
            try await container.mainContext.save()
        } catch {
            // Rollback changes to the context if saving fails
            await container.mainContext.rollback() // Rollback any unsaved changes
            Logger.log(LocalDatabaseManagerError.failedToSaveContext(error).localizedDescription)
            throw error
        }
    }
}
