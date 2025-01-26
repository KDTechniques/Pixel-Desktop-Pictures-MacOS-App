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
