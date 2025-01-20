//
//  CollectionManager.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-13.
//

import Foundation

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
    
    func addCollections(_ newItems: [Collection]) async throws {
        try await localDatabaseManager.addCollections(newItems)
    }
    
    // MARK: - Read Operations
    
    func getCollections() async throws -> [Collection] {
        let collections: [Collection] = try await localDatabaseManager.fetchCollections()
        return collections
    }
    
    func getImageURLs(from item: Collection) async throws -> UnsplashImageResolution {
        var imageURLs: UnsplashImageResolution = try JSONDecoder().decode(UnsplashImageResolution.self, from: item.imageQualityURLStringsEncoded)
        let updatedThumbURL: String = imageURLs.thumb.replacingOccurrences( // Note: If this 50 width has no impact on UX, remove this line
            of: "(?<=\\b)w=200(?=&|$)",
            with: "w=50",
            options: .regularExpression
        )
        imageURLs.thumb = updatedThumbURL
        return imageURLs
    }
    
    // MARK: - Update Operations
    func updateCollections() async throws {
        try await localDatabaseManager.updateCollection()
    }
    
    func rename(for item: Collection, newName: String, imageQualityURLStringsEncoded: Data) async throws {
        item.name = newName.capitalized
        item.pageNumber = 1
        item.imageQualityURLStringsEncoded = imageQualityURLStringsEncoded
        try await localDatabaseManager.updateCollection()
    }
    
    func updateImageQualityURLStrings(for item: Collection, imageAPIService: UnsplashImageAPIService) async throws {
        let nextPageNumber:Int = item.pageNumber + 1
        
        let nextQueryImages: UnsplashQueryImages = try await imageAPIService.getQueryImages(query: item.name.capitalized, pageNumber: nextPageNumber, imagesPerPage: 1)
        
        guard let newImageURLs: UnsplashImageResolution = nextQueryImages.results.first?.imageQualityURLStrings else {
            throw URLError(.badServerResponse)
        }
        
        try await setImageURLs(for: item, with: newImageURLs)
        item.pageNumber = nextPageNumber
        try await localDatabaseManager.updateCollection()
    }
    
    func updateSelection(for item: Collection, with boolean: Bool) async throws {
        guard item.isSelected != boolean else { return }
        item.isSelected = boolean
        try await localDatabaseManager.updateCollection()
    }
    
    func updateSelection(for items: [Collection], except: Collection) async throws {
        for item in items {
            guard item.isSelected != false else { continue }
            item.isSelected = false
        }
        
        except.isSelected = true
        
        try await localDatabaseManager.updateCollection()
    }
    
    // MARK: - Delete Operations
    
    func deleteCollection(at item: Collection) async throws {
        try await localDatabaseManager.deleteCollection(at: item)
    }
    
    // MARK: - PRIVATE FUNCTIONS
    
    private func setImageURLs(for item: Collection, with imageURLs: UnsplashImageResolution) async throws {
        let imageURLsData: Data = try JSONEncoder().encode(imageURLs)
        item.imageQualityURLStringsEncoded = imageURLsData
    }
}
