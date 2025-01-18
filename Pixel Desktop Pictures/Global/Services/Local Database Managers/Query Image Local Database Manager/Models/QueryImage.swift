//
//  QueryImage.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-08.
//

import Foundation
import SwiftData

@Model
final class QueryImage {
    // MARK: - PROPERTIES
    @Attribute(.unique) private(set) var query: String // Ex: Nature
    var pageNumber: Int = 1 // Ex: 3
    var queryImagesEncoded: Data // Encoded `UnsplashQueryImages`
    var currentImageIndex: Int = -1

    // MARK: - INITIALIZER
    init(query: String, queryImagesEncoded: Data) {
        self.queryImagesEncoded = queryImagesEncoded
        self.query = query.capitalized
    }
}
