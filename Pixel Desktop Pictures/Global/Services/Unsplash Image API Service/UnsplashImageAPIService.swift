//
//  UnsplashImageAPIService.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-28.
//

import Foundation

actor UnsplashImageAPIService {
    // MARK: - PROPERTIES
    let apiAccessKey: String
    private let timeout: TimeInterval = 10
    private let imagesPerPage: Int = 10
    private let randomImageURLString = "https://api.unsplash.com/photos/random?orientation=landscape"

    
    // MARK: - INITIALIZER
    init(apiAccessKey: String) {
        print("Unsplash API Service is Initialized.")
        self.apiAccessKey = apiAccessKey
    }
    
    // MARK: FUNCTIONS
    
    // MARK: INTERNAL FUNCTIONS
    
    // MARK: - Validate API Access Key
    /// This function validates the API Access Key by making a network call to the Unsplash API.
    /// It attempts to fetch a random image using the provided API Access Key.
    /// If the call is successful, the key is considered valid. If it fails, an error is thrown.
    ///
    /// - Throws: `UnsplashImageAPIServiceErrorModel.apiAccessKeyValidationFailed`: If the API call fails,
    /// the function wraps the underlying error in this custom error type to indicate
    /// that the access key validation was unsuccessful.
    func validateAPIAccessKey() async throws {
        do {
            let _ = try await fetchDataNDecode(for: randomImageURLString, in: UnsplashRandomImageModel.self)
        } catch {
            throw UnsplashImageAPIServiceErrorModel.apiAccessKeyValidationFailed(error)
        }
    }
    
    // MARK: - Get Random Image Model
    /// Fetches a random image model from the Unsplash API.
    /// This function performs a network call to retrieve a random image and returns the corresponding model.
    ///
    /// - Returns: An `UnsplashRandomImageModel` object representing the fetched random image.
    /// - Throws: `UnsplashImageAPIServiceErrorModel.randomImageModelFetchFailed`: If the network call fails,
    /// the underlying error is wrapped in this custom error type.
    ///
    /// - Important: We could have used a cropped version of the image from the Unsplash API to reduce network usage, but unfortunately, their documentation is somewhat lacking.
    func getRandomImageModel() async throws -> UnsplashRandomImageModel {
        do {
            let randomImageModel: UnsplashRandomImageModel = try await fetchDataNDecode(for: randomImageURLString, in: UnsplashRandomImageModel.self)
            return randomImageModel
        } catch {
            throw UnsplashImageAPIServiceErrorModel.randomImageModelFetchFailed(error)
        }
    }
    
    // MARK: - Get Query Image Model
    /// Fetches a query-based image model from the Unsplash API.
    /// This function constructs a URL string based on the query text and page number,
    /// performs a network call, and returns the corresponding image model.
    ///
    /// - Parameters:
    ///   - queryText: A `String` representing the search query text.
    ///   - pageNumber: An `Int` specifying the page number for paginated results.
    ///
    /// - Returns: An `UnsplashQueryImageModel` object containing the query-based image results.
    ///
    /// - Throws: `UnsplashImageAPIServiceErrorModel.queryImageModelFetchFailed`: If the network call fails,
    /// the underlying error is wrapped in this custom error type.
    ///
    /// - Important: We could have used a cropped version of the image from the Unsplash API to reduce network usage, but unfortunately, their documentation is somewhat lacking.
    func getQueryImageModel(queryText: String, pageNumber: Int) async throws -> UnsplashQueryImageModel {
        let queryURLString: String = await constructQueryURLString(queryText: queryText, pageNumber: pageNumber)
        
        do {
            let model: UnsplashQueryImageModel = try await fetchDataNDecode(for: queryURLString, in: UnsplashQueryImageModel.self)
            return model
        } catch {
            throw UnsplashImageAPIServiceErrorModel.queryImageModelFetchFailed(error)
        }
    }
    
    // MARK: PRIVATE FUNCTIONS
    
    // MARK: - Construct Query URL String
    /// Constructs a query URL string for the Unsplash API based on the provided search query and page number.
    ///
    /// - Parameters:
    ///   - queryText: A `String` representing the search query text. This is capitalized before being used in the URL.
    ///   - pageNumber: An `Int` specifying the page number for paginated results.
    ///
    /// - Returns: A `String` containing the constructed query URL.
    private func constructQueryURLString(queryText: String, pageNumber: Int) async -> String {
        let capitalizedQueryText: String = queryText.capitalized
        let queryURLString: String = "https://api.unsplash.com/search/photos?orientation=landscape&page=\(pageNumber)&per_page=\(imagesPerPage)&query=\(capitalizedQueryText)"
        
        return queryURLString
    }
    
    // MARK: - Fetch Data and Decode
    /// Makes a network call to the given URL string and decodes the response into the specified model type.
    ///
    /// - Parameters:
    ///   - urlString: A `String` representing the URL for the network request.
    ///   - type: The `Decodable` type to which the response should be decoded.
    ///
    /// - Returns: A decoded model of type `T`.
    ///
    /// - Throws: `URLError`: If the URL is invalid or the server response is not as expected.
    /// `DecodingError`: If the response data cannot be decoded into the specified type.
    /// Custom errors based on HTTP response status code.
    private func fetchDataNDecode<T: Decodable>(for urlString: String, in type: T.Type) async throws -> T {
        // Safely Unwrap URL String to a URL
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        // Create a URL Request with Header Passing API Access Key
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: timeout)
        request.setValue("Client-ID \(apiAccessKey)", forHTTPHeaderField: "Authorization")
        
        // Make the URL Session Request to Get Data and Response
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Check If the Response is a Valid HTTP URL Response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        // Handle Different Status Codes of the Response
        try await parseHTTPResponseStatusCode(httpResponse)
        
        // Decode JSON Data into Desired Model
        let model: T = try JSONDecoder().decode(T.self, from: data)
        
        // Return Model Object
        return model
    }
    
    // MARK: - Parse HTTP Response Status Code
    /// Parses the HTTP response status code and handles specific cases by throwing appropriate errors.
    ///
    /// - Parameter response: An `HTTPURLResponse` object to be parsed.
    ///
    /// - Throws: `URLError.userAuthenticationRequired`: If the status code is 401 (Unauthorized).
    /// `URLError.fileDoesNotExist`: If the status code is 404 (Not Found).
    /// `URLError.badServerResponse`: For all other non-200 status codes.
    private func parseHTTPResponseStatusCode(_ response: HTTPURLResponse) async throws {
        switch response.statusCode {
        case 200:
            print("Request was successful. Status code: 200")
        case 401:
            print("Unauthorized request. Status code: 401")
            throw URLError(.userAuthenticationRequired)
        case 404:
            print("Resource not found. Status code: 404")
            throw URLError(.fileDoesNotExist)
        default:
            print("Request failed with status code: \(response.statusCode)")
            throw URLError(.badServerResponse)
        }
    }
}
