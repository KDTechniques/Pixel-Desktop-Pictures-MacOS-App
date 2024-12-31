//
//  NetworkServiceProtocol.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-28.
//

import Foundation

// Protocol defining a service for fetching data from the network.
protocol NetworkServiceProtocol {
    /// Fetches data from a given URL.
    ///
    /// This asynchronous function performs a network request to retrieve raw data from the specified URL.
    ///
    /// - Parameter url: The URL to fetch data from.
    /// - Throws: An error if the network request fails.
    /// - Returns: Raw `Data` fetched from the specified URL.
    func fetchData(from url: URL) async throws -> Data
}

extension NetworkServiceProtocol {
    /// Fetches and decodes JSON data from a given URL.
    ///
    /// This asynchronous function performs a network request to retrieve raw data from the specified URL,
    /// then decodes it into a specified `Decodable` type.
    ///
    /// - Parameters:
    ///   - url: The URL to fetch data from.
    ///   - type: The type to decode the JSON data into.
    /// - Throws: An error if the network request or decoding fails.
    /// - Returns: An instance of the specified type containing the decoded JSON data.
    func fetchJSON<T: Decodable>(from url: URL, type: T.Type) async throws -> T {
        let data = try await fetchData(from: url)
        let response: T = try JSONDecoder().decode(T.self, from: data)
        return response
    }
}
