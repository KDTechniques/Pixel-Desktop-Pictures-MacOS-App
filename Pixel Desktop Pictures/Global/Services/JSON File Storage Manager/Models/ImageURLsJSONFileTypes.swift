//
//  ImageURLsJSONFileTypes.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-29.
//

import Foundation

enum ImageURLsJSONFileTypes {
    case preSavedURLs
    case queryURLs
    
    func fileName(_ queryText: String) -> String {
        switch self {
        case .preSavedURLs:
            "UnsplashPreSavedImageURLs/\(queryText).json"
        case .queryURLs:
            "UnsplashQueryURLs/\(queryText).json"
        }
    }
}
