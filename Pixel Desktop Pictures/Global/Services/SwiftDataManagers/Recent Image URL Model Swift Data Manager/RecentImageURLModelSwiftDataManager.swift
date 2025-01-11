//
//  RecentImageURLModelSwiftDataManager.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-11.
//

import Foundation
import SwiftData

@MainActor
@Observable
final class RecentImageURLModelSwiftDataManager {
    // MARK: - PROPERTIES
    private var container: ModelContainer
    
    // MARK: - INITIALIZER
    /// Initializes the `RecentImageURLModelSwiftDataManager` with the given app environment.
    /// - Parameter appEnvironment: The environment of the app, used to determine whether the container is stored in memory only or persists on disk.
    /// - Throws: Throws an error if the model container initialization fails.
    init(appEnvironment: AppEnvironmentModel) throws {
        do {
            container = try ModelContainer(
                for: RecentImageURLModel.self,
                configurations: .init(isStoredInMemoryOnly: appEnvironment == .mock)
            )
            print("`RecentImageURLModelSwiftDataManager` has been initialized!")
        } catch {
            print(RecentImageURLModelSwiftDataManagerErrorModel.modelContainerInitializationFailed(error).localizedDescription)
            throw error
        }
    }
    
    // MARK: FUNCTIONS
    
    // MARK: INTERNAL FUNCTIONS
    
    // MARK: - Create Operations
    
    // MARK: Add Recent Image URL Model
    /// Adds a new RecentImageURLModel to the container and saves it to the context.
    /// - Parameter object: The RecentImageURLModel instance to be added.
    /// - Throws: Throws an error if saving the model to context fails.
    func addRecentImageURLModel(_ object: RecentImageURLModel) throws {
        container.mainContext.insert(object)
        
        do {
            try saveContext()
        } catch {
            print(RecentImageURLModelSwiftDataManagerErrorModel.recentImageURLModelCreationFailed(error).localizedDescription)
            throw error
        }
    }
    
    // MARK: - Read Operations
    
    // MARK: Fetch Recent Image URL Models Array
    /// Fetches an array of RecentImageURLModel from the container.
    /// - Returns: An array of RecentImageURLModel.
    /// - Throws: Throws an error if fetching the models from the context fails.
    func fetchRecentImageURLModelsArray() throws -> [RecentImageURLModel] {
        do {
            let recentImageURLModelsArray: [RecentImageURLModel] = try container.mainContext.fetch(FetchDescriptor<RecentImageURLModel>())
            return recentImageURLModelsArray
        } catch {
            print(RecentImageURLModelSwiftDataManagerErrorModel.recentImageURLModelsArrayFetchFailed(error).localizedDescription)
            throw error
        }
    }
    
    // MARK: - Update Operations
    
    // MARK: Update Recent Image URL Model
    /// Updates an existing RecentImageURLModel with new values and saves the changes to context.
    /// - Parameters:
    ///   - recentImage: The RecentImageURLModel instance to be updated.
    ///   - newValues: The new values to replace the existing ones.
    /// - Throws: Throws an error if updating the model or saving changes to context fails.
    func updateRecentImageURLModel(_ recentImage: RecentImageURLModel, newValues: RecentImageURLModel) throws {
        recentImage.downloadedDate = newValues.downloadedDate
        recentImage.imageURLString = newValues.imageURLString
        
        do {
            try saveContext()
        } catch {
            print(RecentImageURLModelSwiftDataManagerErrorModel.recentImageURLModelUpdateFailed(error).localizedDescription)
            throw error
        }
    }
    
    // MARK: - Delete Operations
    
    // MARK: Delete Recent Image URL Model
    /// Deletes an existing RecentImageURLModel from the container and saves the changes to context.
    /// - Parameter recentImage: The RecentImageURLModel instance to be deleted.
    /// - Throws: Throws an error if deleting the model or saving changes to context fails.
    func deleteRecentImageURLModel(_ recentImage: RecentImageURLModel) throws {
        container.mainContext.delete(recentImage)
        do {
            try saveContext()
        } catch {
            print(RecentImageURLModelSwiftDataManagerErrorModel.recentImageURLModelDeletionFailed(error))
            throw error
        }
    }
    
    // MARK: Erase All Data
    /// Erases all data stored in the `RecentImageURLModel` container.
    /// - Throws: Throws an error if erasing data fails.
    func eraseAllData() throws {
        do {
            try container.erase()
        } catch {
            print(RecentImageURLModelSwiftDataManagerErrorModel.eraseAllDataFailed(error).localizedDescription)
            throw error
        }
    }
    
    // MARK: PRIVATE FUNCTIONS
    
    // MARK: - Save Context
    /// Saves the current context to persist changes.
    /// - Throws: Throws an error if saving the context fails.
    private func saveContext() throws {
        do {
            try container.mainContext.save()
        } catch {
            // Rollback changes to the context if saving fails
            container.mainContext.rollback() // Rollback any unsaved changes
            print(RecentImageURLModelSwiftDataManagerErrorModel.contextSaveFailed(error).localizedDescription)
            throw error
        }
    }
}
