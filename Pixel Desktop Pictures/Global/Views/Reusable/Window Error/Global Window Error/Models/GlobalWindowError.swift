//
//  GlobalWindowError.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-11.
//

import SwiftUI

/**
 A model that represents error states at the window level in the application.
 
 This model defines global error types that are not specific to any individual tabs in the application. These error states, such as API access issues or network connectivity problems, are used to present error messages at a global level  throughout the app.
 */
enum GlobalWindowError: CaseIterable, WindowErrorProtocol {
    case apiAccessRateLimited
    case notConnectedToInternet
    case apiAccessKeyFailed
    
    var title: String {
        switch self {
        case .notConnectedToInternet:
            return "Failed to Fetch Content"
            
        case .apiAccessRateLimited:
            return "Exceeded the Number of Image Changes"
            
        case .apiAccessKeyFailed:
            return "Something Went Wrong"
        }
    }
    
    @ViewBuilder
    var messageView: some View {
        switch self {
        case .apiAccessRateLimited:
            APIAccessRateLimitedWindowErrorMessageView()
            
        case .notConnectedToInternet:
            NotConnectedToInternetWindowErrorMessageView()
            
        case .apiAccessKeyFailed:
            APIAccessKeyFailedWindowErrorMessageView()
        }
    }
    
    var withBottomPadding: Bool {
        switch self {
        case .apiAccessKeyFailed, .notConnectedToInternet:
            return true
        case .apiAccessRateLimited:
            return false
        }
    }
}
