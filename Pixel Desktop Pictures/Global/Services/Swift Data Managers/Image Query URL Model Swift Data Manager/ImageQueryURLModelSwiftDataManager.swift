////
////  ImageQueryURLModelSwiftDataManager.swift
////  Pixel Desktop Pictures
////
////  Created by Kavinda Dilshan on 2025-01-11.
////
//
//import Foundation
//import SwiftData
//
//@MainActor
//final class ImageQueryURLModelSwiftDataManager {
//    // MARK: - PROPERTIES
//    let swiftDataManager: SwiftDataManager
//    
//    // MARK: - INITIALIZER
//    init(swiftDataManager: SwiftDataManager) {
//        self.swiftDataManager = swiftDataManager
//    }
//    
//    // MARK: FUNCTIONS
//    
//    // MARK: - Create Operations
//    
//    // MARK:  Add Image Query URL Model
//    /// Adds a new ImageQueryURLModel to the container and saves it to the context.
//    /// - Parameter queryText: The query text used for the image search.
//    /// - Parameter pageNumber: The page number for pagination in the image search.
//    /// - Parameter imageDataArray: The image data array that holds the fetched image data.
//    /// - Throws: Throws an error if the model creation or saving to context fails.
//    func addImageQueryURLModel(queryText: String, imageDataArray: UnsplashQueryImageModel) throws {
//        do {
//            let imageData: Data = try JSONEncoder().encode(imageDataArray)
//            let newObject: ImageQueryURLModel = .init(queryText: queryText, pageNumber: pageNumber, imageDataArray: imageData)
//            
//            swiftDataManager.container.mainContext.insert(newObject)
//            try swiftDataManager.saveContext()
//        } catch {
//            print(ImageQueryURLModelSwiftDataManagerErrorModel.imageQueryURLModelCreationFailed(error).localizedDescription)
//            throw error
//        }
//    }
//    
//    
//    // MARK: - Read Operations
//    
//    // MARK: Fetch Image Query URL Models Array
//    /// Fetches an array of ImageQueryURLModel from the swiftDataManager.container.
//    /// - Returns: An array of ImageQueryURLModel.
//    /// - Throws: Throws an error if fetching the models from the context fails.
//    func fetchImageQueryURLModelsArray() throws -> [ImageQueryURLModel] {
//        do {
//            let imageQueryURLModelsArray: [ImageQueryURLModel] = try swiftDataManager.container.mainContext.fetch(FetchDescriptor<ImageQueryURLModel>())
//            return imageQueryURLModelsArray
//        } catch {
//            print(ImageQueryURLModelSwiftDataManagerErrorModel.imageQueryURLModelsArrayFetchFailed(error).localizedDescription)
//            throw error
//        }
//    }
//    
//    // MARK: - Update Operations
//    
//    // MARK: Update Image Query URL Model
//    /// Updates an existing ImageQueryURLModel with new values and saves the changes to context.
//    /// - Parameters:
//    ///   - imageQuery: The ImageQueryURLModel instance to be updated.
//    ///   - newQueryText: The new query text to replace the existing one.
//    ///   - newPageNumber: The new page number to replace the existing one.
//    ///   - newImageDataArray: The new image data array to replace the existing one.
//    /// - Throws: Throws an error if updating the model or saving changes to context fails.
//    func updateImageQueryURLModel(_ item: ImageQueryURLModel,) throws {
//        do {
//            
//            try swiftDataManager.saveContext()
//        } catch {
//            print(ImageQueryURLModelSwiftDataManagerErrorModel.imageQueryURLModelUpdateFailed(error).localizedDescription)
//            throw error
//        }
//    }
//    
//    // MARK: - Delete Operations
//    
//    // MARK: Delete Image Query URL Model
//    /// Deletes an existing ImageQueryURLModel from the container and saves the changes to context.
//    /// - Parameter imageQuery: The ImageQueryURLModel instance to be deleted.
//    /// - Throws: Throws an error if deleting the model or saving changes to context fails.
//    func deleteImageQueryURLModel(_ imageQuery: ImageQueryURLModel) throws {
//        swiftDataManager.container.mainContext.delete(imageQuery)
//        do {
//            try swiftDataManager.saveContext()
//        } catch {
//            print(ImageQueryURLModelSwiftDataManagerErrorModel.imageQueryURLModelDeletionFailed(error).localizedDescription)
//            throw error
//        }
//    }
//}
