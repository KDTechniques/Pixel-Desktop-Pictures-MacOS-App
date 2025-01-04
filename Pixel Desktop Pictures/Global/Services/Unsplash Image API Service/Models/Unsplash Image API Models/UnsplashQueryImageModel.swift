//
//  UnsplashQueryImageModel.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-03.
//

import Foundation

struct UnsplashQueryImageModel: Codable {
    let results: [UnsplashQueryImageSubModel]
}

// MARK: SUB MODELS

// MARK: - Unsplash Query Image Sub Model
struct UnsplashQueryImageSubModel: Codable {
    let imageQualityURLStrings: UnsplashImageURLsModel
    let links: UnsplashImageDownloadModel
    let user: UnsplashImageUserModel
    
    enum CodingKeys: String, CodingKey {
        case imageQualityURLStrings = "urls"
        case links
        case user
    }
}
