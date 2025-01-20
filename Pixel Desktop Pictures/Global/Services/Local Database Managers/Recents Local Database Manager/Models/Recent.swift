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
    private(set) var imageEncoded: Data // Encoded `UnsplashImage`
    
    // MARK: - INITILAIZER
    init(imageEncoded: Data) {
        self.imageEncoded = imageEncoded
    }
}
