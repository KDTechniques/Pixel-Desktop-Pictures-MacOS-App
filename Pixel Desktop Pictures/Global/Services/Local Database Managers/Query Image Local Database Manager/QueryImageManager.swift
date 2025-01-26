//
//  QueryImageManager.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-13.
//

import Foundation

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
    
    static func shared(localDatabaseManager: QueryImageLocalDatabaseManager) -> QueryImageManager {
        guard singleton == nil else {
            return singleton!
        }
        
        let newInstance: Self = .init(localDatabaseManager: localDatabaseManager)
        singleton = newInstance
        return newInstance
    }
    
    // MARK: - Create Operations
    
    func addQueryImages(_ newItems: [QueryImage]) async throws {
        try await localDatabaseManager.addQueryImages(newItems)
    }
    
    // MARK: - Read Operations
    
    func fetchQueryImages(for collectionNames: [String]) async throws -> [QueryImage] {
        try await localDatabaseManager.fetchQueryImages(for: collectionNames)
    }
    
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
    
    private func getQueryImages(item: QueryImage) async throws -> UnsplashQueryImages {
        let queryImages: UnsplashQueryImages =  try JSONDecoder()
            .decode(
                UnsplashQueryImages.self,
                from: item.queryImagesEncoded
            )
        
        return queryImages
    }
    
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
