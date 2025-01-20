//
//  UnsplashImage.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-20.
//

import Foundation

struct UnsplashImage: Codable {
    var imageQualityURLStrings: UnsplashImageResolution
    let links: UnsplashImageLink
    let user: UnsplashImageUser
    let location: UnsplashImageLocation?
    
    enum CodingKeys: String, CodingKey {
        case imageQualityURLStrings = "urls"
        case links
        case user
        case location
    }
}

// MARK: - EXTENSIONS
extension UnsplashImage {
    static func convertUnsplashRandomImageToUnsplashImage(_ randomImage: UnsplashRandomImage) -> UnsplashImage {
        let image: UnsplashImage = .init(
            imageQualityURLStrings: randomImage.imageQualityURLStrings,
            links: randomImage.links,
            user: randomImage.user,
            location: randomImage.location
        )
        return image
    }
    
    static func convertUnsplashQueryImageToUnsplashImage(_ queryImage: UnsplashQueryImage) -> UnsplashImage {
        let image: UnsplashImage = .init(
            imageQualityURLStrings: queryImage.imageQualityURLStrings,
            links: queryImage.links,
            user: queryImage.user,
            location: nil
        )
        return image
    }
}
