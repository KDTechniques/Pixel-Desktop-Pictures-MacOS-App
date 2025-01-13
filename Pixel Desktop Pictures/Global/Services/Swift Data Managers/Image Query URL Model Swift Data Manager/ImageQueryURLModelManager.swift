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
    func getImageData(
        item: ImageQueryURLModel,
        imageAPIReference: UnsplashImageAPIService,
        swiftDataManager: SwiftDataManager
    ) async throws -> UnsplashQueryImageSubModel {
        let nextImageDataIndex: Int = item.currentImageDataIndex == 0 ? 0 : item.currentImageDataIndex + 1
        
        let nextImageData: UnsplashQueryImageSubModel = try await checkNFetchNextQueryResultsSet(
            item: item,
            index: nextImageDataIndex,
            imageAPIReference: imageAPIReference,
            swiftDataManager: swiftDataManager
        )
        
        return nextImageData
    }
    
    // MARK: PRIVATE FUNCTIONS
    
    // MARK: - Get Query Results Array
    private func getQueryResultsArray(item: ImageQueryURLModel) async throws -> UnsplashQueryImageModel {
        guard let queryResultsArray: UnsplashQueryImageModel = item.queryResultsArray else {
            let queryResultsArray: UnsplashQueryImageModel =  try JSONDecoder().decode(
                UnsplashQueryImageModel.self,
                from: item.queryResultsDataArray
            )
            return queryResultsArray
        }
        
        return queryResultsArray
    }
    
    // MARK: - Check and Fetch Next Query Results Set
    private func checkNFetchNextQueryResultsSet(
        item: ImageQueryURLModel,
        index: Int,
        imageAPIReference: UnsplashImageAPIService,
        swiftDataManager: SwiftDataManager
    ) async throws -> UnsplashQueryImageSubModel {
        let queryResultsArray: UnsplashQueryImageModel = try await getQueryResultsArray(item: item)
        
        guard !queryResultsArray.results.indices.contains(index) else {
            let nextImageData: UnsplashQueryImageSubModel = queryResultsArray.results[index]
            return nextImageData
        }
        
        let newPageNumber: Int = item.pageNumber + 1
        let newQueryResultsArray: UnsplashQueryImageModel = try await imageAPIReference.getQueryImageModel(
            queryText: item.queryText,
            pageNumber: newPageNumber
        )
        let newQueryResultsDataArray: Data = try JSONEncoder().encode(newQueryResultsArray)
        
        item.queryResultsArray = newQueryResultsArray
        item.queryResultsDataArray = newQueryResultsDataArray
        item.pageNumber = newPageNumber
        item.currentImageDataIndex = 0
        
        let nextImageData: UnsplashQueryImageSubModel = try await checkNFetchNextQueryResultsSet(
            item: item,
            index: 0,
            imageAPIReference: imageAPIReference,
            swiftDataManager: swiftDataManager
        )
        
        try await swiftDataManager.saveContext()
        
        return nextImageData
    }
}
