//
//  GlobalWindowErrorModel.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-11.
//

import SwiftUI

enum GlobalWindowErrorModel: CaseIterable, WindowErrorModelProtocol {
    case apiAccessKeyNotFound
    case apiAccessKeyInvalid
    case apiAccessRateLimited
    case notConnectedToInternet
    
    var title: String {
        switch self {
        case .apiAccessKeyNotFound:
            return "API Access Key Not Found"
        case .apiAccessKeyInvalid, .notConnectedToInternet:
            return "Failed to Fetch Content"
        case .apiAccessRateLimited:
            return "Exceeded the Number of Image Changes"
        }
    }
    
    @ViewBuilder
    var message: some View {
        switch self {
        case .apiAccessKeyNotFound:
            APIAccessKeyNotFoundWindowErrorMessageView()
        case .apiAccessKeyInvalid:
            APIAccessKeyInvalidWindowErrorMessageView()
        case .apiAccessRateLimited:
            APIAccessRateLimitedWindowErrorMessageView()
        case .notConnectedToInternet:
            NotConnectedToInternetWindowErrorMessageView()
        }
    }
}
