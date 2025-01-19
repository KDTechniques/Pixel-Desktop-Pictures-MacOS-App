//
//  GlobalWindowErrorModel.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-11.
//

import SwiftUI

/**
 A model that represents error states at the window level in the application.
 
 This model defines global error types that are not specific to any individual tabs in the application. These error states, such as API access issues or network connectivity problems, are used to present error messages at a global level  throughout the app.
 */
enum GlobalWindowErrorModel: CaseIterable, WindowErrorProtocol {
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
    var messageView: some View {
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
    
    var withBottomPadding: Bool {
        switch self {
        case .apiAccessKeyNotFound, .notConnectedToInternet:
            return true
        case .apiAccessKeyInvalid, .apiAccessRateLimited:
            return false
        }
    }
}
