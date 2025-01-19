//
//  CollectionsTabWindowError.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-11.
//

import SwiftUICore

enum CollectionsTabWindowError: CaseIterable, WindowErrorProtocol {
    case collectionsTabViewModelInitializationFailed
    case updatingCollectionNotFound
    
    var title: String {
        switch self {
        case .collectionsTabViewModelInitializationFailed:
            return "Failed to Fetch Content"
        case .updatingCollectionNotFound:
            return "You May Be Unable to Edit the Collection"
        }
    }
    
    var messageView: some View {
        switch self {
        case .collectionsTabViewModelInitializationFailed, .updatingCollectionNotFound:
            return SomethingWentWrongWindowErrorMessageView()
        }
    }
    
    var withBottomPadding: Bool {
        switch self {
        case .collectionsTabViewModelInitializationFailed:
            return true
        case .updatingCollectionNotFound:
            return false
        }
    }
}
