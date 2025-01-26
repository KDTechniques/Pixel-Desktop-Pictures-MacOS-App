//
//  TabButtonView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-25.
//

import SwiftUI

struct TabButtonView: View {
    // MARK: - INJECTED PROPERTIES
    @Environment(TabsViewModel.self) private var tabsVM
    let tab: TabItem
    
    // MARK: - INITIALIZER
    init(tab: TabItem) {
        self.tab = tab
    }
    
    // MARK: - BODY
    var body: some View {
        Button {
            tabsVM.setTabSelection(tab)
        } label: {
            Image(systemName: tab.systemImage)
                .setForegroundColor(tab, tabsVM.tabSelection)
        }
    }
}

// MARK: - PREVIEWS
#Preview("Tab Button View") {
    TabButtonView(tab: .random())
        .environment(TabsViewModel())
}

// MARK: EXTENSIONS
extension View {
    fileprivate func setForegroundColor(_ tab: TabItem, _ selectedTab: TabItem) -> some View {
        self
            .foregroundStyle(tab == selectedTab ? Color.tabActive : Color.tabInactive)
    }
}
