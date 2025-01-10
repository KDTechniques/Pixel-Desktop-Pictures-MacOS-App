//
//  CollectionItemModel.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-08.
//

import Foundation
import SwiftData

fileprivate let randomKeyword: String = "RANDOM"

@Model
class CollectionItemModel {
    // MARK: - PROPERTIES
    @Attribute(.unique) private(set) var collectionName: String
    private(set) var pageNumber: Int = 1
    private(set) var isSelected: Bool
    private(set) var isEditable: Bool
    private var imageURLs: Data
    static let randomKeywordString: String = randomKeyword
    
    // MARK: - INITIALIZER
    init(collectionName: String, imageURLs: UnsplashImageURLsModel, isSelected: Bool = false, isEditable: Bool = true) throws {
        self.imageURLs = try JSONEncoder().encode(imageURLs)
        self.collectionName = collectionName == randomKeyword ? collectionName : collectionName.capitalized
        self.isSelected = isSelected
        self.isEditable = isEditable
    }
    
    // MARK: INTERNAL FUNCTIONS
    
    // MARK: - Get Image URLs
    func getImageURLs() throws -> UnsplashImageURLsModel {
        var imageURLs: UnsplashImageURLsModel = try JSONDecoder().decode(UnsplashImageURLsModel.self, from: imageURLs)
        let updatedThumbURL: String = imageURLs.thumb.replacingOccurrences( // Note: If this 50 width has no impact on UX, remove this line
            of: "(?<=\\b)w=200(?=&|$)",
            with: "w=50",
            options: .regularExpression
        )
        imageURLs.thumb = updatedThumbURL
        return imageURLs
    }
    
    // MARK: - Rename Collection Name
    func renameCollectionName(newCollectionName: String, imageAPIServiceReference: UnsplashImageAPIService) async throws {
        collectionName = newCollectionName.capitalized
        pageNumber = 0
        try await updateImageURLString(imageAPIServiceReference: imageAPIServiceReference)
    }
    
    // MARK: - Update Image URL String
    func updateImageURLString(imageAPIServiceReference: UnsplashImageAPIService) async throws {
        let nextPageNumber:Int = pageNumber + 1
        let nextQueryImageURLModel: UnsplashQueryImageModel = try await imageAPIServiceReference.getQueryImageModel(queryText: collectionName.capitalized, pageNumber: nextPageNumber, imagesPerPage: 1)
        guard let newImageURLs: UnsplashImageURLsModel = nextQueryImageURLModel.results.first?.imageQualityURLStrings else {
            throw URLError(.badServerResponse)
        }
        
        try setImageURLs(newImageURLs)
        pageNumber = nextPageNumber
    }
    
    // MARK: - Update IsSelected State
    func updateIsSelected(_ boolean: Bool) {
        guard isSelected != boolean else { return }
        isSelected = boolean
    }
    
    // MARK: PRIVATE FUNCTIONS
    
    // MARK: - Set Image URLs
    private func setImageURLs(_ imageURLs: UnsplashImageURLsModel) throws {
        let imageURLsData: Data = try JSONEncoder().encode(imageURLs)
        self.imageURLs = imageURLsData
    }
}
