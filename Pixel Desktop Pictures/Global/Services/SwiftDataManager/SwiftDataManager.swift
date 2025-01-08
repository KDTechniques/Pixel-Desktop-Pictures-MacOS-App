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
                for: ImageQueryURLModel.self, RecentImageURLModel.self,
                configurations: .init(isStoredInMemoryOnly: appEnvironment == .mock)
            )
            print("Swift Data Manager is initialized!")
        } catch {
            let error: SwiftDataManagerErrorModel = .modelContainerInitializationFailed(error)
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
    func addRecentImageURLModel(downloadedDate: Date, imageURLString: String) throws {
        let newObject: RecentImageURLModel = .init(downloadedDate: downloadedDate, imageURLString: imageURLString)
        container.mainContext.insert(newObject)
        
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
    func updateRecentImageURLModel(_ recentImage: RecentImageURLModel, newDownloadedDate: Date, newImageURLString: String) throws {
        recentImage.downloadedDate = newDownloadedDate
        recentImage.imageURLString = newImageURLString
        do {
            try saveContext()
        } catch {
            let error: SwiftDataManagerErrorModel = .recentImageURLModelUpdateFailed(error)
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
