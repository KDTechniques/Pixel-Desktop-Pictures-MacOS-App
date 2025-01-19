//
//  RecentsTabWindowError.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-11.
//

import SwiftUICore

enum RecentsTabWindowError: CaseIterable, WindowErrorProtocol {
    case recentsTabViewModelInitializationFailed
    
    var title: String {
        switch self {
        case .recentsTabViewModelInitializationFailed:
            return "Failed to Fetch Recent Pictures"
        }
    }
    
    var messageView: some View {
        switch self {
        case .recentsTabViewModelInitializationFailed:
            return SomethingWentWrongWindowErrorMessageView()
        }
    }
    
    var withBottomPadding: Bool {
        switch self {
        case .recentsTabViewModelInitializationFailed:
            return true
        }
    }
}
