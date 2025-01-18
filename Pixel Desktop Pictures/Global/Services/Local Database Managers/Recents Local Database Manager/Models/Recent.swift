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
    private(set) var timestamp: Date = Date()
    private(set) var queryImageEncoded: Data? // Encoded `UnsplashQueryImage`, not `UnsplashQueryImages`
    private(set) var randomImageEncoded: Data? // `UnsplashRandomImage`
    
    // MARK: - INITILAIZER
    init(queryImageEncoded: Data?, randomImageEncoded: Data?) {
        self.queryImageEncoded = queryImageEncoded
        self.randomImageEncoded = randomImageEncoded
    }
}
