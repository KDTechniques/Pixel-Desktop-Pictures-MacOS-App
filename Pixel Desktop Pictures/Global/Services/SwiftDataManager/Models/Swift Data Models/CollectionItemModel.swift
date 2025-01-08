//
//  CollectionItemModel.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-08.
//

import Foundation
import SwiftData

fileprivate let randomKeyword: String = "RANDOM"

@Model
class CollectionItemModel {
    @Attribute(.unique) private(set) var collectionName: String
    private(set) var imageURLString: String
    private(set) var pageNumber: Int = 1
    private(set) var isSelected: Bool = false
    var isEditable: Bool
    
    init(collectionName: String, imageURLString: String, isSelected: Bool = false, isEditable: Bool = true) {
        self.collectionName = collectionName == randomKeyword ? collectionName : collectionName.capitalized
        self.imageURLString = imageURLString
        self.isSelected = isSelected
        self.isEditable = isEditable
    }
    
    func updateImageURLString(imageAPIServiceReference: UnsplashImageAPIService) async throws {
        let nextPageNumber:Int = pageNumber + 1
        let nextQueryImageURLModel: UnsplashQueryImageModel = try await imageAPIServiceReference.getQueryImageModel(queryText: collectionName.capitalized, pageNumber: nextPageNumber, imagesPerPage: 1)
        guard let newImageURLString: String = nextQueryImageURLModel.results.first?.imageQualityURLStrings.small else {
            throw URLError(.badServerResponse)
        }
        
        imageURLString = newImageURLString
        pageNumber = nextPageNumber
    }
    
    func updateIsSelected(_ boolean: Bool) {
        guard isSelected != boolean else { return }
        isSelected = boolean
    }
    
    
    static let randomKeywordString: String = randomKeyword
    static let defaultCollectionsArray: [CollectionItemModel] = [
        .init(
            collectionName: randomKeyword,
            imageURLString: "",
            isSelected: true,
            isEditable: false
        ),
        .init(
            collectionName: "Nature",
            imageURLString: "https://images.unsplash.com/photo-1473448912268-2022ce9509d8?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2ODg0NDh8MHwxfHNlYXJjaHw5Mnx8TmF0dXJlfGVufDB8MHx8fDE3MzYzNDk4MjJ8MA&ixlib=rb-4.0.3&q=80&w=400",
            isSelected: false,
            isEditable: false
        ),
        .init(
            collectionName: "Animal",
            imageURLString: "https://images.unsplash.com/photo-1504006833117-8886a355efbf?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2ODg0NDh8MHwxfHNlYXJjaHwyfHxBbmltYWx8ZW58MHwwfHx8MTczNjM1MDEwMXww&ixlib=rb-4.0.3&q=80&w=400",
            isSelected: false,
            isEditable: false
        ),
        .init(
            collectionName: "Place",
            imageURLString: "https://images.unsplash.com/photo-1464817739973-0128fe77aaa1?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2ODg0NDh8MHwxfHNlYXJjaHwyNXx8UGxhY2V8ZW58MHwwfHx8MTczNjM0OTQ0OHww&ixlib=rb-4.0.3&q=80&w=400",
            isSelected: false,
            isEditable: false
        ),
        .init(
            collectionName: "Food & Drink",
            imageURLString: "https://images.unsplash.com/photo-1563227812-0ea4c22e6cc8?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2ODg0NDh8MHwxfHNlYXJjaHwxNnx8Rm9vZCUyMEFuZCUyMERyaW5rfGVufDB8MHx8fDE3MzYzNTA0MDR8MA&ixlib=rb-4.0.3&q=80&w=400",
            isSelected: false,
            isEditable: false
        ),
        .init(
            collectionName: "Mountain",
            imageURLString: "https://images.unsplash.com/photo-1501785888041-af3ef285b470?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2ODg0NDh8MHwxfHNlYXJjaHwxMXx8TW91bnRhaW58ZW58MHwwfHx8MTczNjM1MDUxN3ww&ixlib=rb-4.0.3&q=80&w=400",
            isSelected: false,
            isEditable: false
        ),
        .init(
            collectionName: "Abstract",
            imageURLString: "https://images.unsplash.com/photo-1486025402772-bc179c8dfb0e?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2ODg0NDh8MHwxfHNlYXJjaHwxOHx8QWJzdHJhY3R8ZW58MHwwfHx8MTczNjM1MDYxNHww&ixlib=rb-4.0.3&q=80&w=400",
            isSelected: false,
            isEditable: false
        ),
        .init(
            collectionName: "Black & White",
            imageURLString: "https://images.unsplash.com/photo-1559075398-c61f41bbf892?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2ODg0NDh8MHwxfHNlYXJjaHw2N3x8QmxhY2slMjBBbmQlMjBXaGl0ZXxlbnwwfDB8fHwxNzM2MzUyNjg2fDA&ixlib=rb-4.0.3&q=80&w=400",
            isSelected: false,
            isEditable: false
        ),
    ]
}

