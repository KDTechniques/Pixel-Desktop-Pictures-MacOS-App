//
//  CollectionModelSwiftDataManager.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-11.
//

import Foundation
import SwiftData

@MainActor
final class CollectionModelSwiftDataManager {
    // MARK: - INJECTED PROPERTIES
    let swiftDataManager: SwiftDataManager
    
    // MARK: - INITIALIZER
    init(swiftDataManager: SwiftDataManager) {
        self.swiftDataManager = swiftDataManager
    }
    
    // MARK: - ASSIGNED PROPERTIES
    private let collectionModelManager: CollectionModelManager = .shared
    
    // MARK: FUNCTIONS
    
    // MARK: - Create Operations
    
    // MARK: Add Collection Item Model
    /// Adds a new CollectionModel to the container and saves it to the context.
    /// - Parameter object: The CollectionModel instance to be added.
    /// - Throws: Throws an error if saving the model to context fails.
    func addCollectionItemModel(_ object: CollectionModel) throws {
        swiftDataManager.container.mainContext.insert(object)
        
        do {
            try swiftDataManager.saveContext()
        } catch {
            print(CollectionModelSwiftDataManagerErrorModel.collectionItemModelCreationFailed(error).localizedDescription)
            throw error
        }
    }
    
    // MARK: - Read Operations
    
    // MARK: Fetch Collection Item Models Array
    /// Fetches an array of CollectionModel from the swiftDataManager.container.
    /// - Returns: An array of CollectionModel.
    /// - Throws: Throws an error if fetching the models from the context fails.
    func fetchCollectionItemModelsArray() throws -> [CollectionModel] {
        do {
            let collectionItemModelsArray: [CollectionModel] = try swiftDataManager.container.mainContext.fetch(FetchDescriptor<CollectionModel>())
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
    ///   - item: The CollectionModel instance whose collection name is to be updated.
    ///   - newCollectionName: The new collection name to be set.
    ///   - imageAPIServiceReference: The UnsplashImageAPIService reference used for image-related operations.
    /// - Throws: Throws an error if updating the collection name or saving changes to context fails.
    func updateCollectionName(in item: CollectionModel, newCollectionName: String, imageAPIServiceReference: UnsplashImageAPIService) async throws {
        do {
            try await collectionModelManager.renameCollectionName(for: item, newCollectionName: newCollectionName, imageAPIServiceReference: imageAPIServiceReference)
            try swiftDataManager.saveContext()
        } catch {
            print(CollectionModelSwiftDataManagerErrorModel.collectionItemModelUpdateFailed(error).localizedDescription)
            throw error
        }
    }
    
    // MARK: Update Collection Image URL String
    /// Updates the image URL string of a given CollectionModel, and saves the changes to context.
    /// - Parameters:
    ///   - item: The CollectionModel instance whose image URL is to be updated.
    ///   - imageAPIServiceReference: The UnsplashImageAPIService reference used for image-related operations.
    /// - Throws: Throws an error if updating the image URL or saving changes to context fails.
    func updateCollectionImageURLString(in item: CollectionModel, imageAPIServiceReference: UnsplashImageAPIService) async throws {
        do {
            try await collectionModelManager.updateImageURLString(in: item, imageAPIServiceReference: imageAPIServiceReference)
            try swiftDataManager.saveContext()
        } catch {
            print( CollectionModelSwiftDataManagerErrorModel.collectionItemModelUpdateFailed(error).localizedDescription)
            throw error
        }
    }
    
    // MARK: - Delete Operations
    
    // MARK: Delete Recent Image URL Model
    /// Deletes an existing CollectionModel from the container and saves the changes to context.
    /// - Parameter item: The CollectionModel instance to be deleted.
    /// - Throws: Throws an error if deleting the model or saving changes to context fails.
    func deleteCollectionItemModel(at item: CollectionModel) throws {
        swiftDataManager.container.mainContext.delete(item)
        do {
            try swiftDataManager.saveContext()
        } catch {
            print(CollectionModelSwiftDataManagerErrorModel.collectionItemModelDeletionFailed(error).localizedDescription)
            throw error
        }
    }
}
