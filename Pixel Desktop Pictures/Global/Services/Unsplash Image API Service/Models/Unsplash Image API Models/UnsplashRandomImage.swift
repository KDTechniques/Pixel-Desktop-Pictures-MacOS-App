//
//  UnsplashRandomImage.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-03.
//

import Foundation

struct UnsplashRandomImage: Codable {
    var imageQualityURLStrings: UnsplashImageResolution
    let links: UnsplashImageLink
    let user: UnsplashImageUser
    let location: UnsplashImageLocation
    
    enum CodingKeys: String, CodingKey {
        case imageQualityURLStrings = "urls"
        case links
        case user
        case location
    }
}

// MARK: - SUB MODELS

struct UnsplashImageResolution: Codable {
    let full: String // 2MB
    let regular: String // Ex: 241KB
    let small: String // Ex: 38KB
    var thumb: String // Ex: 11KB
}

struct UnsplashImageUser: Codable {
    let firstNLastName: String
    
    enum CodingKeys: String, CodingKey {
        case firstNLastName = "name"
    }
}

struct UnsplashImageLocation: Codable {
    let name: String?
}

struct UnsplashImageLink: Codable {
    let downloadURL: String
    
    enum CodingKeys: String, CodingKey {
        case downloadURL = "download"
    }
}
