//
//  APIKeyValidityStates.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-10-01.
//

import Foundation

enum APIKeyValidityStates: String, CaseIterable, Codable {
    case unknown
    case validating
    case valid
    case invalid
    case failed
    case rateLimited
    case allRateLimited
}
