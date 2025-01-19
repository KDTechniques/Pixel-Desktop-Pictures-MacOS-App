//
//  RecentLocalDatabaseManager.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-19.
//

import Foundation
import SwiftData

actor RecentLocalDatabaseManager {
    // MARK: - INJECTED PROPERTIES
    let localDatabaseManager: LocalDatabaseManager
    
    // MARK: - INITIALIZER
    init(localDatabaseManager: LocalDatabaseManager) {
        self.localDatabaseManager = localDatabaseManager
    }
    
    // MARK: FUNCTIONS
    
    // MARK: - Create Operations
    
    @MainActor
    func addRecent(_ newItem: Recent) async throws {
        await localDatabaseManager.container.mainContext.insert(newItem)
        
        do {
            try await localDatabaseManager.saveContext()
        } catch {
            print(CollectionLocalDatabaseManagerErrors.failedToCreateCollection(error).localizedDescription)
            throw error
        }
    }
    
    // MARK: - Read Operations
    
    @MainActor
    func fetchRecents() async throws -> [Recent] {
        do {
            let descriptor: FetchDescriptor = FetchDescriptor<Recent>(
                sortBy: [SortDescriptor(\.timestamp, order: .reverse)] // Descending order
            )
            
            let recentsArray: [Recent] = try await localDatabaseManager
                .container
                .mainContext
                .fetch(descriptor)
            
            return recentsArray
        } catch {
            print(CollectionLocalDatabaseManagerErrors.failedToFetchCollections(error).localizedDescription)
            throw error
        }
    }
    
    // MARK: - Update Operations
    
    func updateRecents() async throws {
        do {
            try await localDatabaseManager.saveContext()
        } catch {
            print(QueryImageLocalDatabaseManagerErrors.failedToUpdateQueryImages(error).localizedDescription)
            throw error
        }
    }
    
    // MARK: - Delete Operations
    
    @MainActor
    func deleteRecents(at items: [Recent]) async throws {
        for item in items {
            await localDatabaseManager.container.mainContext.delete(item)
        }
        
        do {
            try await localDatabaseManager.saveContext()
        } catch {
            print(CollectionLocalDatabaseManagerErrors.failedToDeleteCollection(error).localizedDescription)
            throw error
        }
    }
}
