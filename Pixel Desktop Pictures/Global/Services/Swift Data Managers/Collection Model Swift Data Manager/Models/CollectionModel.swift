//
//  CollectionModel.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-08.
//

import Foundation
import SwiftData

fileprivate let randomKeyword: String = "RANDOM"

@Model
final class CollectionModel {
    // MARK: - PROPERTIES
    @Attribute(.unique) var collectionName: String
    var pageNumber: Int = 1
    var isSelected: Bool
    private(set) var isEditable: Bool
    var imageURLsData: Data
    static let randomKeywordString: String = randomKeyword
    
    // MARK: - INITIALIZER
    init(collectionName: String, imageURLsData: Data, isSelected: Bool = false, isEditable: Bool = true) {
        self.imageURLsData = imageURLsData
        self.collectionName = collectionName == randomKeyword ? collectionName : collectionName.capitalized
        self.isSelected = isSelected
        self.isEditable = isEditable
    }
}
