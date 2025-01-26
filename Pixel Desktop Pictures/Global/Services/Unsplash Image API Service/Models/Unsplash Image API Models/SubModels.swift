//
//  SubModels.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-26.
//

import Foundation

struct UnsplashImageResolution: Codable {
    let full: String // 2MB
    let regular: String // Ex: 241KB
    let small: String // Ex: 38KB
    var thumb: String // Ex: 11KB
}

struct UnsplashImageUser: Codable {
    let firstNLastName: String
    
    enum CodingKeys: String, CodingKey {
        case firstNLastName = "name"
    }
}

struct UnsplashImageLocation: Codable {
    let name: String?
}

struct UnsplashImageLink: Codable {
    let downloadURL: String
    let webLinkURL: String
    
    enum CodingKeys: String, CodingKey {
        case downloadURL = "download"
        case webLinkURL = "html"
    }
}
