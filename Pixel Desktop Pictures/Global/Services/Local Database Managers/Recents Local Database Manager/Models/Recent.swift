//
//  Recent.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-19.
//

import Foundation
import SwiftData

/**
 A model class representing a recently viewed image in the local database.
 It stores information about the image, including its unique ID, timestamp, and encoded image data.
 This class is marked as `@Model` to enable SwiftData persistence.
 */
@Model
final class Recent {
    // MARK: - PROPERTIES
    @Attribute(.unique) var id: String = UUID().uuidString
    private(set) var timestamp: Date = Date()
    private(set) var imageEncoded: Data // Encoded `UnsplashImage`
    
    // MARK: - INITILAIZER
    init(imageEncoded: Data) {
        self.imageEncoded = imageEncoded
    }
}
