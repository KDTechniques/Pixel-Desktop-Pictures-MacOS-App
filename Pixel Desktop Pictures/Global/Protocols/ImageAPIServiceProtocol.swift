//
//  ImageAPIServiceProtocol.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-28.
//

import Foundation

protocol ImageAPIServiceProtocol: NetworkServiceProtocol {
    // MARK: - PROPERTIES
    var defaults: UserDefaults { get }
    
    associatedtype Manager: Actor
    var fileStorageManager: Manager { get }
    
    var apiAccessKey: String? { get async }
    var randomImageURLString: String { get }
    var timeOut: TimeInterval { get }
    
    // MARK: FUNCTIONS
    
    // MARK: - User Defaults
    func getAPIAccessKeyFromUserDefaults() async throws
    func saveAccessKeyToUserDefaults(key: String) async throws
    
    // MARK: - API End Points
    func constructQueryURLString(pageNumber: Int, queryText: String) async -> String
    func getNextAvailableQueryURLString(queryText: String) async throws -> String
    func getNextAvailableQueryImageURLString(queryText: String) async throws -> String
    func fetchRandomImageURL() async throws -> URL
    func fetchQueryImageURLsArray(queryText: String) async throws -> [URL]
    func fetchQueryImageURL(queryText: String) async throws -> URL
}
