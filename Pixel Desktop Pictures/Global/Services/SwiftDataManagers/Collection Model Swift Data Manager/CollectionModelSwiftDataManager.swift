//
//  CollectionModelSwiftDataManager.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-11.
//

import Foundation
import SwiftData

@MainActor
@Observable
final class CollectionModelSwiftDataManager {
    // MARK: - PROPERTIES
    private var container: ModelContainer
    
    // MARK: - INITIALIZER
    /// Initializes the `CollectionModelSwiftDataManager` with the given app environment.
    /// - Parameter appEnvironment: The environment of the app, used to determine whether the container is stored in memory only or persists on disk.
    /// - Throws: Throws an error if the model container initialization fails.
    init(appEnvironment: AppEnvironmentModel) throws {
        do {
            container = try ModelContainer(
                for: CollectionModel.self,
                configurations: .init(isStoredInMemoryOnly: appEnvironment == .mock)
            )
            print("`CollectionModelSwiftDataManager` has been initialized!")
        } catch {
            print(CollectionModelSwiftDataManagerErrorModel.modelContainerInitializationFailed(error).localizedDescription)
            throw error
        }
    }
    
    // MARK: FUNCTIONS
    
    // MARK: INTERNAL FUNCTIONS
    
    // MARK: - Create Operations
    
    // MARK: Add Collection Item Model
    /// Adds a new CollectionModel to the container and saves it to the context.
    /// - Parameter object: The CollectionModel instance to be added.
    /// - Throws: Throws an error if saving the model to context fails.
    func addCollectionItemModel(_ object: CollectionModel) throws {
        container.mainContext.insert(object)
        
        do {
            try saveContext()
        } catch {
            print(CollectionModelSwiftDataManagerErrorModel.collectionItemModelCreationFailed(error).localizedDescription)
            throw error
        }
    }
    
    // MARK: - Read Operations
    
    // MARK: Fetch Collection Item Models Array
    /// Fetches an array of CollectionModel from the container.
    /// - Returns: An array of CollectionModel.
    /// - Throws: Throws an error if fetching the models from the context fails.
    func fetchCollectionItemModelsArray() throws -> [CollectionModel] {
        do {
            let collectionItemModelsArray: [CollectionModel] = try container.mainContext.fetch(FetchDescriptor<CollectionModel>())
            return collectionItemModelsArray
        } catch {
            print(CollectionModelSwiftDataManagerErrorModel.collectionItemModelsArrayFetchFailed(error).localizedDescription)
            throw error
        }
    }
    
    // MARK: - Update Operations
    
    // MARK: Update Collection Item Model
    /// Updates the collection name for a given CollectionModel, and saves the changes to context.
    /// - Parameters:
    ///   - collectionItem: The CollectionModel instance whose collection name is to be updated.
    ///   - newCollectionName: The new collection name to be set.
    ///   - imageAPIServiceReference: The UnsplashImageAPIService reference used for image-related operations.
    /// - Throws: Throws an error if updating the collection name or saving changes to context fails.
    func updateCollectionName(_ collectionItem: CollectionModel, newCollectionName: String, imageAPIServiceReference: UnsplashImageAPIService) async throws {
        do {
            try await collectionItem.renameCollectionName(newCollectionName: newCollectionName, imageAPIServiceReference: imageAPIServiceReference)
            try saveContext()
        } catch {
            print(CollectionModelSwiftDataManagerErrorModel.collectionItemModelUpdateFailed(error).localizedDescription)
            throw error
        }
    }
    
    // MARK: Update Collection Selection State
    /// Updates the selection state of a given CollectionModel, and saves the changes to context.
    /// - Parameters:
    ///   - collectionItem: The CollectionModel instance whose selection state is to be updated.
    ///   - isSelected: A boolean indicating whether the collection item is selected or not.
    /// - Throws: Throws an error if updating the selection state or saving changes to context fails.
    func updateCollectionSelectionState(_ collectionItem: CollectionModel, isSelected: Bool) throws {
        collectionItem.updateIsSelected(isSelected)
        
        do {
            try saveContext()
        } catch {
            print(CollectionModelSwiftDataManagerErrorModel.collectionItemModelUpdateFailed(error).localizedDescription)
            throw error
        }
    }
    
    // MARK: Update Collection Image URL String
    /// Updates the image URL string of a given CollectionModel, and saves the changes to context.
    /// - Parameters:
    ///   - collectionItem: The CollectionModel instance whose image URL is to be updated.
    ///   - imageAPIServiceReference: The UnsplashImageAPIService reference used for image-related operations.
    /// - Throws: Throws an error if updating the image URL or saving changes to context fails.
    func updateCollectionImageURLString(_ collectionItem: CollectionModel, imageAPIServiceReference: UnsplashImageAPIService) async throws {
        do {
            try await collectionItem.updateImageURLString(imageAPIServiceReference: imageAPIServiceReference)
            try saveContext()
        } catch {
            print( CollectionModelSwiftDataManagerErrorModel.collectionItemModelUpdateFailed(error).localizedDescription)
            throw error
        }
    }
    
    // MARK: - Delete Operations
    
    // MARK: Delete Recent Image URL Model
    /// Deletes an existing CollectionModel from the container and saves the changes to context.
    /// - Parameter collectionItem: The CollectionModel instance to be deleted.
    /// - Throws: Throws an error if deleting the model or saving changes to context fails.
    func deleteCollectionItemModel(_ collectionItem: CollectionModel) throws {
        container.mainContext.delete(collectionItem)
        do {
            try saveContext()
        } catch {
            print(CollectionModelSwiftDataManagerErrorModel.collectionItemModelDeletionFailed(error).localizedDescription)
            throw error
        }
    }
    
    // MARK: Erase All Data
    /// Erases all data stored in the `CollectionModel` container.
    /// - Throws: Throws an error if erasing data fails.
    func eraseAllData() throws {
        do {
            try container.erase()
        } catch {
            print(CollectionModelSwiftDataManagerErrorModel.eraseAllDataFailed(error).localizedDescription)
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
            print(CollectionModelSwiftDataManagerErrorModel.contextSaveFailed(error).localizedDescription)
            throw error
        }
    }
}
