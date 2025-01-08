//
//  SwiftDataManager.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-08.
//

import Foundation
import SwiftData
import SwiftUI

@MainActor
@Observable final class SwiftDataManager {
    // MARK: - PROPERTIES
    private var container: ModelContainer
    
    // MARK: - INITIALIZER
    init(appEnvironment: AppEnvironmentModel) throws {
        do {
            container = try ModelContainer(
                for: ImageQueryURLModel.self, RecentImageURLModel.self, CollectionItemModel.self,
                configurations: .init(isStoredInMemoryOnly: appEnvironment == .mock)
            )
            print("Swift Data Manager is initialized!")
        } catch {
            let error: SwiftDataManagerErrorModel = .collectionItemModelCreationFailed(error)
            print(error.localizedDescription)
            throw error
        }
    }
    
    // MARK: FUNCTIONS
    
    // MARK: INTERNAL FUNCTIONS
    
    // MARK: - Create Operations
    
    // MARK: Add Image Query URL Model
    func addImageQueryURLModel(queryText: String, pageNumber: Int, imageDataArray: UnsplashQueryImageModel) throws {
        do {
            let imageData: Data = try JSONEncoder().encode(imageDataArray)
            let newObject: ImageQueryURLModel = .init(queryText: queryText, pageNumber: pageNumber, imageDataArray: imageData)
            container.mainContext.insert(newObject)
            try saveContext()
        } catch {
            let error: SwiftDataManagerErrorModel = .imageQueryURLModelCreationFailed(error)
            print(error.localizedDescription)
            throw error
        }
    }
    
    // MARK: Add Recent Image URL Model
    func addRecentImageURLModel(_ object: RecentImageURLModel) throws {
        container.mainContext.insert(object)
        
        do {
            try saveContext()
        } catch {
            let error: SwiftDataManagerErrorModel = .recentImageURLModelCreationFailed(error)
            print(error.localizedDescription)
            throw error
        }
    }
    
    // MARK: Add Collection Item Model
    func addCollectionItemModel(_ object: CollectionItemModel) throws {
        container.mainContext.insert(object)
        
        do {
            try saveContext()
        } catch {
            let error: SwiftDataManagerErrorModel = .recentImageURLModelCreationFailed(error)
            print(error.localizedDescription)
            throw error
        }
    }
    
    // MARK: - Read Operations
    
    // MARK: Fetch Image Query URL Models Array
    func fetchImageQueryURLModelsArray() throws -> [ImageQueryURLModel] {
        do {
            let imageQueryURLModelsArray: [ImageQueryURLModel] = try container.mainContext.fetch(FetchDescriptor<ImageQueryURLModel>())
            return imageQueryURLModelsArray
        } catch {
            let error: SwiftDataManagerErrorModel = .imageQueryURLModelsArrayFetchFailed(error)
            print(error.localizedDescription)
            throw error
        }
    }
    
    // MARK: Fetch Recent Image URL Models Array
    func fetchRecentImageURLModelsArray() throws -> [RecentImageURLModel] {
        do {
            let recentImageURLModelsArray: [RecentImageURLModel] = try container.mainContext.fetch(FetchDescriptor<RecentImageURLModel>())
            return recentImageURLModelsArray
        } catch {
            let error: SwiftDataManagerErrorModel = .recentImageURLModelsArrayFetchFailed(error)
            print(error.localizedDescription)
            throw error
        }
    }
    
    // MARK: Fetch Collection Item Models Array
    func fetchCollectionItemModelsArray() throws -> [CollectionItemModel] {
        do {
            let collectionItemModelsArray: [CollectionItemModel] = try container.mainContext.fetch(FetchDescriptor<CollectionItemModel>())
            return collectionItemModelsArray
        } catch {
            let error: SwiftDataManagerErrorModel = .collectionItemModelsArrayFetchFailed(error)
            print(error.localizedDescription)
            throw error
        }
    }
    
    // MARK: - Update Operations
    
    // MARK: Update Image Query URL Model
    func updateImageQueryURLModel(_ imageQuery: ImageQueryURLModel, newQueryText: String, newPageNumber: Int, newImageDataArray: UnsplashQueryImageModel) throws {
        do {
            let imageDataArray: Data = try JSONEncoder().encode(newImageDataArray)
            imageQuery.queryText = newQueryText
            imageQuery.pageNumber = newPageNumber
            imageQuery.imageDataArray = imageDataArray
            try saveContext()
        } catch {
            let error: SwiftDataManagerErrorModel = .imageQueryURLModelUpdateFailed(error)
            print(error.localizedDescription)
            throw error
        }
    }
    
    // MARK: Update Recent Image URL Model
    func updateRecentImageURLModel(_ recentImage: RecentImageURLModel, newValues: RecentImageURLModel) throws {
        recentImage.downloadedDate = newValues.downloadedDate
        recentImage.imageURLString = newValues.imageURLString
        
        do {
            try saveContext()
        } catch {
            let error: SwiftDataManagerErrorModel = .recentImageURLModelUpdateFailed(error)
            print(error.localizedDescription)
            throw error
        }
    }
    
    // MARK: Update Collection Item Model
    func updateCollectionItemModel(_ collectionItem: CollectionItemModel, isSelected: Bool?, imageAPIServiceReference: UnsplashImageAPIService?) async throws {
        if let isSelected { collectionItem.updateIsSelected(isSelected) }
        
        do {
            if let imageAPIServiceReference {
                try await collectionItem.updateImageURLString(imageAPIServiceReference: imageAPIServiceReference)
            }
            try saveContext()
        } catch {
            let error: SwiftDataManagerErrorModel = .collectionItemModelUpdateFailed(error)
            print(error.localizedDescription)
            throw error
        }
    }
    
    // MARK: - Delete Operations
    
    // MARK: Delete Image Query URL Model
    func deleteImageQueryURLModel(_ imageQuery: ImageQueryURLModel) throws {
        container.mainContext.delete(imageQuery)
        do {
            try saveContext()
        } catch {
            let error: SwiftDataManagerErrorModel = .imageQueryURLModelDeletionFailed(error)
            print(error.localizedDescription)
            throw error
        }
    }
    
    // MARK: Delete Recent Image URL Model
    func deleteRecentImageURLModel(_ recentImage: RecentImageURLModel) throws {
        container.mainContext.delete(recentImage)
        do {
            try saveContext()
        } catch {
            let error: SwiftDataManagerErrorModel = .recentImageURLModelDeletionFailed(error)
            print(error.localizedDescription)
            throw error
        }
    }
    
    // MARK: Delete Recent Image URL Model
    func deleteCollectionItemModel(_ collectionItem: CollectionItemModel) throws {
        container.mainContext.delete(collectionItem)
        do {
            try saveContext()
        } catch {
            let error: SwiftDataManagerErrorModel = .collectionItemModelDeletionFailed(error)
            print(error.localizedDescription)
            throw error
        }
    }
    
#if DEBUG
    func eraseAllData() {
        do {
            try container.erase()
        } catch {
            print("Error: Erasing all the swift data from container. \(error.localizedDescription)")
        }
    }
#endif
    
    // MARK: PRIVATE FUNCTIONS
    
    // MARK: - Save Context
    private func saveContext() throws {
        do {
            try container.mainContext.save()
        } catch {
            // Rollback changes to the context if saving fails
            container.mainContext.rollback() // Rollback any unsaved changes
            
            let error: SwiftDataManagerErrorModel = .contextSaveFailed(error)
            print(error.localizedDescription)
            throw error
        }
    }
}
