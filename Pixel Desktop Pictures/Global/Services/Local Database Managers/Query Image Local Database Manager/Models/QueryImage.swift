//
//  QueryImage.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-08.
//

import Foundation
import SwiftData

/**
 A model class representing a query image in the local database.
 It stores information about the query, page number, encoded query images, and the current image index.
 This class is marked as `@Model` to enable SwiftData persistence.
 */
@Model
final class QueryImage {
    // MARK: - PROPERTIES
    @Attribute(.unique) private(set) var query: String // Ex: Nature
    var pageNumber: Int = 1 // Ex: 3
    var queryImagesEncoded: Data // Encoded `UnsplashQueryImages`
    var currentImageIndex: Int = -1  // Defaults to `-1` (no selection).
    
    // MARK: - INITIALIZER
    init(query: String, queryImagesEncoded: Data) {
        self.queryImagesEncoded = queryImagesEncoded
        self.query = query.capitalized
    }
}
