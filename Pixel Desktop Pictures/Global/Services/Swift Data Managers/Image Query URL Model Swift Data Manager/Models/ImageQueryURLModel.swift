//
//  ImageQueryURLModel.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-08.
//

import Foundation
import SwiftData

@Model
final class ImageQueryURLModel {
    // MARK: - PROPERTIES
    @Attribute(.unique) private(set) var queryText: String // EX: Nature
    var pageNumber: Int = 1 // Ex: 3
    var queryResultsDataArray: Data
    var currentImageDataIndex: Int = 0
    
    @Transient var queryResultsArray: UnsplashQueryImageModel?
    
    // MARK: - INITIALIZER
    init(queryText: String, queryResultsArray: UnsplashQueryImageModel) throws {
        self.queryResultsDataArray =  try JSONEncoder().encode(queryResultsArray)
        self.queryText = queryText
    }
    
    // MARK: FUNCTIONS
    
    // MARK: - Get Query Results Array
    func getQueryResultsArray() throws -> UnsplashQueryImageModel {
        guard let queryResultsArray else {
            let queryResultsArray: UnsplashQueryImageModel =  try JSONDecoder().decode(
                UnsplashQueryImageModel.self,
                from: queryResultsDataArray
            )
            return queryResultsArray
        }
        
        return queryResultsArray
    }
}
