//
//  Recent.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-19.
//

import Foundation
import SwiftData

@Model
final class Recent {
    // MARK: - PROPERTIES
    @Attribute(.unique) var id: String = UUID().uuidString
    private(set) var timestamp: Date = Date()
    private(set) var queryImageEncoded: Data? // Encoded `UnsplashQueryImage`
    private(set) var randomImageEncoded: Data? // Encoded `UnsplashRandomImage`
    private(set) var imageTypeEncoded: Data
    
    // MARK: - INITILAIZER
    init(imageType: RecentImage, imageEncoded: Data, imageTypeEncoded: Data) {
        switch imageType {
        case .queryImage:
            queryImageEncoded = imageEncoded
        case .randomImage:
            randomImageEncoded = imageEncoded
        }
        
        self.imageTypeEncoded = imageTypeEncoded
    }
}
