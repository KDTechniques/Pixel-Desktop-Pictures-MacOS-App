//
//  ImageQueryURLModelSwiftDataManager.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-11.
//

import Foundation
import SwiftData

@MainActor
@Observable
final class ImageQueryURLModelSwiftDataManager {
    // MARK: - PROPERTIES
    private var container: ModelContainer
    
    // MARK: - INITIALIZER
    /// Initializes the `ImageQueryURLModelSwiftDataManager` with the given app environment.
    /// - Parameter appEnvironment: The environment of the app, used to determine whether the container is stored in memory only or persists on disk.
    /// - Throws: Throws an error if the model container initialization fails.
    init(appEnvironment: AppEnvironmentModel) throws {
        do {
            container = try ModelContainer(
                for: ImageQueryURLModel.self,
                configurations: .init(isStoredInMemoryOnly: appEnvironment == .mock)
            )
            print("`Image Query URL Model Swift Data Manager` has been initialized!")
        } catch {
            print(ImageQueryURLModelSwiftDataManagerErrorModel.modelContainerInitializationFailed(error).localizedDescription)
            throw error
        }
    }
    
    // MARK: FUNCTIONS
    
    // MARK: INTERNAL FUNCTIONS
    
    // MARK: - Create Operations
    
    // MARK:  Add Image Query URL Model
    /// Adds a new ImageQueryURLModel to the container and saves it to the context.
    /// - Parameter queryText: The query text used for the image search.
    /// - Parameter pageNumber: The page number for pagination in the image search.
    /// - Parameter imageDataArray: The image data array that holds the fetched image data.
    /// - Throws: Throws an error if the model creation or saving to context fails.
    func addImageQueryURLModel(queryText: String, pageNumber: Int, imageDataArray: UnsplashQueryImageModel) throws {
        do {
            let imageData: Data = try JSONEncoder().encode(imageDataArray)
            let newObject: ImageQueryURLModel = .init(queryText: queryText, pageNumber: pageNumber, imageDataArray: imageData)
            
            container.mainContext.insert(newObject)
            try saveContext()
        } catch {
            print(ImageQueryURLModelSwiftDataManagerErrorModel.imageQueryURLModelCreationFailed(error).localizedDescription)
            throw error
        }
    }
    
    
    // MARK: - Read Operations
    
    // MARK: Fetch Image Query URL Models Array
    /// Fetches an array of ImageQueryURLModel from the container.
    /// - Returns: An array of ImageQueryURLModel.
    /// - Throws: Throws an error if fetching the models from the context fails.
    func fetchImageQueryURLModelsArray() throws -> [ImageQueryURLModel] {
        do {
            let imageQueryURLModelsArray: [ImageQueryURLModel] = try container.mainContext.fetch(FetchDescriptor<ImageQueryURLModel>())
            return imageQueryURLModelsArray
        } catch {
            print(ImageQueryURLModelSwiftDataManagerErrorModel.imageQueryURLModelsArrayFetchFailed(error).localizedDescription)
            throw error
        }
    }
    
    // MARK: - Update Operations
    
    // MARK: Update Image Query URL Model
    /// Updates an existing ImageQueryURLModel with new values and saves the changes to context.
    /// - Parameters:
    ///   - imageQuery: The ImageQueryURLModel instance to be updated.
    ///   - newQueryText: The new query text to replace the existing one.
    ///   - newPageNumber: The new page number to replace the existing one.
    ///   - newImageDataArray: The new image data array to replace the existing one.
    /// - Throws: Throws an error if updating the model or saving changes to context fails.
    func updateImageQueryURLModel(_ imageQuery: ImageQueryURLModel, newQueryText: String, newPageNumber: Int, newImageDataArray: UnsplashQueryImageModel) throws {
        do {
            let imageDataArray: Data = try JSONEncoder().encode(newImageDataArray)
            imageQuery.queryText = newQueryText
            imageQuery.pageNumber = newPageNumber
            imageQuery.imageDataArray = imageDataArray
            try saveContext()
        } catch {
            print(ImageQueryURLModelSwiftDataManagerErrorModel.imageQueryURLModelUpdateFailed(error).localizedDescription)
            throw error
        }
    }
    
    // MARK: - Delete Operations
    
    // MARK: Delete Image Query URL Model
    /// Deletes an existing ImageQueryURLModel from the container and saves the changes to context.
    /// - Parameter imageQuery: The ImageQueryURLModel instance to be deleted.
    /// - Throws: Throws an error if deleting the model or saving changes to context fails.
    func deleteImageQueryURLModel(_ imageQuery: ImageQueryURLModel) throws {
        container.mainContext.delete(imageQuery)
        do {
            try saveContext()
        } catch {
            print(ImageQueryURLModelSwiftDataManagerErrorModel.imageQueryURLModelDeletionFailed(error).localizedDescription)
            throw error
        }
    }
    
    // MARK: Erase All Data
    /// Erases all data stored in the `ImageQueryURLModel` container.
    /// - Throws: Throws an error if erasing data fails.
    func eraseAllData() throws {
        do {
            try container.erase()
        } catch {
            print(ImageQueryURLModelSwiftDataManagerErrorModel.eraseAllDataFailed(error).localizedDescription)
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
            print(ImageQueryURLModelSwiftDataManagerErrorModel.contextSaveFailed(error).localizedDescription)
            throw error
        }
    }
}
