//
//  CollectionLocalDatabaseManager.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-11.
//

import Foundation
import SwiftData

actor CollectionLocalDatabaseManager {
    // MARK: - INJECTED PROPERTIES
    let localDatabaseManager: LocalDatabaseManager
    
    // MARK: - INITIALIZER
    init(localDatabaseManager: LocalDatabaseManager) {
        self.localDatabaseManager = localDatabaseManager
    }
    
    // MARK: FUNCTIONS
    
    // MARK: - Create Operations
    
    @MainActor
    func addCollections(_ newItems: [Collection]) async throws {
        for item in newItems {
            await localDatabaseManager.container.mainContext.insert(item)
        }
        
        do {
            try await localDatabaseManager.saveContext()
        } catch {
            print(CollectionLocalDatabaseManagerErrors.failedToCreateCollection(error).localizedDescription)
            throw error
        }
    }
    
    // MARK: - Read Operations
    
    @MainActor
    func fetchCollections() async throws -> [Collection] {
        do {
            let descriptor: FetchDescriptor = FetchDescriptor<Collection>(
                sortBy: [SortDescriptor(\.timestamp, order: .forward)] // Ascending order
            )
            let collectionsArray: [Collection] = try await localDatabaseManager
                .container
                .mainContext
                .fetch(descriptor)
            
            return collectionsArray
        } catch {
            print(CollectionLocalDatabaseManagerErrors.failedToFetchCollections(error).localizedDescription)
            throw error
        }
    }
    
    // MARK: - Update Operations
    
    func updateCollection() async throws {
        do {
            try await localDatabaseManager.saveContext()
        } catch {
            print(CollectionLocalDatabaseManagerErrors.failedToUpdateCollections(error).localizedDescription)
            throw error
        }
    }
    
    // MARK: - Delete Operations
    
    @MainActor
    func deleteCollection(at item: Collection) async throws {
        await localDatabaseManager.container.mainContext.delete(item)
        do {
            try await localDatabaseManager.saveContext()
        } catch {
            print(CollectionLocalDatabaseManagerErrors.failedToDeleteCollection(error).localizedDescription)
            throw error
        }
    }
}
