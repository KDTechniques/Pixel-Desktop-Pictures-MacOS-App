//
//  APIKeyValidityStates.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-10-01.
//

import Foundation

enum APIKeyValidityStates: String, CaseIterable, Codable {
    case unknown // Initial state before validating an API key
    case validating // API key is being validated
    case valid // Non-rate limited valid API key
    case invalid // API key is not recognized
    case failed // Failed to validate the API Key
    case rateLimited // API key is rate limited
    case allRateLimited // All the hard coded API keys are rate limited
}
