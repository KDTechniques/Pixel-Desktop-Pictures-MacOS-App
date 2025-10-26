//
//  APIAccessKeyValidityStates.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-10-01.
//

import Foundation

enum APIAccessKeyValidityStates: CaseIterable, Codable {
    case unknown
    case noInternet
    case validating
    case connected
    case invalid
    case failed
    case rateLimited
}
