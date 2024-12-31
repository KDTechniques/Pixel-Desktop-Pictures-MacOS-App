//
//  ImageAPIServiceProtocol.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-28.
//

import Foundation

protocol ImageAPIServiceProtocol: NetworkServiceProtocol {
    // MARK: - PROPERTIES
    associatedtype Manager: Actor
    var defaults: UserDefaultsManager { get }
    var fileStorageManager: Manager { get }
    var apiAccessKey: String? { get async }
    var apiAccessKeyValidityStatus: APIAccessKeyValidityStatus { get async }
    var randomImageURLString: String { get }
    var timeOut: TimeInterval { get }
    
    // MARK: FUNCTIONS
    
    // MARK: User Defaults
    
    // MARK: - Check API Access Key Validity
    /// make a network call with random image url api to get a random single image to check whether the api is worki ng or not.
    /// the `apiAccessKeyValidityStatus` get assigned during the checks.
    /// should check the validity when every time the app launches and user add or see the API Access key status
    func checkAPIAccessKeyValidity() async throws
    
    // MARK: - Get API Access Key from User Defaults
    ///  Get the api access key from user defaults and immediately store it to the `apiAccessKey` property in the actor initialization
    ///  so we can fetch images without any issues
    func getAPIAccessKeyFromUserDefaults() async throws
    
    
    func saveAccessKeyToUserDefaults(key: String) async throws
    
    // MARK: - API End Points URLs
    func constructQueryURLString(pageNumber: Int, queryText: String) async -> String
    func getNextAvailableQueryURLString(queryText: String) async throws -> String
    func getNextAvailableQueryImageURLString(queryText: String) async throws -> String
    
    // MARK: - Fetch from API Endpoints
    func fetchRandomImageURL() async throws -> URL
    func fetchQueryImageURLsArray(queryText: String) async throws -> [URL]
    func fetchQueryImageURL(queryText: String) async throws -> URL
}
