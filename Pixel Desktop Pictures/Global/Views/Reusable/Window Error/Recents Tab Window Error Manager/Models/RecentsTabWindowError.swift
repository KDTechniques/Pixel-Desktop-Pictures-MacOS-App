//
//  RecentsTabWindowError.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-11.
//

import SwiftUI

enum RecentsTabWindowError: CaseIterable, WindowErrorProtocol {
    case recentsTabViewModelInitializationFailed
    case firstTimeEmptyRecents
    
    var title: String {
        switch self {
        case .recentsTabViewModelInitializationFailed:
            return "Failed to Fetch Recent Pictures"
            
        case .firstTimeEmptyRecents:
            return "Recent Images are Unavailable"
        }
    }
    
    @ViewBuilder
    var messageView: some View {
        switch self {
        case .recentsTabViewModelInitializationFailed:
            SomethingWentWrongWindowErrorMessageView()
        case .firstTimeEmptyRecents:
            FirstTimeEmptyRecentsWindowErrorMessageView()
        }
    }
    
    var withBottomPadding: Bool {
        switch self {
        case . firstTimeEmptyRecents, .recentsTabViewModelInitializationFailed:
            return true
        }
    }
}
