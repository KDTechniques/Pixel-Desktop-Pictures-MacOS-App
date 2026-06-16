//
//  APIKeyValidityStates.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-10-01.
//

import Foundation

enum APIKeyValidityStates: CaseIterable, Codable {
    case unknown
    case noInternet
    case validating
    case connected // Note: Doesn't mean it's connected to internet but a valid api key
    case invalid
    case failed
    case rateLimited
}
