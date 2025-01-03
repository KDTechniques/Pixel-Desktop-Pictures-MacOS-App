//
//  UnsplashAPIService.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-28.
//

import Foundation

actor UnsplashAPIService: ImageAPIServiceProtocol {
    // MARK: - PROPERTIES
    let apiAccessKey: String
    private let timeout: TimeInterval = 10
    private let imagesPerPage: Int = 10
    private let randomImageURLString = "https://api.unsplash.com/photos/random?orientation=landscape"
    
    // MARK: - INITIALIZER
    init(apiAccessKey: String) {
        print("UnsplashAPIService is Initialized.")
        self.apiAccessKey = apiAccessKey
    }
    
    // MARK: - FUNCTIONS
    
    func validateAPIAccessKey() async throws {
        do {
            let _ = try await networkCall(for: randomImageURLString, in: UnsplashRandomImageModel.self)
        } catch {
            throw UnsplashAPIServiceErrorModel.apiAccessKeyValidationFailed(error)
        }
    }
    
    func getRandomImageModel() async throws -> UnsplashRandomImageModel {
        do {
            let randomImageModel: UnsplashRandomImageModel = try await networkCall(for: randomImageURLString, in: UnsplashRandomImageModel.self)
            return randomImageModel
        } catch {
            throw UnsplashAPIServiceErrorModel.randomImageModelFetchFailed(error)
        }
    }
    
    func getQueryImageModel(queryText: String, pageNumber: Int) async throws -> UnsplashQueryImageModel {
        let queryURLString: String = await constructQueryURLString(queryText: queryText, pageNumber: pageNumber)
        
        do {
            let model: UnsplashQueryImageModel = try await networkCall(for: queryURLString, in: UnsplashQueryImageModel.self)
            
            return model
        } catch {
            throw UnsplashAPIServiceErrorModel.queryImageModelFetchFailed(error)
        }
    }
    
    private func constructQueryURLString(queryText: String, pageNumber: Int) async -> String {
        let capitalizedQueryText: String = queryText.capitalized
        let queryURLString: String = "https://api.unsplash.com/search/photos?orientation=landscape&page=\(pageNumber)&per_page=\(imagesPerPage)&query=\(capitalizedQueryText)"
        
        return queryURLString
    }
    
    // MARK: - URL Session Network Call Request
    private func networkCall<T: Decodable>(for urlString: String, in type: T.Type) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: timeout)
        request.setValue("Client-ID \(apiAccessKey)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Check if the response is a valid HTTP URL response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        // Handle different status codes
        switch httpResponse.statusCode {
        case 200:
            print("Request was successful. Status code: 200")
        case 401:
            print("Unauthorized request. Status code: 401")
            throw URLError(.userAuthenticationRequired)
        case 404:
            print("Resource not found. Status code: 404")
            throw URLError(.fileDoesNotExist)
        default:
            print("Request failed with status code: \(httpResponse.statusCode)")
            throw URLError(.badServerResponse)
        }
        
        let model: T = try JSONDecoder().decode(T.self, from: data)
        return model
    }
}
