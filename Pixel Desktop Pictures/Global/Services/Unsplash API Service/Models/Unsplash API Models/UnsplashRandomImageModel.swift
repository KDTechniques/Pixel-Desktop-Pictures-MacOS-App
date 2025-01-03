//
//  UnsplashRandomImageModel.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-03.
//

import Foundation

struct UnsplashRandomImageModel: Codable {
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

// MARK: SUB MODELS

// MARK: - URLs Model
struct UnsplashImageURLsModel: Codable {
    let full: String // 2MB
    let regular: String // Ex: 241KB
    let small: String // Ex: 38KB
    let thumb: String // Ex: 11KB
}

// MARK: - User Model
struct UnsplashImageUserModel: Codable {
    let firstNLastName: String
    
    enum CodingKeys: String, CodingKey {
        case firstNLastName = "name"
    }
}

// MARK: - Location Model
struct UnsplashImageLocationModel: Codable {
    let name: String?
}

// MARK: - Download Model
struct UnsplashImageDownloadModel: Codable {
    let downloadURL: String
    
    enum CodingKeys: String, CodingKey {
        case downloadURL = "download"
    }
}
