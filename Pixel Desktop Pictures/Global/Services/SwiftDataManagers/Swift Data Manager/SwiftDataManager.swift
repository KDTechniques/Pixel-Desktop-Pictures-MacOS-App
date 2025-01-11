//
//  SwiftDataManager.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-11.
//

import Foundation
import SwiftData

@MainActor
class SwiftDataManager {
    // MARK: - PROPERTIES
    private(set) var container: ModelContainer
    
    // MARK: - INITIALIZER
    /// Initializes the `SwiftDataManager` with the given app environment.
    /// - Parameter appEnvironment: The environment of the app, used to determine whether the container is stored in memory only or persists on disk.
    /// - Throws: Throws an error if the model container initialization fails.
    init(appEnvironment: AppEnvironmentModel) throws {
        do {
            container = try ModelContainer(
                for: ImageQueryURLModel.self, RecentImageURLModel.self, CollectionModel.self,
                configurations: .init(isStoredInMemoryOnly: appEnvironment == .mock)
            )
            print("`SwiftDataManager` has been initialized!")
        } catch {
            print(SwiftDataManagerErrorModel.modelContainerInitializationFailed(error).localizedDescription)
            throw error
        }
    }
    
    // MARK: INTERNAL FUNCTIONS
    
    // MARK: Erase All Data
    /// Erases all data stored in the `ImageQueryURLModel` container.
    /// - Throws: Throws an error if erasing data fails.
    func eraseAllData() throws {
        do {
            try container.erase()
        } catch {
            print(SwiftDataManagerErrorModel.eraseAllDataFailed(error).localizedDescription)
            throw error
        }
    }
    
    // MARK: PRIVATE FUNCTIONS
    
    // MARK: - Save Context
    /// Saves the current context to persist changes.
    /// - Throws: Throws an error if saving the context fails.
    func saveContext() throws {
        do {
            try container.mainContext.save()
        } catch {
            // Rollback changes to the context if saving fails
            container.mainContext.rollback() // Rollback any unsaved changes
            print(SwiftDataManagerErrorModel.contextSaveFailed(error).localizedDescription)
            throw error
        }
    }
}
