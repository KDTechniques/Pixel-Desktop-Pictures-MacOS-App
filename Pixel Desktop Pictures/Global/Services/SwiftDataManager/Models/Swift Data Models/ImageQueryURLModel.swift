//
//  ImageQueryURLModel.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-08.
//

import Foundation
import SwiftData

@Model
class ImageQueryURLModel {
    @Attribute(.unique) var queryText: String // EX: nature
    var pageNumber: Int // Ex: 3
    var queryURLString: String { // Ex: "https://api.unsplash.com/search/photos?orientation=landscape&page=3&per_page=10&query=Nature"
        return "https://api.unsplash.com/search/photos?orientation=landscape&page=\(pageNumber)&per_page=10&query=\(queryText.capitalized)"
    }
    var imageDataArray: Data
    
    init(queryText: String, pageNumber: Int, imageDataArray: Data) {
        self.queryText = queryText
        self.pageNumber = pageNumber
        self.imageDataArray = imageDataArray
    }
}
