//
//  UnsplashQueryImages.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-03.
//

import Foundation

struct UnsplashQueryImages: Codable {
    let results: [UnsplashQueryImage]
}

struct UnsplashQueryImage: Codable {
    var imageQualityURLStrings: UnsplashImageResolution
    let links: UnsplashImageLink
    let user: UnsplashImageUser
    
    enum CodingKeys: String, CodingKey {
        case imageQualityURLStrings = "urls"
        case links
        case user
    }
}
