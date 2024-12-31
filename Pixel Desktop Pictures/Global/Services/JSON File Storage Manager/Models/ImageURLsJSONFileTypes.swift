//
//  ImageURLsJSONFileTypes.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-29.
//

import Foundation

enum ImageURLsJSONFileTypes {
    case preSavedImageURLs
    case queryURLs
    
    var type: String {
        switch self {
        case .preSavedImageURLs:
            return "Pre Saved Image URLs"
        case .queryURLs:
            return "Query URLs"
        }
    }
    
    func fileName(_ queryText: String) -> String {
        switch self {
        case .preSavedImageURLs:
            "UnsplashPreSavedImageURLs/\(queryText).json"
        case .queryURLs:
            "UnsplashQueryURLs/\(queryText).json"
        }
    }
}
