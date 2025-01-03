//
//  ImageAPIServiceProtocol.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-28.
//

import Foundation

protocol ImageAPIServiceProtocol {
    // MARK: - PROPERTIES
    var apiAccessKey: String { get }
    
    // MARK: FUNCTIONS
    
    // MARK: - Validate API Access Key
    func validateAPIAccessKey() async throws
    
    // MARK: - Get Random Image Model
    func getRandomImageModel() async throws -> UnsplashRandomImageModel
    
    // MARK: - Get Query Image Model
    func getQueryImageModel(queryText: String, pageNumber: Int) async throws -> UnsplashQueryImageModel
}
