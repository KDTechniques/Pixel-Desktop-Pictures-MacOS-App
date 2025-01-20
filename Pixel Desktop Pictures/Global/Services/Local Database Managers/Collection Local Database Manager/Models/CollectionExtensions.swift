//
//  CollectionExtensions.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-10.
//

import Foundation

extension Collection {
    static func getDefaultCollectionsArray() throws -> [Collection] {
        let encoder: JSONEncoder = .init()
        
        let defaultCollectionsArray: [Collection] = [
            .init(
                name: randomKeywordString,
                imageQualityURLStringsEncoded: try encoder.encode(UnsplashImageResolution(full: "", regular: "", small: "", thumb: "")),
                isSelected: true,
                isEditable: false
            ),
            .init(
                name: "Nature",
                imageQualityURLStringsEncoded: try encoder.encode(UnsplashImageResolution(
                    full: "",
                    regular: "",
                    small: "https://images.unsplash.com/photo-1473448912268-2022ce9509d8?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2ODg0NDh8MHwxfHNlYXJjaHw5Mnx8TmF0dXJlfGVufDB8MHx8fDE3MzYzNDk4MjJ8MA&ixlib=rb-4.0.3&q=80&w=400",
                    thumb: ""
                )),
                isSelected: false,
                isEditable: false
            ),
            .init(
                name: "Animal",
                imageQualityURLStringsEncoded: try encoder.encode(UnsplashImageResolution(
                    full: "",
                    regular: "",
                    small: "https://images.unsplash.com/photo-1504006833117-8886a355efbf?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2ODg0NDh8MHwxfHNlYXJjaHwyfHxBbmltYWx8ZW58MHwwfHx8MTczNjM1MDEwMXww&ixlib=rb-4.0.3&q=80&w=400",
                    thumb: ""
                )),
                isSelected: false,
                isEditable: false
            ),
            .init(
                name: "Place",
                imageQualityURLStringsEncoded: try encoder.encode(UnsplashImageResolution(
                    full: "",
                    regular: "",
                    small: "https://images.unsplash.com/photo-1464817739973-0128fe77aaa1?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2ODg0NDh8MHwxfHNlYXJjaHwyNXx8UGxhY2V8ZW58MHwwfHx8MTczNjM0OTQ0OHww&ixlib=rb-4.0.3&q=80&w=400",
                    thumb: ""
                )),
                isSelected: false,
                isEditable: false
            ),
            .init(
                name: "Food & Drink",
                imageQualityURLStringsEncoded: try encoder.encode(UnsplashImageResolution(
                    full: "",
                    regular: "",
                    small: "https://images.unsplash.com/photo-1563227812-0ea4c22e6cc8?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2ODg0NDh8MHwxfHNlYXJjaHwxNnx8Rm9vZCUyMEFuZCUyMERyaW5rfGVufDB8MHx8fDE3MzYzNTA0MDR8MA&ixlib=rb-4.0.3&q=80&w=400",
                    thumb: ""
                )),
                isSelected: false,
                isEditable: false
            ),
            .init(
                name: "Mountain",
                imageQualityURLStringsEncoded: try encoder.encode(UnsplashImageResolution(
                    full: "",
                    regular: "",
                    small: "https://images.unsplash.com/photo-1501785888041-af3ef285b470?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2ODg0NDh8MHwxfHNlYXJjaHwxMXx8TW91bnRhaW58ZW58MHwwfHx8MTczNjM1MDUxN3ww&ixlib=rb-4.0.3&q=80&w=400",
                    thumb: ""
                )),
                isSelected: false,
                isEditable: false
            ),
            .init(
                name: "Abstract",
                imageQualityURLStringsEncoded: try encoder.encode(UnsplashImageResolution(
                    full: "",
                    regular: "",
                    small: "https://images.unsplash.com/photo-1486025402772-bc179c8dfb0e?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2ODg0NDh8MHwxfHNlYXJjaHwxOHx8QWJzdHJhY3R8ZW58MHwwfHx8MTczNjM1MDYxNHww&ixlib=rb-4.0.3&q=80&w=400",
                    thumb: ""
                )),
                isSelected: false,
                isEditable: false
            ),
            .init(
                name: "Black & White",
                imageQualityURLStringsEncoded: try encoder.encode(UnsplashImageResolution(
                    full: "",
                    regular: "",
                    small: "https://images.unsplash.com/photo-1559075398-c61f41bbf892?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2ODg0NDh8MHwxfHNlYXJjaHw2N3x8QmxhY2slMjBBbmQlMjBXaGl0ZXxlbnwwfDB8fHwxNzM2MzUyNjg2fDA&ixlib=rb-4.0.3&q=80&w=400",
                    thumb: ""
                )),
                isSelected: false,
                isEditable: false
            ),
        ]
        
        return defaultCollectionsArray
    }
}
