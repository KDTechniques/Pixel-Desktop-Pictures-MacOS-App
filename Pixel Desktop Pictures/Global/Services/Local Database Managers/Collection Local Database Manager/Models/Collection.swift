//
//  Collection.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-08.
//

import Foundation
import SwiftData

fileprivate let randomKeyword: String = "RANDOM"

/**
 A model class representing a collection of images.
 This class is designed to store collection-related properties, such as name, page number, and image quality URL strings.
 */
@Model
final class Collection {
    // MARK: - PROPERTIES
    @Attribute(.unique) var name: String
    var pageNumber: Int = 1
    var isSelected: Bool
    private(set) var isEditable: Bool
    var imageQualityURLStringsEncoded: Data
    private(set) var timestamp: Date = Date()
    static let randomKeywordString: String = randomKeyword
    
    // MARK: - INITIALIZER
    init(name: String, imageQualityURLStringsEncoded: Data, isSelected: Bool = false, isEditable: Bool = true) {
        self.imageQualityURLStringsEncoded = imageQualityURLStringsEncoded
        self.name = name == randomKeyword ? name : name.capitalized
        self.isSelected = isSelected
        self.isEditable = isEditable
    }
}
