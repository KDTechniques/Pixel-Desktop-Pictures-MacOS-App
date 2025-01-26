//
//  UnsplashImageAPIService.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-28.
//

import Foundation

/**
 Provides an interface for interacting with the Unsplash API. This class is responsible for fetching random images or query-based images from Unsplash and validating the API access key. It handles constructing the necessary network requests, parsing the responses, and decoding the JSON data into the appropriate model objects.
 */
struct UnsplashImageAPIService {
    // MARK: - INJECTED PROPERTIES
    let apiAccessKey: String
    
    // MARK: - ASSIGNED PROPERTIES
    private let timeout: TimeInterval = 10
    private let randomImageURLString = "https://api.unsplash.com/photos/random?orientation=landscape"
    static let imagesPerPage: Int = 10
    
    // MARK: - INITIALIZER
    init(apiAccessKey: String) {
        self.apiAccessKey = apiAccessKey
    }
    
    // MARK: FUNCTIONS
    
    // MARK: - INTERNAL FUNCTIONS
    
    /// This function validates the API Access Key by making a network call to the Unsplash API.
    /// It attempts to fetch a random image using the provided API Access Key.
    /// If the call is successful, the key is considered valid. If it fails, an error is thrown.
    ///
    /// - Throws: `UnsplashImageAPIServiceError.apiAccessKeyValidationFailed`: If the API call fails,
    /// the function wraps the underlying error in this custom error type to indicate
    /// that the access key validation was unsuccessful.
    func validateAPIAccessKey() async throws {
        do {
            let _ = try await fetchDataNDecode(for: randomImageURLString, in: UnsplashRandomImage.self)
            Logger.log("✅: API access key has been validated.")
        } catch {
            Logger.log(UnsplashImageAPIServiceError.failedToFetchAPIAccessKey(error).localizedDescription)
            throw error
        }
    }
    
    /// Fetches a random image  from the Unsplash API.
    /// This function performs a network call to retrieve a random image and returns the corresponding model.
    ///
    /// - Returns: An `UnsplashRandomImage` object representing the fetched random image.
    /// - Throws: `UnsplashImageAPIServiceError.randomImageModelFetchFailed`: If the network call fails,
    /// the underlying error is wrapped in this custom error type.
    ///
    /// - Important: We could have used a cropped version of the image from the Unsplash API to reduce network usage, but unfortunately, their documentation is somewhat lacking.
    func getRandomImage() async throws -> UnsplashRandomImage {
        do {
            let randomImage: UnsplashRandomImage = try await fetchDataNDecode(for: randomImageURLString, in: UnsplashRandomImage.self)
            Logger.log("✅: Random image has been returned.")
            return randomImage
        } catch {
            Logger.log(UnsplashImageAPIServiceError.failedToFetchRandomImage(error).localizedDescription)
            throw error
        }
    }
    
    /// Fetches a query-based image model from the Unsplash API.
    /// This function constructs a URL string based on the query text and page number,
    /// performs a network call, and returns the corresponding image model.
    ///
    /// - Parameters:
    ///   - query: A `String` representing the search query text.
    ///   - pageNumber: An `Int` specifying the page number for paginated results.
    ///
    /// - Returns: An `UnsplashQueryImages` object containing the query-based image results.
    ///
    /// - Throws: `UnsplashImageAPIServiceError.queryImageModelFetchFailed`: If the network call fails,
    /// the underlying error is wrapped in this custom error type.
    ///
    /// - Important: We could have used a cropped version of the image from the Unsplash API to reduce network usage, but unfortunately, their documentation is somewhat lacking.
    func getQueryImages(query: String, pageNumber: Int, imagesPerPage: Int = imagesPerPage) async throws -> UnsplashQueryImages {
        // Construct the query URL string using the provided parameters.
        let queryURLString: String = constructQueryURLString(queryText: query, pageNumber: pageNumber, imagesPerPage: imagesPerPage)
        
        do {
            // Fetch and decode the data into an `UnsplashQueryImages`.
            let queryImages: UnsplashQueryImages = try await fetchDataNDecode(for: queryURLString, in: UnsplashQueryImages.self)
            Logger.log("✅: Query images has been returned.")
            return queryImages
        } catch {
            Logger.log(UnsplashImageAPIServiceError.failedToFetchQueryImages(error).localizedDescription)
            throw error
        }
    }
    
    // MARK: - PRIVATE FUNCTIONS
    
    /// Constructs a query URL string for the Unsplash API based on the provided search query and page number.
    ///
    /// - Parameters:
    ///   - query: A `String` representing the search query text. This is capitalized before being used in the URL.
    ///   - pageNumber: An `Int` specifying the page number for paginated results.
    ///
    /// - Returns: A `String` containing the constructed query URL.
    private func constructQueryURLString(queryText: String, pageNumber: Int, imagesPerPage: Int) -> String {
        let capitalizedQueryText: String = queryText.capitalized
        let queryURLString: String = "https://api.unsplash.com/search/photos?orientation=landscape&page=\(pageNumber)&per_page=\(imagesPerPage)&query=\(capitalizedQueryText)"
        
        Logger.log("✅: Query url string has been constructed.")
        return queryURLString
    }
    
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
        try parseHTTPResponseStatusCode(httpResponse)
        
        // Decode JSON Data into Desired Model
        let model: T = try JSONDecoder().decode(T.self, from: data)
        
        Logger.log("✅: Data has been fetched and decoded.")
        // Return Model Object
        return model
    }
    
    /// Parses the HTTP response status code and handles specific cases by throwing appropriate errors.
    ///
    /// - Parameter response: An `HTTPURLResponse` object to be parsed.
    ///
    /// - Throws: `URLError.userAuthenticationRequired`: If the status code is 401 (Unauthorized).
    /// `URLError.fileDoesNotExist`: If the status code is 404 (Not Found).
    /// `URLError.badServerResponse`: For all other non-200 status codes.
    private func parseHTTPResponseStatusCode(_ response: HTTPURLResponse) throws {
        switch response.statusCode {
        case 200:
            Logger.log("✅: Everything worked as expected. Status code: 200 - OK")
        case 400:
            Logger.log("❌: The request was unacceptable, often due to missing a required parameter. Status code: 400 - Bad Request")
            throw URLError(.badURL)
        case 401:
            Logger.log("❌: Invalid Access Token. Status code: 401 - Unauthorized") // This occurs when the API Access Key is invalid
            throw URLError(.userAuthenticationRequired)
        case 403:
            Logger.log("❌: Missing permissions to perform request. Status code: 403 - Forbidden") // This occurs when 50 images per hour hits
            throw URLError(.clientCertificateRejected)
        case 404:
            Logger.log("❌: Resource not found. Status code: 404")
            throw URLError(.fileDoesNotExist)
        case 500, 503:
            Logger.log("❌: Something went wrong on Unsplash server side. Status code: 500, 503")
            throw URLError(.badServerResponse)
        default:
            Logger.log("❌: Request failed with status code: \(response.statusCode)")
            throw URLError(.badServerResponse)
        }
    }
}
