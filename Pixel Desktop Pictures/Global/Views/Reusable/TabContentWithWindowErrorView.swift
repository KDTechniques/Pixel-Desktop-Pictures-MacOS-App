//
//  TabContentWithWindowErrorView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-10.
//

import SwiftUI

struct TabContentWithWindowErrorView<T: View>: View {
    // MARK: - INJECTED PROPERTIES
    @Environment(APIKeyManager.self) private var apiKeyManager
    let tab: TabItem
    let content: T
    
    // MARK: - ASSIGNED PROPERTIES
    private let networkManager: NetworkManager = .shared
    private let errorModel = GlobalWindowError.self
    
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
                switch apiKeyManager.apiKeyValidationState {
                case .rateLimited:
                    WindowErrorView(model: errorModel.apiRateLimited)
                    
                case .connected, .unknown:
                    content
                    
                case .validating:
                    if apiKeyManager.getAPIKeyFromUserDefaults().isNil() {
                        SettingThingsUpView()
                    } else {
                        content
                    }
                    
                default:
                    WindowErrorView(model: errorModel.apiKeyFailed)
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
        .previewModifier
}
