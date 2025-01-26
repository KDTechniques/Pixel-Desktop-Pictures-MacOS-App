//
//  APIAccessKeyValidityStatus.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-07.
//

import Foundation

enum APIAccessKeyValidityStatus: CaseIterable, Codable {
    case notFound
    case validating
    case connected
    case invalid
    case failed
    case rateLimited
}
