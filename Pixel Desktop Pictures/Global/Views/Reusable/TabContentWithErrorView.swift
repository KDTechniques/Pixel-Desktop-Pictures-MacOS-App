//
//  TabContentWithErrorView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-10.
//

import SwiftUI

struct TabContentWithErrorView<T: View>: View {
    // MARK: - PROPERTIES
    @Environment(NetworkManager.self) private var networkManager
    @Environment(APIAccessKeyManager.self) private var apiAccessKeyManager
    
    let tab: TabItemsModel
    let content: T
    
    // MARK: - INITIALIZERS
    init(tab: TabItemsModel, @ViewBuilder _ content: () -> T) {
        self.tab = tab
        self.content = content()
    }
    
    init(tab: TabItemsModel, _ content: T) {
        self.tab = tab
        self.content = content
    }
    
    // MARK: - BODY
    var body: some View {
        Group {
            if networkManager.connectionStatus == .connected {
                switch apiAccessKeyManager.apiAccessKeyStatus {
                case .notFound, .validating, .failed:
                    ContentNotAvailableView(type: .apiAccessKeyNotFound)
                case .invalid:
                    ContentNotAvailableView(type: .apiAccessKeyError)
                case .rateLimited:
                    ContentNotAvailableView(type: .rateLimited)
                case .connected :
                    content
                }
            } else {
                ContentNotAvailableView(type: .noInternetConnection)
            }
        }
        .setTabContentHeightToTabsViewModelViewModifier(from: tab)
    }
}

// MARK: - PREVIEWS
#Preview("Tab Content with Error View") {
    TabContentWithErrorView(tab: .random(), Color.debug)
        .environment(NetworkManager())
        .previewModifier
}
