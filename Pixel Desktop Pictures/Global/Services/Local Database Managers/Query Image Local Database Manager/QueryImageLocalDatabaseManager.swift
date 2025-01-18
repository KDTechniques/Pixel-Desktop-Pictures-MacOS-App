//
//  QueryImageLocalDatabaseManager.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-11.
//

import Foundation
import SwiftData

actor QueryImageLocalDatabaseManager {
    // MARK: - INJECTED PROPERTIES
    let localDatabaseManager: LocalDatabaseManager
    
    // MARK: - INITIALIZER
    init(localDatabaseManager: LocalDatabaseManager) {
        self.localDatabaseManager = localDatabaseManager
    }
    
    // MARK: FUNCTIONS
    
    // MARK: - Create Operations
    
    @MainActor
    func addQueryImages(_ newItems: [QueryImage]) async throws {
        do {
            for object in newItems {
                await localDatabaseManager.container.mainContext.insert(object)
            }
            
            try await localDatabaseManager.saveContext()
        } catch {
            print(QueryImageLocalDatabaseManagerErrors.failedToCreateQueryImages(error).localizedDescription)
            throw error
        }
    }
    
    // MARK: - Read Operations
    
    @MainActor
    func fetchQueryImages(for collectionNames: [String]) async throws -> [QueryImage] {
        do {
            let descriptor = FetchDescriptor<QueryImage>(
                predicate: #Predicate<QueryImage> { collectionNames.contains($0.query) }
            )
            
            let queryImages: [QueryImage] = try await localDatabaseManager.container.mainContext.fetch(descriptor)
            return queryImages
        } catch {
            print(QueryImageLocalDatabaseManagerErrors.failedToFetchQueryImages(error).localizedDescription)
            throw error
        }
    }
    
    // MARK: - Update Operations
    func updateQueryImages() async throws {
        do {
            try await localDatabaseManager.saveContext()
        } catch {
            print(QueryImageLocalDatabaseManagerErrors.failedToUpdateQueryImages(error).localizedDescription)
            throw error
        }
    }
}
