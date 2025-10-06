//
//  APIAccessKeyValidityStates.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-10-01.
//

import Foundation

enum APIAccessKeyValidityStates: CaseIterable, Codable {
    case noInternet
    case connected
    case invalid
    case failed
    case rateLimited
}
