//
//  TabButtonView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-25.
//

import SwiftUI

struct TabButtonView: View {
    // MARK: - PROPERTIES
    @Environment(TabsViewModel.self) private var tabsVM
    let tab: TabItems
    
    // MARK: - INITIALIZER
    init(tab: TabItems) {
        self.tab = tab
    }
    
    // MARK: - BODY
    var body: some View {
        Button {
            tabsVM.setTabSelection(tab)
        } label: {
            Image(systemName: tab.systemImage)
        }
        .getForegroundColor(tab, tabsVM.tabSelection)
    }
}

// MARK: - PREVIEWS
#Preview("Tab Button View") {
    TabButtonView(tab: .random())
        .environment(TabsViewModel())
}

// MARK: - EXTENSIONS
extension View {
    // MARK: - Get Foreground Color
    fileprivate func getForegroundColor(_ tab: TabItems, _ selectedTab: TabItems) -> some View {
        self
            .foregroundStyle(tab == selectedTab ? Color.tabActive : Color.tabInactive)
    }
}
