//
//  QueryImageManager.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-13.
//

import Foundation

/**
 A thread-safe actor responsible for managing `QueryImage` entities and their associated operations.
 It provides methods for adding, fetching, and retrieving `QueryImage` items, as well as handling pagination and image retrieval.
 This actor ensures that all operations are performed in a thread-safe manner, leveraging Swift's concurrency model.
 */
actor QueryImageManager {
    // MARK: - SINGLETON
    private static var singleton: QueryImageManager?
    
    // MARK: - PROPERTIES
    let localDatabaseManager: QueryImageLocalDatabaseManager
    
    // MARK: - INITIALIZER
    private init(localDatabaseManager: QueryImageLocalDatabaseManager) {
        self.localDatabaseManager = localDatabaseManager
    }
    
    // MARK: - INTERNAL FUNCTIONS
    
    /// Returns a shared singleton instance of `QueryImageManager`.
    /// - Parameter localDatabaseManager: An instance of `QueryImageLocalDatabaseManager` to manage local database operations.
    /// - Returns: The shared `QueryImageManager` instance.
    static func shared(localDatabaseManager: QueryImageLocalDatabaseManager) -> QueryImageManager {
        guard singleton == nil else {
            return singleton!
        }
        
        let newInstance: Self = .init(localDatabaseManager: localDatabaseManager)
        singleton = newInstance
        return newInstance
    }
    
    // MARK: - Create Operations
    
    /// Adds a list of `QueryImage` items to the local database.
    /// - Parameter newItems: An array of `QueryImage` objects to be added to the database.
    /// - Throws: An error if the operation fails, such as if the context cannot be saved.
    func addQueryImages(_ newItems: [QueryImage]) async throws {
        try await localDatabaseManager.addQueryImages(newItems)
    }
    
    // MARK: - Read Operations
    
    /// Fetches `QueryImage` items from the local database for the specified collection names.
    /// - Parameter collectionNames: An array of collection names (queries) to filter the `QueryImage` items.
    /// - Returns: An array of `QueryImage` objects that match the specified collection names.
    /// - Throws: An error if the operation fails, such as if the fetch request cannot be executed.
    func fetchQueryImages(for collectionNames: [String]) async throws -> [QueryImage] {
        try await localDatabaseManager.fetchQueryImages(for: collectionNames)
    }
    
    /// Retrieves the next or current `UnsplashQueryImage` for a given `QueryImage` item.
    /// - Parameters:
    ///   - item: The `QueryImage` object for which to retrieve the image.
    ///   - isCurrentImage: A boolean indicating whether to retrieve the current image or the next image.
    ///   - imageAPIService: The service used to fetch new image data from the API.
    /// - Returns: An `UnsplashQueryImage` object representing the next or current image.
    /// - Throws: An error if the operation fails, such as if the API request fails or the data cannot be decoded.
    func getQueryImage(item: QueryImage, isCurrentImage: Bool = false, imageAPIService: UnsplashImageAPIService) async throws -> UnsplashQueryImage {
        let nextImageIndex: Int = isCurrentImage ? item.currentImageIndex : item.currentImageIndex + 1
        
        let nextQueryImage: UnsplashQueryImage = try await checkNFetchNextQueryImage(
            item: item,
            index: nextImageIndex,
            imageAPIService: imageAPIService
        )
        
        return nextQueryImage
    }
    
    // MARK: - PRIVATE FUNCTIONS
    
    /// Decodes and retrieves the `UnsplashQueryImages` data for a given `QueryImage` item.
    /// - Parameter item: The `QueryImage` object for which to retrieve the encoded images.
    /// - Returns: An `UnsplashQueryImages` object containing the decoded image data.
    /// - Throws: An error if the operation fails, such as if the data cannot be decoded.
    private func getQueryImages(item: QueryImage) async throws -> UnsplashQueryImages {
        let queryImages: UnsplashQueryImages =  try JSONDecoder()
            .decode(
                UnsplashQueryImages.self,
                from: item.queryImagesEncoded
            )
        
        return queryImages
    }
    
    /// Checks if the next image exists in the current query results or fetches new results from the API if necessary.
    /// - Parameters:
    ///   - item: The `QueryImage` object for which to retrieve the next image.
    ///   - index: The index of the next image to retrieve.
    ///   - imageAPIService: The service used to fetch new image data from the API.
    /// - Returns: An `UnsplashQueryImage` object representing the next image.
    /// - Throws: An error if the operation fails, such as if the API request fails or the data cannot be decoded.
    private func checkNFetchNextQueryImage(
        item: QueryImage,
        index: Int,
        imageAPIService: UnsplashImageAPIService
    ) async throws -> UnsplashQueryImage {
        let queryImages: UnsplashQueryImages = try await getQueryImages(item: item)
        
        // Handle case when query results array doesn't contain the next index.
        guard !queryImages.results.indices.contains(index) else {
            // If query results contains the next index, return the next query image item.
            let nextQueryImage: UnsplashQueryImage = queryImages.results[index]
            item.currentImageIndex = index
            try await localDatabaseManager.updateQueryImages()
            
            return nextQueryImage
        }
        
        // Increment the page number and get the next results set and then set the current index to 0.
        var newPageNumber: Int = item.pageNumber + 1
        var newQueryImages: UnsplashQueryImages = try await imageAPIService.getQueryImages(
            query: item.query,
            pageNumber: newPageNumber
        )
        
        // If the fetched results are empty, and resource is unavailable, start the collection from very beginning by setting page number to 1.
        if newQueryImages.results.isEmpty {
            let tempNewPageNumber: Int = 1
            let tempNewQueryImages: UnsplashQueryImages = try await imageAPIService.getQueryImages(
                query: item.query,
                pageNumber: tempNewPageNumber
            )
            
            newPageNumber = tempNewPageNumber
            newQueryImages = tempNewQueryImages
        }
        
        let newQueryImagesEncoded: Data = try JSONEncoder().encode(newQueryImages)
        
        item.queryImagesEncoded = newQueryImagesEncoded
        item.pageNumber = newPageNumber
        item.currentImageIndex = 0
        
        let nextImageData: UnsplashQueryImage = try await checkNFetchNextQueryImage(
            item: item,
            index: 0,
            imageAPIService: imageAPIService
        )
        
        try await localDatabaseManager.updateQueryImages()
        
        return nextImageData
    }
}
