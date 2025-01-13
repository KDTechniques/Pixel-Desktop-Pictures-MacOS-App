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
    @Attribute(.unique) private(set) var queryText: String // Ex: Nature
    var pageNumber: Int = 1 // Ex: 3
    var queryResultsDataArray: Data // Encoded `UnsplashQueryImageModel`
    var currentImageDataIndex: Int = 0
    
    @Transient var queryResultsArray: UnsplashQueryImageModel?
    
    // MARK: - INITIALIZER
    init(queryText: String, queryResultsDataArray: Data) {
        self.queryResultsDataArray = queryResultsDataArray
        self.queryText = queryText.capitalized
    }
}
