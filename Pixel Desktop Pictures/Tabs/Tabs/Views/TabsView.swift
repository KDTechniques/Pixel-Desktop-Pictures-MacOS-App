//
//  TabsView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-25.
//

import SwiftUI

struct TabsView: View {
    // MARK: - INJECTED PROPERTIES
    @Environment(TabsViewModel.self) private var tabsVM
    
    // MARK: - BODY
    var body: some View {
        VStack(spacing: 0) {
            HeaderView()
                .background(alignment: .top) { ErrorPopupView() }
            
            TabView(selection: Binding(get: { tabsVM.tabSelection }, set: { _ in })) {
                ForEach(TabItem.allCases, id: \.self) { tab in
                    tab.content
                        .frame(width: TabItem.allWindowWidth)
                        .tag(tab)
                }
                .background(TabBarHiderView())
            }
            .frame(height: tabsVM.selectedTabContentHeight)
            .tabViewStyle(.grouped)
            .zIndex(-1)
        }
        .frame(width: TabItem.allWindowWidth)
        .background(Color.windowBackground)
    }
}

// MARK: - PREVIEWS
#Preview("Tabs View") {
    @Previewable @State var networkManager: NetworkManager = .shared
    TabsView()
        .environment(networkManager)
        .previewModifier
}
