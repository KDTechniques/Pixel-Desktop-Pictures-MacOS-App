//
//  CollectionManager.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-13.
//

import Foundation

/**
 A thread-safe actor responsible for managing collections of images and their associated metadata.
 It provides methods for adding, fetching, updating, and deleting collections, as well as managing image URLs and selection states.
 This actor ensures that all operations are performed in a thread-safe manner, leveraging Swift's concurrency model.
 */
actor CollectionManager {
    // MARK: - SINGLETON
    private static var singleton: CollectionManager?
    
    // MARK: - PROPERTIES
    let localDatabaseManager: CollectionLocalDatabaseManager
    
    // MARK: - INITIALIZER
    private init(localDatabaseManager: CollectionLocalDatabaseManager) {
        self.localDatabaseManager = localDatabaseManager
    }
    
    // MARK: - INTERNAL FUNCTIONS
    
    static func shared(localDatabaseManager: CollectionLocalDatabaseManager) -> CollectionManager {
        guard singleton == nil else {
            return singleton!
        }
        
        let newInstance: Self = .init(localDatabaseManager: localDatabaseManager)
        singleton = newInstance
        return newInstance
    }
    
    // MARK: - Create Operations
    
    /// Adds a list of `Collection` items to the local database.
    /// - Parameter newItems: An array of `Collection` objects to be added to the database.
    /// - Throws: An error if the operation fails, such as if the context cannot be saved.
    func addCollections(_ newItems: [Collection]) async throws {
        try await localDatabaseManager.addCollections(newItems)
    }
    
    // MARK: - Read Operations
    
    /// Fetches all `Collection` items from the local database.
    /// - Returns: An array of `Collection` objects fetched from the database.
    /// - Throws: An error if the operation fails, such as if the fetch request cannot be executed.
    func getCollections() async throws -> [Collection] {
        let collections: [Collection] = try await localDatabaseManager.fetchCollections()
        return collections
    }
    
    /// Retrieves the image URLs for a specific `Collection` item.
    /// - Parameter item: The `Collection` object for which to retrieve image URLs.
    /// - Returns: An `UnsplashImageResolution` object containing the image URLs.
    /// - Throws: An error if the operation fails, such as if the data cannot be decoded.
    func getImageURLs(from item: Collection) async throws -> UnsplashImageResolution {
        let imageURLs: UnsplashImageResolution = try JSONDecoder().decode(UnsplashImageResolution.self, from: item.imageQualityURLStringsEncoded)
        return imageURLs
    }
    
    // MARK: - Update Operations
    
    /// Saves any changes made to the `Collection` items in the local database.
    /// - Throws: An error if the operation fails, such as if the context cannot be saved.
    func updateCollections() async throws {
        try await localDatabaseManager.updateCollection()
    }
    
    /// Renames a specific `Collection` item and updates its metadata.
    /// - Parameters:
    ///   - item: The `Collection` object to be renamed.
    ///   - newName: The new name for the collection.
    ///   - imageQualityURLStringsEncoded: The encoded image URLs associated with the collection.
    /// - Throws: An error if the operation fails, such as if the context cannot be saved.
    func rename(for item: Collection, newName: String, imageQualityURLStringsEncoded: Data) async throws {
        item.name = newName.capitalized
        item.pageNumber = 1
        item.imageQualityURLStringsEncoded = imageQualityURLStringsEncoded
        try await localDatabaseManager.updateCollection()
    }
    
    /// Updates the image quality URLs for a specific `Collection` item by fetching new URLs from the API.
    /// - Parameters:
    ///   - item: The `Collection` object to be updated.
    ///   - imageAPIService: The service used to fetch new image URLs from the API.
    /// - Throws: An error if the operation fails, such as if the API request fails or the context cannot be saved.
    func updateImageQualityURLStrings(for item: Collection, imageAPIService: UnsplashImageAPIService) async throws {
        let nextPageNumber:Int = item.pageNumber + 1
        
        let nextQueryImages: UnsplashQueryImages = try await imageAPIService.getQueryImages(query: item.name.capitalized, pageNumber: nextPageNumber, imagesPerPage: 1)
        
        guard let newImageURLs: UnsplashImageResolution = nextQueryImages.results.first?.imageQualityURLStrings else {
            throw URLError(.badServerResponse)
        }
        
        try await setEncodedImageURLs(for: item, with: newImageURLs)
        item.pageNumber = nextPageNumber
        try await localDatabaseManager.updateCollection()
    }
    
    /// Updates the selection state of a specific `Collection` item.
    /// - Parameters:
    ///   - item: The `Collection` object to be updated.
    ///   - boolean: The new selection state (`true` for selected, `false` for unselected).
    /// - Throws: An error if the operation fails, such as if the context cannot be saved.
    func updateSelection(for item: Collection, with boolean: Bool) async throws {
        guard item.isSelected != boolean else { return }
        item.isSelected = boolean
        try await localDatabaseManager.updateCollection()
    }
    
    /// Updates the selection state of multiple `Collection` items, ensuring only one item is selected.
    /// - Parameters:
    ///   - items: An array of `Collection` objects to be updated.
    ///   - except: The `Collection` object that should remain selected.
    /// - Throws: An error if the operation fails, such as if the context cannot be saved.
    func updateSelection(for items: [Collection], except: Collection) async throws {
        for item in items {
            guard item.isSelected != false else { continue }
            item.isSelected = false
        }
        
        except.isSelected = true
        
        try await localDatabaseManager.updateCollection()
    }
    
    // MARK: - Delete Operations
    
    /// Deletes a specific `Collection` item from the local database.
    /// - Parameter item: The `Collection` object to be deleted.
    /// - Throws: An error if the operation fails, such as if the context cannot be saved after deletion.
    func deleteCollection(at item: Collection) async throws {
        try await localDatabaseManager.deleteCollection(at: item)
    }
    
    // MARK: - PRIVATE FUNCTIONS
    
    /// Encodes and sets the image URLs for a specific `Collection` item.
    /// - Parameters:
    ///   - item: The `Collection` object to be updated.
    ///   - imageURLs: The `UnsplashImageResolution` object containing the image URLs.
    /// - Throws: An error if the operation fails, such as if the data cannot be encoded.
    private func setEncodedImageURLs(for item: Collection, with imageURLs: UnsplashImageResolution) async throws {
        let imageURLsData: Data = try JSONEncoder().encode(imageURLs)
        item.imageQualityURLStringsEncoded = imageURLsData
    }
}
