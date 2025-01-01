//
//  UnsplashURLModels.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-01.
//

import Foundation
import SwiftData

// MARK: - Pre Saved Image URL Model
@Model
class PreSavedImageURLModel {
    @Attribute(.unique) var queryText: String // Ex: nature
    var imageURLStringsArray: [String] // Ex: ["https://www.example.com/Nature/image5", "https://www.example.com/Nature/image6", "https://www.example.com/Nature/image7",...]
    
    init(queryText: String, imageURLStringsArray: [String]) {
        self.queryText = queryText
        self.imageURLStringsArray = imageURLStringsArray
    }
}

// MARK: - Image Query URL Model
@Model
class ImageQueryURLModel {
    @Attribute(.unique) var queryText: String // EX: nature
    var pageNumber: Int // 3
    var queryURLString: String // Ex: "https://api.unsplash.com/search/photos?orientation=landscape&page=3&per_page=10&query=Nature"
    
    init(queryText: String, pageNumber: Int, queryURLString: String) {
        self.queryText = queryText
        self.pageNumber = pageNumber
        self.queryURLString = queryURLString
    }
}

// MARK: - Recent Image URL Model
@Model
class RecentImageURLModel {
    var date: Date // Ex: 2025-01-01 11:12:54 AM +0000
    var imageURLString: String // Ex: "https://www.example.com/Nature/image5"
    
    init(date: Date, imageURLString: String) {
        self.date = date
        self.imageURLString = imageURLString
    }
}
