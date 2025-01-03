//
//  UnsplashSwiftDataModels.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-01.
//

import Foundation
import SwiftData

// MARK: - Image Query URL Model
@Model
class ImageQueryURLModel {
    @Attribute(.unique) var queryText: String // EX: nature
    var pageNumber: Int // Ex: 3
    var queryURLString: String { // Ex: "https://api.unsplash.com/search/photos?orientation=landscape&page=3&per_page=10&query=Nature"
        return "https://api.unsplash.com/search/photos?orientation=landscape&page=\(pageNumber)&per_page=10&query=\(queryText.capitalized)"
    }
    var imageDataArray: UnsplashQueryImageModel
    
    init(queryText: String, pageNumber: Int, imageDataArray: UnsplashQueryImageModel) {
        self.queryText = queryText
        self.pageNumber = pageNumber
        self.imageDataArray = imageDataArray
    }
}

// MARK: - Recent Image URL Model
@Model
class RecentImageURLModel {
    var downloadedDate: Date // Ex: 2025-01-01 11:12:54 AM +0000
    var imageURLString: String // Ex: "https://www.example.com/Nature/image5"
    
    init(downloadedDate: Date, imageURLString: String) {
        self.downloadedDate = downloadedDate
        self.imageURLString = imageURLString
    }
}
