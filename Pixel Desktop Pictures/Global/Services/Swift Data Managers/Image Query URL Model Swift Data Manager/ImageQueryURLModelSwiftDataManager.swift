//
//  ImageQueryURLModelSwiftDataManager.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-11.
//

import Foundation
import SwiftData

@MainActor
final class ImageQueryURLModelSwiftDataManager {
    // MARK: - PROPERTIES
    let swiftDataManager: SwiftDataManager
    
    // MARK: - INITIALIZER
    init(swiftDataManager: SwiftDataManager) {
        self.swiftDataManager = swiftDataManager
    }
    
    // MARK: FUNCTIONS
    
    // MARK: - Create Operations
    
    // MARK:  Add Image Query URL Model
    func addImageQueryURLModel(_ newObjects: [ImageQueryURLModel]) throws {
        do {
            for object in newObjects {
                swiftDataManager.container.mainContext.insert(object)
            }
            
            try swiftDataManager.saveContext()
        } catch {
            print(ImageQueryURLModelSwiftDataManagerErrorModel.imageQueryURLModelCreationFailed(error).localizedDescription)
            throw error
        }
    }
    
    // MARK: - Read Operations
    
    // MARK: Fetch Image Query URL Models Array
    func fetchImageQueryURLModelsArray(for collectionNames: [String]) throws -> [ImageQueryURLModel] {
        do {
            let descriptor = FetchDescriptor<ImageQueryURLModel>(
                predicate: #Predicate<ImageQueryURLModel> { collectionNames.contains($0.queryText) }
            )
            
            let imageQueryURLModelsArray: [ImageQueryURLModel] = try swiftDataManager.container.mainContext.fetch(descriptor)
            return imageQueryURLModelsArray
        } catch {
            print(ImageQueryURLModelSwiftDataManagerErrorModel.imageQueryURLModelsArrayFetchFailed(error).localizedDescription)
            throw error
        }
    }
    
    // MARK: - Delete Operations
    
    // MARK: Delete Image Query URL Model
    func deleteImageQueryURLModel(_ item: ImageQueryURLModel) throws {
        swiftDataManager.container.mainContext.delete(item)
        do {
            try swiftDataManager.saveContext()
        } catch {
            print(ImageQueryURLModelSwiftDataManagerErrorModel.imageQueryURLModelDeletionFailed(error).localizedDescription)
            throw error
        }
    }
}
