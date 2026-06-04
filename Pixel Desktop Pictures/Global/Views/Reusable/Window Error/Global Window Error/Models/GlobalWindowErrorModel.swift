//
//  GlobalWindowErrorModel.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-11.
//

import SwiftUI

/**
 A model that represents error states at the window level in the application.
 
 This model defines global error types that are not specific to any individual tabs in the application. These error states, such as API issues or network connectivity problems, are used to present error messages at a global level  throughout the app.
 */
enum GlobalWindowErrorModel: CaseIterable, WindowErrorProtocol {
    case apiRateLimited
    case notConnectedToInternet
    case apiKeyFailed
    
    var title: String {
        switch self {
        case .notConnectedToInternet:
            return "Failed to Fetch Content"
            
        case .apiRateLimited:
            return "Exceeded the Number of Image Changes"
            
        case .apiKeyFailed:
            return "Something Went Wrong"
        }
    }
    
    @ViewBuilder
    var messageView: some View {
        switch self {
        case .apiRateLimited:
            APIRateLimitedWindowErrorMessageView()
            
        case .notConnectedToInternet:
            NotConnectedToInternetWindowErrorMessageView()
            
        case .apiKeyFailed:
            APIKeyFailedWindowErrorMessageView()
        }
    }
    
    var withBottomPadding: Bool {
        switch self {
        case .apiKeyFailed, .notConnectedToInternet:
            return true
        case .apiRateLimited:
            return false
        }
    }
}
