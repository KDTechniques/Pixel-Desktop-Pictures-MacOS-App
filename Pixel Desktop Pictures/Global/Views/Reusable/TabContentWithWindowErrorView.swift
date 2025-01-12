//
//  TabContentWithWindowErrorView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-10.
//

import SwiftUI

struct TabContentWithWindowErrorView<T: View>: View {
    // MARK: - PROPERTIES
    @Environment(NetworkManager.self) private var networkManager
    @Environment(APIAccessKeyManager.self) private var apiAccessKeyManager
    let tab: TabItemsModel
    let content: T
    
    let errorModel = GlobalWindowErrorModel.self
    
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
                    WindowErrorView(model: errorModel.apiAccessKeyNotFound)
                case .invalid:
                    WindowErrorView(model: errorModel.apiAccessKeyInvalid)
                case .rateLimited:
                    WindowErrorView(model: errorModel.apiAccessRateLimited)
                case .connected :
                    content
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
        .environment(NetworkManager())
        .previewModifier
}
