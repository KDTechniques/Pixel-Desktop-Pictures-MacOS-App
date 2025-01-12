//
//  ImageQueryURLModelManager.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-13.
//

import Foundation

actor ImageQueryURLModelManager {
    // MARK: - PROPERTIES
    static let shared: ImageQueryURLModelManager = .init()
    
    // MARK: - INITIALIZER
    private init() {}
    
    // MARK: INTERNAL FUNCTIONS
    
    // MARK: - Get Image Data
    func getImageData(item: ImageQueryURLModel, imageAPIReference: UnsplashImageAPIService) async throws -> UnsplashQueryImageSubModel {
        let nextImageDataIndex: Int = item.currentImageDataIndex == 0 ? 0 : item.currentImageDataIndex + 1
        
        let nextImageData: UnsplashQueryImageSubModel = try await checkNFetchNextQueryResultsSet(
            item: item,
            index: nextImageDataIndex,
            imageAPIReference: imageAPIReference
        )
        
        return nextImageData
    }
    
    // MARK: PRIVATE FUNCTIONS
    
    // MARK: - Check and Fetch Next Query Results Set
    private func checkNFetchNextQueryResultsSet(item: ImageQueryURLModel, index: Int, imageAPIReference: UnsplashImageAPIService) async throws -> UnsplashQueryImageSubModel {
        let queryResultsArray: UnsplashQueryImageModel = try item.getQueryResultsArray()
        
        guard !queryResultsArray.results.indices.contains(index) else {
            let nextImageData: UnsplashQueryImageSubModel = queryResultsArray.results[index]
            return nextImageData
        }
        
        let newPageNumber: Int = item.pageNumber + 1
        let newQueryResultsArray: UnsplashQueryImageModel = try await imageAPIReference.getQueryImageModel(queryText: item.queryText, pageNumber: newPageNumber)
        let newQueryResultsDataArray: Data = try JSONEncoder().encode(newQueryResultsArray)
        
        item.queryResultsArray = newQueryResultsArray
        item.queryResultsDataArray = newQueryResultsDataArray
        item.pageNumber = newPageNumber
        item.currentImageDataIndex = 0
        
        let nextImageData: UnsplashQueryImageSubModel = try await checkNFetchNextQueryResultsSet(item: item, index: 0, imageAPIReference: imageAPIReference)
        
        return nextImageData
    }
}
