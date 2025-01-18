//
//  LocalDatabaseManager.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-11.
//

import Foundation
import SwiftData

actor LocalDatabaseManager {
    // MARK: - INJECTED PROPERTIES
    private(set) var container: ModelContainer
    
    // MARK: - INITIALIZER
    
    init(appEnvironment: AppEnvironmentModel) throws {
        do {
            container = try ModelContainer(
                for: QueryImage.self, Collection.self,
                configurations: .init(isStoredInMemoryOnly: appEnvironment == .mock)
            )
            print("`LocalDatabaseManager` has been initialized!")
        } catch {
            print(LocalDatabaseManagerErrorModel.failedToInitializeModelContainer(error).localizedDescription)
            throw error
        }
    }
    
    // MARK: INTERNAL FUNCTIONS
    
    func eraseAllData() async throws {
        do {
            try container.erase()
        } catch {
            print(LocalDatabaseManagerErrorModel.failedToEraseAllData(error).localizedDescription)
            throw error
        }
    }
    
    @MainActor
    func saveContext() async throws {
        do {
            try await container.mainContext.save()
        } catch {
            // Rollback changes to the context if saving fails
            await container.mainContext.rollback() // Rollback any unsaved changes
            print(LocalDatabaseManagerErrorModel.failedToSaveContext(error).localizedDescription)
            throw error
        }
    }
}
