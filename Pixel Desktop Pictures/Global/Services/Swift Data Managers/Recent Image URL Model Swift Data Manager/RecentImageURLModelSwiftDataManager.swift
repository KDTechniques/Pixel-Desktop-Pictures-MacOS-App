//
//  RecentImageURLModelSwiftDataManager.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-11.
//

import Foundation
import SwiftData

@MainActor
final class RecentImageURLModelSwiftDataManager {
    // MARK: - PROPERTIES
    let swiftDataManager: SwiftDataManager
    
    // MARK: - INITIALIZER
    init(swiftDataManager: SwiftDataManager) {
        self.swiftDataManager = swiftDataManager
    }
    
    // MARK: FUNCTIONS
    
    // MARK: - Create Operations
    
    // MARK: Add Recent Image URL Model
    /// Adds a new RecentImageURLModel to the container and saves it to the context.
    /// - Parameter object: The RecentImageURLModel instance to be added.
    /// - Throws: Throws an error if saving the model to context fails.
    func addRecentImageURLModel(_ object: RecentImageURLModel) throws {
        swiftDataManager.container.mainContext.insert(object)
        
        do {
            try swiftDataManager.saveContext()
        } catch {
            print(RecentImageURLModelSwiftDataManagerErrorModel.recentImageURLModelCreationFailed(error).localizedDescription)
            throw error
        }
    }
    
    // MARK: - Read Operations
    
    // MARK: Fetch Recent Image URL Models Array
    /// Fetches an array of RecentImageURLModel from the swiftDataManager.container.
    /// - Returns: An array of RecentImageURLModel.
    /// - Throws: Throws an error if fetching the models from the context fails.
    func fetchRecentImageURLModelsArray() throws -> [RecentImageURLModel] {
        do {
            let recentImageURLModelsArray: [RecentImageURLModel] = try swiftDataManager.container.mainContext.fetch(FetchDescriptor<RecentImageURLModel>())
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
            try swiftDataManager.saveContext()
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
        swiftDataManager.container.mainContext.delete(recentImage)
        do {
            try swiftDataManager.saveContext()
        } catch {
            print(RecentImageURLModelSwiftDataManagerErrorModel.recentImageURLModelDeletionFailed(error))
            throw error
        }
    }
}
