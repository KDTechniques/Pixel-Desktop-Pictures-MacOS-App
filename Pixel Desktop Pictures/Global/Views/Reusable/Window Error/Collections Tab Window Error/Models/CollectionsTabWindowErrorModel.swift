//
//  CollectionsTabWindowErrorModel.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-11.
//

import SwiftUI

enum CollectionsTabWindowErrorModel: CaseIterable, WindowErrorModelProtocol {
    case collectionsViewModelInitializationFailed
    case updatingCollectionNotFound
    
    var title: String {
        switch self {
        case .collectionsViewModelInitializationFailed:
            return "Failed to Fetch Content"
        case .updatingCollectionNotFound:
            return "You May Be Unable to Edit the Collection"
        }
    }
    
    var messageView: some View {
        switch self {
        case .collectionsViewModelInitializationFailed, .updatingCollectionNotFound:
            return SomethingWentWrongWindowErrorMessageView()
        }
    }
    
    var withBottomPadding: Bool {
        switch self {
        case .collectionsViewModelInitializationFailed:
            return true
        case .updatingCollectionNotFound:
            return false
        }
    }
}
