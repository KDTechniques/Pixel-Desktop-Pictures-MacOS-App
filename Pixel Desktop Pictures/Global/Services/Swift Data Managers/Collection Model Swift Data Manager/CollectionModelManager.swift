//
//  CollectionModelManager.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-13.
//

import Foundation

actor CollectionModelManager {
    // MARK: - PROPERTIES
    static let shared: CollectionModelManager = .init()
    
    // MARK: - INITIALIZER
    private init() {}
    
    // MARK: FUNCTIONS
    
    // MARK: INTERNAL FUNCTIONS
    
    // MARK: - Get Image URLs
    func getImageURLs(from item: CollectionModel) async throws -> UnsplashImageURLsModel {
        var imageURLs: UnsplashImageURLsModel = try JSONDecoder().decode(UnsplashImageURLsModel.self, from: item.imageURLsData)
        let updatedThumbURL: String = imageURLs.thumb.replacingOccurrences( // Note: If this 50 width has no impact on UX, remove this line
            of: "(?<=\\b)w=200(?=&|$)",
            with: "w=50",
            options: .regularExpression
        )
        imageURLs.thumb = updatedThumbURL
        return imageURLs
    }
    
    // MARK: - Rename Collection Name
    func renameCollectionName(for item: CollectionModel, newCollectionName: String, imageAPIServiceReference: UnsplashImageAPIService) async throws {
        item.collectionName = newCollectionName.capitalized
        item.pageNumber = 0
        try await updateImageURLString(in: item, imageAPIServiceReference: imageAPIServiceReference)
    }
    
    // MARK: - Update Image URL String
    func updateImageURLString(in item: CollectionModel, imageAPIServiceReference: UnsplashImageAPIService) async throws {
        let nextPageNumber:Int = item.pageNumber + 1
        let nextQueryImageURLModel: UnsplashQueryImageModel = try await imageAPIServiceReference.getQueryImageModel(queryText: item.collectionName.capitalized, pageNumber: nextPageNumber, imagesPerPage: 1)
        guard let newImageURLs: UnsplashImageURLsModel = nextQueryImageURLModel.results.first?.imageQualityURLStrings else {
            throw URLError(.badServerResponse)
        }
        
        try await setImageURLs(for: item, with: newImageURLs)
        item.pageNumber = nextPageNumber
    }
    
    // MARK: - Update IsSelected State
    func updateIsSelected(in item: CollectionModel, with boolean: Bool) async throws {
        guard item.isSelected != boolean else { return }
        item.isSelected = boolean
    }
    
    // MARK: PRIVATE FUNCTIONS
    
    // MARK: - Set Image URLs
    private func setImageURLs(for item: CollectionModel, with imageURLs: UnsplashImageURLsModel) async throws {
        let imageURLsData: Data = try JSONEncoder().encode(imageURLs)
        item.imageURLsData = imageURLsData
    }
}
