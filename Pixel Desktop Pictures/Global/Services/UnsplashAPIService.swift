//
//  UnsplashAPIService.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-28.
//

import Foundation

// MARK: MODELS

// MARK: - Unsplash Photo Model
struct UnsplashPhotoModel: Decodable {
    let photo: URLStringModel
    
    enum CodingKeys: String, CodingKey {
        case photo = "urls"
    }
}

// MARK: - URL String Model
struct URLStringModel: Decodable {
    let urlString: String
    
    enum CodingKeys: String, CodingKey {
        case urlString = "thumb" // change to `raw` later
    }
}

// MARK: - Query Image Model
struct QueryImageModel: Decodable {
    let results: [UnsplashPhotoModel]
}

actor UnsplashAPIService {


}
