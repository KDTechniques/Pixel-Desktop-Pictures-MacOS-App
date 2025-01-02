//
//  UnsplashAPIModels.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-29.
//

import Foundation

// MARK: - Unsplash Image Model
struct UnsplashImageModel: Codable {
    let imageQualityURLStrings: UnsplashImageURLsModel
    let links: UnsplashImageDownloadModel
    let user: UnsplashImageUserModel
    let location: UnsplashImageLocationModel
    
    enum CodingKeys: String, CodingKey {
        case imageQualityURLStrings = "urls"
        case links
        case user
        case location
    }
}

// MARK: - Unsplash Image URLs Model
struct UnsplashImageURLsModel: Codable {
    let desktopPictureURLString: String // 2MB
    let mainTabImagePreviewURLString: String // Ex: 241KB
    let recentsNCollectionsTabsImagePreviewURLString: String // Ex: 38KB
    let anyPreviewPlaceholderURLString: String // Ex: 11KB
    
    enum CodingKeys: String, CodingKey {
        case desktopPictureURLString = "raw"
        case mainTabImagePreviewURLString = "regular"
        case recentsNCollectionsTabsImagePreviewURLString = "small"
        case anyPreviewPlaceholderURLString = "thumb"
    }
}

// MARK: - Unsplash Image User Model
struct UnsplashImageUserModel: Codable {
    let firstNLastName: String
    
    enum CodingKeys: String, CodingKey {
        case firstNLastName = "name"
    }
}

// MARK: - Unsplash Image Location Model
struct UnsplashImageLocationModel: Codable {
    let name: String
}

// MARK: - Unsplash Image Download Model
struct UnsplashImageDownloadModel: Codable {
    let downloadURL: String
    
    enum CodingKeys: String, CodingKey {
        case downloadURL = "download"
    }
}

// MARK: - Unsplash Image Query Model
struct UnsplashImageQueryModel: Codable {
    let results: [UnsplashImageModel]
}
