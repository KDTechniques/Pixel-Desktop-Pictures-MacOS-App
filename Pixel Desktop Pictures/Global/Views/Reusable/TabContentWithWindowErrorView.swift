//
//  TabContentWithWindowErrorView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-10.
//

import SwiftUI

struct TabContentWithWindowErrorView<T: View>: View {
    // MARK: - INJECTED PROPERTIES
    @Environment(NetworkManager.self) private var networkManager
    @Environment(APIAccessKeyManager.self) private var apiAccessKeyManager
    let tab: TabItem
    let content: T
    
    // MARK: - ASSIGNED PROPERTIES
    let errorModel = GlobalWindowError.self
    
    // MARK: - INITIALIZERS
    init(tab: TabItem, @ViewBuilder _ content: () -> T) {
        self.tab = tab
        self.content = content()
    }
    
    init(tab: TabItem, _ content: T) {
        self.tab = tab
        self.content = content
    }
    
    // MARK: - BODY
    var body: some View {
        Group {
            if networkManager.connectionStatus == .connected {
                switch apiAccessKeyManager.apiAccessKeyValidationState {
                case .rateLimited:
                    WindowErrorView(model: errorModel.apiAccessRateLimited)
                    
                case .connected :
                    content
                    
                default:
                    WindowErrorView(model: errorModel.apiAccessKeyFailed)
                }
            } else {
                WindowErrorView(model: errorModel.notConnectedToInternet)
            }
        }
        .setTabContentHeightToTabsViewModelViewModifier(from: tab)
    }
}

// MARK: - PREVIEWS
#Preview("Tab Content with Error View") {
    TabContentWithWindowErrorView(tab: .random(), Color.debug)
        .environment(NetworkManager.shared)
        .previewModifier
}
