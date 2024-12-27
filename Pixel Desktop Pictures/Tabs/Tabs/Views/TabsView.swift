//
//  TabsView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-25.
//

import SwiftUI

struct TabsView: View {
    // MARK: - PROPERTIES
    @State private var tabsVM: TabsViewModel = .init()
    
    // MARK: - BODY
    var body: some View {
        VStack(spacing: 0) {
            HeaderView()
            
            switch tabsVM.tabSelection {
            case .main:
                MainTabView()
            case .recents:
                RecentsTabView()
            case .collections:
                CollectionsTabView()
            case .settings:
                SettingsTabView()
            }
        }
        .frame(width: TabItems.allWindowWidth)
        .background(Color.windowBackground)
        .environment(tabsVM)
    }
}

// MARK: - PREVIEWS
#Preview("Tabs View") {
    TabsView()
}
