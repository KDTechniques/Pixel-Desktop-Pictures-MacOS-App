//
//  TabsView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-25.
//

import SwiftUI

struct TabsView: View {
    // MARK: - PROPERTIES
    @Environment(TabsViewModel.self) private var tabsVM
    
    // MARK: - BODY
    var body: some View {
        VStack(spacing: 0) {
            HeaderView()
                .background(alignment: .top) { ErrorPopupView() }
            
            TabView(selection: Binding(get: { tabsVM.tabSelection }, set: { _ in })) {
                ForEach(TabItemsModel.allCases, id: \.self) { tab in
                    tab.content
                        .frame(width: TabItemsModel.allWindowWidth)
                        .tag(tab)
                }
                .background(TabBarHiderView())
            }
            .frame(height: tabsVM.selectedTabContentHeight)
            .tabViewStyle(.grouped)
            .zIndex(-1)
        }
        .frame(width: TabItemsModel.allWindowWidth)
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
